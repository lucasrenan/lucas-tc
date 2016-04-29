module V1
  class AuthenticationController < BaseController
    skip_before_action :authenticate, only: [:create]

    def create
      user = User.find_by({email: user_params[:email]})

      if user && user.authenticate(user_params[:password])
        user.generate_access_token!
        user.save!
        data = UserSerializer.new(user)
        render json: api_response(data: data), status: :created
      else
        raise Exceptions::NotAuthorized
      end
    end

    private
    def user_params
      params.permit(:email, :password)
    end
  end
end
