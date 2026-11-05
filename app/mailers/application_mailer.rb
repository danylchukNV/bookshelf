# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'bookshelf@example.com'
  layout 'mailer'
end
