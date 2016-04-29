require 'rails_helper'

RSpec.describe V1::AuthenticationController, type: :controller do
  describe 'POST #create' do
    context 'with valid credentials' do
      let!(:user) { create(:user, email: 'jobs@apple.com', password: '123456') }

      before do
        allow_any_instance_of(User).to receive(:generate_access_token!)
        allow_any_instance_of(User).to receive(:access_token)
          .and_return('token_123')

        post :create, params: { email: user.email, password: user.password }
      end

      it 'returns created' do
        expect(response).to be_created
      end

      it 'returns data with user' do
        expect(response_data).to eq({
          'id' => user.id,
          'email' => user.email,
          'role' => user.role,
          'access_token' => 'token_123'
        })
      end
    end

    context 'with invalid credentials' do
      let!(:user) { create(:user, email: 'jobs@apple.com', password: '123456') }

      context 'when e-mail is invalid' do
        before do
          post :create, params: { email: 'invalid@email.com', password: user.password }
        end

        it 'returns unauthorized' do
          expect(response).to be_unauthorized
        end

        it 'returns error with message' do
          expect(response_errors['base'][0]['message']).to eq('Not authenticated')
        end
      end

      context 'when password is invalid' do
        before do
          post :create, params: { email: user.email, password: 'invalid_pass' }
        end

        it 'returns unauthorized' do
          expect(response).to be_unauthorized
        end

        it 'returns error with message' do
          expect(response_errors['base'][0]['message']).to eq('Not authenticated')
        end
      end

      context 'when both e-mail and password are invalid' do
        before do
          post :create, params: { email: 'invalid@email.com', password: 'invalid_pass' }
        end

        it 'returns unauthorized' do
          expect(response).to be_unauthorized
        end

        it 'returns error with message' do
          expect(response_errors['base'][0]['message']).to eq('Not authenticated')
        end
      end
    end
  end
end
