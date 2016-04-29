module Authentication
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods

  included do
    before_action :authenticate
  end

  def current_user
    @current_user
  end

  private
  def authenticate
    if user = authenticate_with_http_token do |token, options|
                User.find_by({access_token: token})
              end
      @current_user = user
    else
      request_http_token_authentication
    end
  end
end
