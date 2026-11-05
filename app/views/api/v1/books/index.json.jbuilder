# frozen_string_literal: true

json.data @books, partial: 'api/v1/books/book', as: :book

json.meta do
  json.page @pagy.page
  json.per_page @pagy.limit
  json.total_count @pagy.count
  json.total_pages @pagy.pages
end
