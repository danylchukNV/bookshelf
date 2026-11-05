# frozen_string_literal: true

module Types
  class BookType < Types::BaseObject
    description 'A book from the library'

    field :id, ID, null: false
    field :title, String, null: false
    field :year, Integer
    field :description, String
    field :cover_url, String, description: 'URL of the cover image (Shrine), null if there is no cover'
    field :author, Types::AuthorType
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # Loads authors of all requested books with one SQL query (no N+1)
    def author
      dataload_association(:author)
    end
  end
end
