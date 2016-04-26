require 'rails_helper'
require Rails.root.join('spec/support/models/person_test')

RSpec.describe ApiResponder::V1, type: :controller do
  controller(ApplicationController) do
    include ::ApiResponder::V1
    include ::Exceptions

    def index
      data = { a: 123, b: 456 }
      render json: api_response(data: data)
    end

    def record_not_found
      fail ActiveRecord::RecordNotFound, 'Record Not Found'
    end

    def record_invalid
      person = PersonTest.new
      person.valid?
      fail ActiveRecord::RecordInvalid, person
    end

    def with_required_param
      params.require(:required_param)
    end

    def unauthenticated
      raise Exceptions::NotAuthorized
    end

    def custom_error
      render_error_response('Looping!', 508)
    end
  end

  let(:response_data) do
    {
      data: {},
      errors: {},
      meta: { api_version: '1' }
    }
  end

  describe 'when making a successful request' do
    let(:json) do
      response_data.merge(data: { a: 123, b: 456 }).to_json
    end

    before { get :index }

    it { expect(response.body).to eq(json) }
  end

  context 'when requesting a non-existing record' do
    let(:json) do
      response_data.merge(errors: {
                            base: [{
                              message: 'Resource not found',
                              params: {}
                            }]
                          }).to_json
    end

    before do
      routes.draw { get 'record_not_found' => 'anonymous#record_not_found' }
      expect(controller).to receive(:log_exception)
      get :record_not_found
    end

    it { expect(response).to_not be_successful }
    it { expect(response.body).to be_json_eql(json) }
  end

  context 'when updating a record with invalid data' do
    let(:locale) { 'en' }
    let(:errors) { { name: ["can't be blank"] } }
    let(:json)   { (response_data.merge errors: errors).to_json }

    around do |example|
      I18n.locale = locale
      example.run
      I18n.locale = 'en'
    end

    before do
      routes.draw { get 'record_invalid' => 'anonymous#record_invalid' }
      get :record_invalid
    end

    it { expect(response).to_not be_successful }
    it { expect(response.body).to be_json_eql(json) }

    describe 'with a locale that specifies attribute names' do
      let(:locale) { 'en-test' }

      it { expect(response.body).to have_json_path('errors/full_name') }
      it { expect(response.body).to_not have_json_path('errors/name') }
    end
  end

  context 'when updating a record with a missing parameter' do
    let(:errors) { { name: ["can't be blank"] } }
    let(:json_response) { parse_json(response.body) }

    before do
      routes
        .draw { post 'with_required_param' => 'anonymous#with_required_param' }
      post :with_required_param
    end

    it { expect(response).to_not be_successful }

    it 'returns an error' do
      expect(response.status).to eq(422)
      expect(json_response['errors']['base'][0]['message'])
        .to eq('param is missing or the value is empty: required_param')
    end
  end

  context 'when not authenticated' do
    let(:json) do
      response_data.merge(errors: {
                            base: [{
                              message: 'not authorized',
                              params: {}
                            }]
                          }).to_json
    end

    before do
      routes.draw { get 'unauthenticated' => 'anonymous#unauthenticated' }
      expect(controller).to receive(:log_exception)
      get :unauthenticated
    end

    it { expect(response).to_not be_successful }
    it { expect(response.body).to be_json_eql(json) }
  end

  describe '#render_error_response"' do
    before do
      routes.draw { get 'custom_error' => 'anonymous#custom_error' }
    end

    it 'responds with the message correctly formatted' do
      expected_body = response_data.merge(errors: {
                                            base: [{
                                              message: 'Looping!',
                                              params: { format: 'json' }
                                            }]
                                          }).to_json

      get :custom_error, format: :json

      expect(response.body).to be_json_eql(expected_body)
    end

    it 'responds with the right status code' do
      get :custom_error, format: :json

      expect(response.status).to eq(508)
    end

    it 'removes sensitive information from the params list' do
      expected_body = response_data.merge(errors: {
                                            base: [{
                                              message: 'Looping!',
                                              params: {
                                                format: 'json',
                                                foo: 'bar'
                                              }
                                            }]
                                          }).to_json

      get :custom_error, params: {
                          format: :json,
                          foo: 'bar',
                          password: 'pass',
                          access_token: 'token'
                         }

      expect(response.body).to be_json_eql(expected_body)
    end
  end
end
