# frozen_string_literal: true

class CoverUploader < Shrine
  MAX_SIZE = 5 * 1024 * 1024
  ALLOWED_TYPES = %w[image/jpeg image/png image/webp image/gif].freeze
  ALLOWED_EXTENSIONS = %w[jpg jpeg png webp gif].freeze

  Attacher.validate do
    validate_max_size MAX_SIZE, message: 'is too large (maximum is 5 MB)'
    validate_mime_type ALLOWED_TYPES, message: 'must be a JPEG, PNG, WebP or GIF image'
    validate_extension ALLOWED_EXTENSIONS, message: 'must have a jpg, png, webp or gif extension'
  end
end
