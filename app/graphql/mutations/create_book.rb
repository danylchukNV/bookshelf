# frozen_string_literal: true

module Mutations
  # createBook(input: { title, authorId, year, description }) { book { ... } errors }
  class CreateBook < BaseMutation
    description 'Creates a book for an existing active author'

    argument :title, String, required: true
    argument :author_id, ID, required: true
    argument :year, Integer, required: true
    argument :description, String, required: false

    field :book, Types::BookType, description: 'Created book, null if there are errors'
    field :errors, [String], null: false, description: 'Validation errors'

    def resolve(title:, author_id:, year:, description: nil)
      author = Author.find_by(id: author_id)
      return failure("Author with id=#{author_id} not found") unless author
      return failure("Author \"#{author.name}\" is inactive") unless author.active?

      book = author.books.build(title: title, year: year, description: description)
      if book.save
        { book: book, errors: [] }
      else
        failure(*book.errors.full_messages)
      end
    end

    private

    def failure(*messages)
      { book: nil, errors: messages }
    end
  end
end
