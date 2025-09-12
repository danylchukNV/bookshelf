# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_exception
    rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
    rescue_from ActiveRecord::RecordInvalid, ActiveModel::ValidationError, with: :handle_record_invalid

    before_action :set_sentry_context
  end

  def handle_parameter_missing(exception)
    render json: format_error_message(details: exception.message, title: 'Parameter missing'),
           status: :bad_request
  end

  def handle_record_invalid(exception)
    record = exception.respond_to?(:model) ? exception.model : exception.record

    error_list = record.errors.map do |error|
      attribute = error.attribute
      message = error.message

      {
        title: "#{attribute.to_s.humanize} validation failed",
        detail: record.errors.full_message(attribute, message),
        field: attribute
      }
    end

    render json: { errors: error_list }, status: :unprocessable_entity
  end

  def handle_record_not_found(exception)
    unless Rails.env.production?
      return render json: format_error_message(details: [exception.message], title: 'Not found'),
                    status: :not_found
    end

    render json: format_error_message(details: ["Couldn't find content"], title: 'Not found'),
           status: :not_found
  end

  def handle_exception(exception)
    logger.fatal "API MESSAGE: #{exception.message}"
    logger.fatal "API BACKTRACE: \n\t #{exception.backtrace.grep_v(%r{/gems/}).join("\n\t")}"

    render json: format_error_message(details: [exception.message], title: 'Internal server error'),
           status: :internal_server_error
  end

  def format_error_message(details:, title: I18n.t('error'))
    errors = details.map { |detail| { title:, detail: } }

    { errors: }
  end

  def set_sentry_context
    Sentry.set_extras(params: params.to_unsafe_h, url: request.url)
    return if current_user.nil?

    Sentry.set_user(id: current_user.id, email: current_user.email)
  end
end
