require 'rails_helper'

RSpec.describe Device, type: :model do
  subject { build(:device) }

  describe 'validations' do
    it { is_expected.to belong_to(:user) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:user) }
  end
end
