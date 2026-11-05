# frozen_string_literal: true

module Api
  module V1
    # Base class for the JSON API. It inherits from ActionController::API
    # (no sessions, cookies or CSRF) and renders every error as JSON.
    class BaseController < ActionController::API
      include Pagy::Backend

      class BadRequest < StandardError; end

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from BadRequest, with: :render_bad_request

      private

      def render_not_found(exception)
        render_errors(:not_found, 'Not found', "#{exception.model || 'Record'} with id=#{params[:id]} not found")
      end

      def render_bad_request(exception)
        render_errors(:bad_request, 'Bad request', exception.message)
      end

      def render_errors(status, title, detail)
        render json: { errors: [{ status: Rack::Utils.status_code(status), title:, detail: }] }, status:
      end

      # Reads an optional positive integer query parameter, e.g. ?page=2.
      def positive_integer_param(name, default: nil, max: nil)
        value = params[name]
        return default if value.blank?

        unless value.to_s.match?(/\A\d+\z/) && value.to_i.positive?
          raise BadRequest, "#{name} must be a positive integer"
        end
        raise BadRequest, "#{name} must not be greater than #{max}" if max && value.to_i > max

        value.to_i
      end
    end
  end
end
