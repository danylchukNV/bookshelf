# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '#import_report' do
    let(:admin) { create(:admin) }
    let(:import) do
      create(:import, admin: admin, status: 'completed', total_rows: 3, created_count: 2, skipped_count: 1,
                      duration_seconds: 0.05,
                      skipped_rows: [{ line: 4, title: 'Кобзар', author_name: 'Тарас Шевченко',
                                       reason: 'Author "Тарас Шевченко" not found' }])
    end
    let(:mail) { described_class.import_report(admin, import) }

    it 'is sent to the admin' do
      expect(mail.to).to eq([admin.email])
      expect(mail.subject).to eq("Books import ##{import.id}: completed")
    end

    it 'contains the counters and skipped rows' do
      body = mail.text_part.body.decoded
      expect(body).to include('Books created:  2', 'Rows skipped:   1', 'Кобзар')
    end
  end
end
