# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    MAX_LIMIT = 100

    field :books, [Types::BookType], null: false, description: 'List of books with optional filters' do
      argument :title, String, required: false, description: 'Part of the title (case-insensitive)'
      argument :author_id, ID, required: false, description: 'Only books of this author'
      argument :limit, Integer, required: false, default_value: 20, description: "Max number of books (1-#{MAX_LIMIT})"
      argument :offset, Integer, required: false, default_value: 0, description: 'Number of books to skip'
    end

    field :book, Types::BookType, description: 'One book by id, null if not found' do
      argument :id, ID, required: true
    end

    field :authors, [Types::AuthorType], null: false, description: 'List of authors' do
      argument :active_only, Boolean, required: false, default_value: false
    end

    def books(limit:, offset:, title: nil, author_id: nil)
      raise GraphQL::ExecutionError, "limit must be between 1 and #{MAX_LIMIT}" unless limit.between?(1, MAX_LIMIT)
      raise GraphQL::ExecutionError, 'offset must not be negative' if offset.negative?

      scope = Book.order(:id)
      scope = scope.where('books.title ILIKE ?', "%#{Book.sanitize_sql_like(title)}%") if title.present?
      scope = scope.where(author_id: author_id) if author_id.present?
      scope.limit(limit).offset(offset)
    end

    def book(id:)
      Book.find_by(id: id)
    end

    def authors(active_only:)
      scope = Author.order(:name)
      active_only ? scope.active : scope
    end
  end
end
