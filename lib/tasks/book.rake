namespace :book do
  desc "Calculate average rating of a book"
  task average_rating: :environment do
    books = Book.all
    books.each do |book|
      rate = book.reviews.average :score
      book.update rate: rate
    end
  end
end
