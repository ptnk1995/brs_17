class Book < ActiveRecord::Base
  include Bootsy::Container

  belongs_to :category

  has_many :users, through: :book_users
  has_many :book_users, dependent: :destroy
  has_many :reviews, dependent: :destroy

  after_commit :send_mail_new_book, on: :create

  extend FriendlyId
  friendly_id :title, use: :slugged

  mount_uploader :cover, CoverUploader

  validates :title, presence: true
  validates :author, presence: true
  validates :num_pages, presence: true, numericality: {minimum: 1}
  validates :publish_date, presence: true
  validates :category, presence: true
  validate :check_day_present, on: [:create, :update]

  def cover_default
    cover.present? ? cover : Settings.book.cover_default
  end

  private
  UNRANSACKABLE_ATTRIBUTES = ["id", "updated_at", "category_id", "created_at", "slug", "description"]

  def self.ransackable_attributes auth_object = nil
    column_names - UNRANSACKABLE_ATTRIBUTES + _ransackers.keys
  end

  def check_day_present
    errors.add :publish_date,
      I18n.t("error.wrong_date") if self.publish_date.present? && self.publish_date.to_date > Date.today
  end

  def send_mail_new_book
    BookWork.perform_async self.id
  end
end
