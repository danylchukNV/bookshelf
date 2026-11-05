# frozen_string_literal: true

module Types
  class AuthorType < Types::BaseObject
    description 'An author of books'

    field :id, ID, null: false
    field :name, String, null: false
    field :bio, String
    field :active, Boolean, null: false, description: 'Only active authors can get new books'
    field :books, [Types::BookType], null: false, description: "Author's books"

    # Loads books of all requested authors with one SQL query (no N+1)
    def books
      dataload_association(:books)
    end
  end
end
