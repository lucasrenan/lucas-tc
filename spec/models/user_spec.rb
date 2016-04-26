require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
    it { is_expected.to have_many(:posts) }
    it { is_expected.to have_many(:devices) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:role) }

    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value('lucas@test.com').for(:email) }
    it { is_expected.to validate_uniqueness_of(:access_token) }

    # should-matchers tries to validate :role as fixnum, so the test fails
    # https://github.com/thoughtbot/shoulda-matchers/blob/b58f0a1807a4346399aa3b9bb5b88923ab9aa2e5/lib/shoulda/matchers/active_model/validate_inclusion_of_matcher.rb#L487
    # it { is_expected.to validate_inclusion_of(:role).in_array(User::ROLES) }
  end

  describe '#generate_access_token!' do
    let(:user) { build(:user, access_token: nil) }

    before do
      expect(SecureRandom).to receive_message_chain(:urlsafe_base64, :tr)
        .and_return('token_123')
    end

    it 'generated an access token' do
      user.generate_access_token!

      expect(user.access_token).to eq('token_123')
    end
  end
end
