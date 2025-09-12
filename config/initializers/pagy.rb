# frozen_string_literal: true

require 'pagy/extras/overflow'
require 'pagy/extras/array'
require 'pagy/extras/bootstrap'

Pagy::DEFAULT[:items] = 25
Pagy::DEFAULT[:overflow] = :empty_page
