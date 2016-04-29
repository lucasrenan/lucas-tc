require 'rails_helper'
require "pundit/rspec"

RSpec.describe PostPolicy do
  subject { described_class }

  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user, :user) }
  let(:guest) { create(:user, :guest) }
  let(:post) { build(:post) }
  let(:admin_post) { build(:post, user: admin) }
  let(:user_post) { build(:post, user: user) }

  permissions :create? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, post)
    end

    it 'grants access if user is user' do
      expect(subject).to permit(user, post)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(guest, post)
    end
  end

  permissions :update?, :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, post)
    end

    it 'grants access if user is user and it is his post' do
      expect(subject).to permit(user, user_post)
    end

    it 'denies access if user is user and it is not his post' do
      expect(subject).to_not permit(user, admin_post)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(guest, post)
    end
  end
end
