require 'rails_helper'

RSpec.describe V1::UserSerializer do
  let(:user) { build(:user) }

  subject { described_class.new(user) }

  describe '#to_json' do
    it 'serializes the user' do
      expected_json = {
        id: user.id,
        email: user.email,
        role: user.role,
        access_token: user.access_token
      }

      expect(subject.to_json).to eq(expected_json.to_json)
    end
  end
end
