# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/file_system'

# Files are stored on the local disk:
#   public/uploads/cache – temporary files between form submissions,
#   public/uploads/store – permanently attached files.
# An S3-compatible storage (Shrine::Storage::S3) can replace FileSystem in production.
uploads_root = Rails.env.test? ? Rails.root.join('tmp/test_uploads').to_s : 'public'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new(uploads_root, prefix: 'uploads/cache'),
  store: Shrine::Storage::FileSystem.new(uploads_root, prefix: 'uploads/store')
}

Shrine.plugin :activerecord            # integrates attachments with Active Record models
Shrine.plugin :cached_attachment_data  # keeps the uploaded file when the form is re-rendered with errors
Shrine.plugin :restore_cached_data     # re-reads metadata of cached files
Shrine.plugin :determine_mime_type, analyzer: :marcel # detects MIME type from file content
Shrine.plugin :validation_helpers      # validate_max_size, validate_mime_type, ...
Shrine.plugin :validation
Shrine.plugin :remove_attachment       # "remove cover" checkbox
