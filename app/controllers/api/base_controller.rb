# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    include ResultMatcher
    include ExceptionHandler
    include Pagy::Backend

    skip_forgery_protection

    respond_to :json

    def pagination_params
      params.permit(:page, :items).to_h.each_with_object({}) do |(k, v), memo|
        memo[k.to_sym] = v.to_i
      end
    end
  end
end
