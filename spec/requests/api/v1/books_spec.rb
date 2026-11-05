# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API V1 Books' do
  let(:json) { response.parsed_body }

  describe 'GET /api/v1/books' do
    let!(:author) { create(:author, name: 'Леся Українка') }
    let!(:other_author) { create(:author, name: 'Іван Багряний') }
    let!(:forest_song) { create(:book, title: 'Лісова пісня', year: 1911, author:) }
    let!(:tiger_hunters) { create(:book, title: 'Тигролови', year: 1944, author: other_author) }

    context 'without parameters' do
      before { get '/api/v1/books' }

      it 'returns 200 OK' do
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq('application/json')
      end

      it 'returns books with the expected JSON structure' do
        expect(json.keys).to contain_exactly('data', 'meta')
        expect(json['data'].size).to eq(2)
        expect(json['data'].first.keys)
          .to contain_exactly('id', 'title', 'year', 'description', 'author', 'created_at', 'updated_at')
        expect(json['data'].first['author']).to eq('id' => author.id, 'name' => 'Леся Українка')
      end

      it 'returns pagination metadata' do
        expect(json['meta']).to eq('page' => 1, 'per_page' => 10, 'total_count' => 2, 'total_pages' => 1)
      end
    end

    context 'with pagination' do
      before do
        create_list(:book, 13, author:)
        get '/api/v1/books', params: { page: 2, per_page: 5 }
      end

      it 'returns the requested page' do
        expect(response).to have_http_status(:ok)
        expect(json['data'].size).to eq(5)
        expect(json['meta']).to include('page' => 2, 'per_page' => 5, 'total_count' => 15, 'total_pages' => 3)
      end
    end

    it 'returns an empty page when the page number is beyond the last page' do
      get '/api/v1/books', params: { page: 99 }

      expect(response).to have_http_status(:ok)
      expect(json['data']).to eq([])
    end

    it 'filters books by part of the title' do
      get '/api/v1/books', params: { title: 'сова' }

      expect(json['data'].pluck('id')).to eq([forest_song.id])
    end

    it 'filters books by title case-insensitively' do
      programmer = create(:book, title: 'The Pragmatic Programmer', author:)
      get '/api/v1/books', params: { title: 'PRAGMATIC' }

      expect(json['data'].pluck('id')).to eq([programmer.id])
    end

    it 'filters books by author_id' do
      get '/api/v1/books', params: { author_id: other_author.id }

      expect(json['data'].pluck('id')).to eq([tiger_hunters.id])
    end

    it 'returns an empty list when no book matches the filters' do
      get '/api/v1/books', params: { title: 'Тигр', author_id: author.id }

      expect(response).to have_http_status(:ok)
      expect(json['data']).to eq([])
      expect(json['meta']['total_count']).to eq(0)
    end

    it 'returns author as null for a book without author' do
      create(:book, title: 'Без автора', author: nil)
      get '/api/v1/books', params: { title: 'Без автора' }

      expect(json['data'].first['author']).to be_nil
    end

    context 'with invalid parameters' do
      it 'returns 400 when per_page is not a positive integer' do
        get '/api/v1/books', params: { per_page: 'abc' }

        expect(response).to have_http_status(:bad_request)
        expect(json['errors'].first).to include('status' => 400, 'detail' => 'per_page must be a positive integer')
      end

      it 'returns 400 when per_page is greater than 100' do
        get '/api/v1/books', params: { per_page: 101 }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns 400 when page is zero' do
        get '/api/v1/books', params: { page: 0 }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns 400 when author_id is not a number' do
        get '/api/v1/books', params: { author_id: 'leso' }

        expect(response).to have_http_status(:bad_request)
        expect(json['errors'].first['detail']).to eq('author_id must be a positive integer')
      end
    end
  end

  describe 'GET /api/v1/books/:id' do
    let(:book) { create(:book, title: 'Собор', year: 1968) }

    it 'returns the book' do
      get "/api/v1/books/#{book.id}"

      expect(response).to have_http_status(:ok)
      expect(json['data']).to include('id' => book.id, 'title' => 'Собор', 'year' => 1968)
      expect(json['data']['author']).to eq('id' => book.author.id, 'name' => book.author.name)
    end

    it 'returns 404 with an error message when the book does not exist' do
      get '/api/v1/books/0'

      expect(response).to have_http_status(:not_found)
      expect(json['errors'].first).to include('status' => 404, 'title' => 'Not found',
                                              'detail' => 'Book with id=0 not found')
    end
  end
end
