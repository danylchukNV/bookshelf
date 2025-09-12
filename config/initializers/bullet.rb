# frozen_string_literal: true

unless Rails.env.production?
  Rails.application.config.after_initialize do
    Bullet.enable = true
    Bullet.sentry = true
    Bullet.rails_logger = true
    Bullet.skip_html_injection = true
  end
end
