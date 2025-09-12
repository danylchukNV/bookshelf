# frozen_string_literal: true

Rails.application.config.generators do |g|
  # Disable generators we don't need.
  g.javascripts false
  g.stylesheets false
  g.fixture_replacement :factory_bot, dir: 'spec/factories'
  g.test_framework :rspec, fixture: true
  g.helper_specs false
  g.view_specs false
end
