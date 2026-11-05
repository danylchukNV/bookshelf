# frozen_string_literal: true

module Api
  module V1
    class BooksController < BaseController
      DEFAULT_PER_PAGE = 10
      MAX_PER_PAGE = 100

      # GET /api/v1/books?page=1&per_page=10&title=ліс&author_id=2
      def index
        books = Book.includes(:author).order(:id)
        books = books.where('books.title ILIKE ?', "%#{Book.sanitize_sql_like(params[:title])}%") if params[:title].present?

        author_id = positive_integer_param(:author_id)
        books = books.where(author_id:) if author_id

        @pagy, @books = pagy(books,
                             page: positive_integer_param(:page, default: 1),
                             limit: positive_integer_param(:per_page, default: DEFAULT_PER_PAGE, max: MAX_PER_PAGE))
      end

      # GET /api/v1/books/:id
      def show
        @book = Book.includes(:author).find(params[:id])
      end
    end
  end
end
