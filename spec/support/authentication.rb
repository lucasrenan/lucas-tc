RSpec.shared_context 'authenticated admin' do
  let!(:admin) { create(:user, :admin) }

  before do
    request.headers['Authorization'] = "Token token=#{admin.access_token}"
  end
end

RSpec.shared_context 'unauthenticated user' do
  before do
    request.headers['Authorization'] = nil
  end
end
