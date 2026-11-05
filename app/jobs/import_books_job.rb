# frozen_string_literal: true

require 'csv'

# Creates books from a CSV file with the columns: title, author_name, year, description.
# A book is created only for an author that already exists; other rows are skipped
# and the reason is saved in import.skipped_rows. A report is e-mailed to the admin at the end.
class ImportBooksJob < ApplicationJob
  queue_as :default

  REQUIRED_HEADERS = %w[title author_name].freeze

  def perform(import_id, csv_content)
    import = Import.find(import_id)
    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    import.update!(status: 'processing', started_at: Time.current)

    process_rows(import, parse(csv_content))
    import.status = 'completed'
  rescue CSV::MalformedCSVError, ArgumentError => e
    import.status = 'failed'
    import.error_message = e.message
  ensure
    if import
      import.finished_at = Time.current
      import.duration_seconds = (Process.clock_gettime(Process::CLOCK_MONOTONIC) - started).round(3)
      import.save!
      log_result(import)
      UserMailer.import_report(import.admin, import).deliver_now
    end
  end

  private

  def parse(content)
    content = content.to_s.dup.force_encoding('UTF-8').delete_prefix("\uFEFF") # remove BOM added by Excel
    table = CSV.parse(content, headers: true, skip_blanks: true,
                               header_converters: ->(h) { h.to_s.strip.downcase })
    missing = REQUIRED_HEADERS - table.headers.compact
    raise ArgumentError, "Missing required columns: #{missing.join(', ')}" if missing.any?

    table
  end

  def process_rows(import, table)
    authors = Author.all.index_by { |a| a.name.strip.downcase }
    skipped = []
    created = 0

    table.each.with_index(2) do |row, line| # line 1 is the header
      reason = import_row(row, authors)
      if reason
        skipped << { line: line, title: row['title'].to_s.strip, author_name: row['author_name'].to_s.strip,
                     reason: reason }
      else
        created += 1
      end
    end

    import.assign_attributes(total_rows: table.size, created_count: created,
                             skipped_count: skipped.size, skipped_rows: skipped)
  end

  # Returns nil when the book was created, otherwise the reason why the row was skipped.
  def import_row(row, authors)
    title = row['title'].to_s.strip
    author_name = row['author_name'].to_s.strip
    return 'Title is empty' if title.empty?

    author = authors[author_name.downcase]
    return "Author \"#{author_name}\" not found" unless author
    return 'Book already exists' if author.books.where('LOWER(title) = ?', title.downcase).exists?

    book = author.books.build(title: title, year: row['year'].to_s.strip.presence,
                              description: row['description'].to_s.strip.presence)
    book.save ? nil : book.errors.full_messages.to_sentence
  end

  def log_result(import)
    Rails.logger.info(
      "[ImportBooksJob] import ##{import.id} #{import.status}: total=#{import.total_rows} " \
      "created=#{import.created_count} skipped=#{import.skipped_count} time=#{import.duration_seconds}s"
    )
  end
end
