require 'rails_helper'

RSpec.describe Authentication, type: :controller do
  controller(ApplicationController) do
    include ::Authentication

    def index
      render json: :ok
    end
  end

  describe 'authentication' do
    context 'when user authenticated successfully' do
      include_context 'authenticated admin'

      before do
        get :index
      end

      it 'returns success' do
        expect(response).to be_success
      end

      it 'sets current_user' do
        expect(controller.current_user).to eq(admin)
      end
    end

    context 'when user can not authenticate' do
      include_context 'unauthenticated user'

      before do
        get :index
      end

      it 'returns error' do
        expect(response.body).to eq("HTTP Token: Access denied.\n")
      end

      it 'does not set current_user' do
        expect(controller.current_user).to be_nil
      end
    end
  end
end
