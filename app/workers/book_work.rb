class BookWork
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform book_id
    book = Book.find book_id
    @users = User.all
    @users.each do |user|
      UserMailer.email_new_book(user, book).deliver_now
    end
  end
end
