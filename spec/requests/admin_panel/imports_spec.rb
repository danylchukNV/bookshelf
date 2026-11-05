# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin imports', type: :request do
  let(:admin) { create(:admin) }
  let(:csv) { fixture_file_upload('books_import.csv', 'text/csv') }

  it 'is not available for guests' do
    get new_admin_import_path
    expect(response).to redirect_to(new_admin_session_path)
  end

  context 'when admin is signed in' do
    before do
      sign_in admin
      create(:author, name: 'Леся Українка')
    end

    it 'runs the import and shows the result' do
      perform_enqueued_jobs do
        post admin_imports_path, params: { file: csv }
      end

      import = Import.last
      expect(response).to redirect_to(admin_import_path(import))
      expect(import.reload).to be_completed
      expect(import.created_count).to eq(1)
      expect(import.admin).to eq(admin)
    end

    it 'rejects a non-CSV file' do
      post admin_imports_path, params: { file: fixture_file_upload('cover.png', 'image/png') }
      expect(response).to redirect_to(new_admin_import_path)
      expect(Import.count).to eq(0)
    end
  end
end
