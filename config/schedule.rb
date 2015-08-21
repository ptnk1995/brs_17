env :PATH, ENV["PATH"]

every 1.month, at: "end of the month at 11:59pm" do
  rake "request:delete_request", environment: :development
end

every 12.hours do
  rake "book:average_rating", environment: :development
end
