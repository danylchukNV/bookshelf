# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'
require 'simplecov-cobertura'

SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/' # for rspec
  add_filter '/test/' # for minitest

  add_filter '/app/channels/'
  add_filter '/app/models/'
  add_filter '/app/helpers/'
  add_filter '/app/controllers/admin_panel/' # it is optional to write tests for admin panel
  add_filter '/app/controllers/concerns/'
  add_filter '/lib/tasks/'

  add_filter do |source_file|
    source_file.lines.count < 20 # skip files with < 20 lines of code
  end

  add_group 'Forms', 'app/forms'
  add_group 'Policies', 'app/policies'
  add_group 'Services', 'app/services'

  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::JSONFormatter,
    SimpleCov::Formatter::CoberturaFormatter
  ])
end
