module ApiResponder
  # Api V1 lib to deal with some responses
  module V1
    extend ActiveSupport::Concern
    include Translate

    PARAMS_BLACKLIST = %i(controller action password access_token).freeze

    included do
      rescue_from 'ActiveRecord::RecordInvalid', with: :return_422
      rescue_from 'ActiveRecord::RecordNotFound', with: :return_404
      rescue_from 'ActionController::ParameterMissing', with: :return_422
    end

    def api_response(options = {})
      options.reverse_merge!(data: {}, errors: {}, meta: {})
      options[:meta][:api_version] ||= '1'
      options
    end

    private

    def build_errors(message)
      {
        base: [{
          message: message,
          params: params.except(*PARAMS_BLACKLIST)
        }]
      }
    end

    def render_error_response(message, status)
      errors = build_errors(message)
      render json: api_response(errors: errors), status: status
    end

    def log_exception(exception)
      return unless logger.present?
      logger.warn "#{exception.class}: '#{exception.message}'"\
                  " thrown from: #{exception.backtrace[0..10]}"
    end

    def return_401(exception)
      log_exception(exception)
      render_error_response(exception.message, 401)
    end

    def return_404(exception)
      log_exception(exception)
      render_error_response('Resource not found', 404)
    end

    def return_422(exception)
      log_exception(exception)

      errors =
        if exception.respond_to? :record
          translate_exception(exception, :v1)
        else
          build_errors(exception.message)
        end

      render json: api_response(errors: errors), status: 422
    end
  end
end
