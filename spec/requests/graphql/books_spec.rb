# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GraphQL books', type: :request do
  let(:json) { response.parsed_body }

  def graphql(query, variables = {})
    post '/graphql', params: { query: query, variables: variables.to_json }
  end

  describe 'query books' do
    let(:author) { create(:author, name: 'Леся Українка') }

    before do
      create(:book, title: 'Лісова пісня', year: 1911, author: author)
      create(:book, title: 'Камінний господар', year: 1912, author: author)
      create(:book, title: 'Other book')
    end

    let(:query) do
      <<~GRAPHQL
        query($title: String, $authorId: ID) {
          books(title: $title, authorId: $authorId) { id title year author { name } }
        }
      GRAPHQL
    end

    it 'returns only the requested fields' do
      graphql(query)
      books = json.dig('data', 'books')
      expect(books.size).to eq(3)
      expect(books.first.keys).to contain_exactly('id', 'title', 'year', 'author')
    end

    it 'filters by title and author' do
      graphql(query, title: 'ліс', authorId: author.id)
      expect(json.dig('data', 'books').pluck('title')).to eq(['Лісова пісня'])
      expect(json.dig('data', 'books', 0, 'author', 'name')).to eq('Леся Українка')
    end

    it 'returns an error for a wrong limit' do
      graphql('{ books(limit: 0) { id } }')
      expect(json['errors'].first['message']).to include('limit')
    end
  end

  describe 'mutation createBook' do
    let(:mutation) do
      <<~GRAPHQL
        mutation($input: CreateBookInput!) {
          createBook(input: $input) { book { id title year author { name } } errors }
        }
      GRAPHQL
    end
    let(:author) { create(:author, name: 'Олесь Гончар') }

    it 'creates a book' do
      expect do
        graphql(mutation, input: { title: 'Берег любові', authorId: author.id, year: 1976 })
      end.to change(Book, :count).by(1)

      result = json.dig('data', 'createBook')
      expect(result['errors']).to be_empty
      expect(result['book']).to include('title' => 'Берег любові', 'year' => 1976)
      expect(result.dig('book', 'author', 'name')).to eq('Олесь Гончар')
    end

    it 'returns validation errors' do
      expect do
        graphql(mutation, input: { title: '', authorId: author.id, year: 1800 })
      end.not_to change(Book, :count)

      result = json.dig('data', 'createBook')
      expect(result['book']).to be_nil
      expect(result['errors']).to include("Title can't be blank")
    end

    it 'does not create a book for an unknown author' do
      graphql(mutation, input: { title: 'X', authorId: 0, year: 2000 })
      expect(json.dig('data', 'createBook', 'errors')).to eq(['Author with id=0 not found'])
    end
  end
end
