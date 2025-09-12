# frozen_string_literal: true

module AdminPanel
  class BaseController < ApplicationController
    include Pagy::Backend

    protect_from_forgery with: :exception

    before_action :authenticate_admin!

    layout 'admin'

    private

    def pagination_params
      params.permit(:page, :items).to_h.each_with_object({}) do |(k, v), memo|
        memo[k.to_sym] = v.to_i
      end
    end
  end
end
