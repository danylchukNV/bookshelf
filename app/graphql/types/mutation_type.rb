# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_book, mutation: Mutations::CreateBook
  end
end
