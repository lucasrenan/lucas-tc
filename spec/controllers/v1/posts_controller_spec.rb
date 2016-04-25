require 'rails_helper'

RSpec.describe V1::PostsController, type: :controller do
  let(:user) { create(:user) }

  def valid_attributes
    attributes_for(:post).merge(user_id: user.id)
  end

  def invalid_attributes
    { title: '' }
  end

  describe 'GET #index' do
    let!(:post) { create(:post) }

    before do
      get :index
    end

    it 'returns success' do
      expect(response).to be_success
    end

    it 'returns data with posts' do
      expect(response_data).to eq([{
        'id' => post.id,
        'title' => post.title,
        'text' => post.text,
        'user_id'=> post.user_id
      }])
    end
  end

  describe "GET #show" do
    let!(:post) { create(:post) }

    before do
      get :show, params: { id: post.id }
    end

    it 'returns success' do
      expect(response).to be_success
    end

    it 'returns data with post' do
      expect(response_data).to eq({
        'id' => post.id,
        'title' => post.title,
        'text' => post.text,
        'user_id'=> post.user_id
      })
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'returns created' do
        post :create, params: valid_attributes

        expect(response).to be_created
      end

      it 'creates a new post' do
        expect {
          post :create, params: valid_attributes
        }.to change(Post, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'retuns unprocessable entity' do
        post :create, params: invalid_attributes

        expect(response).to be_unprocessable
      end

      it 'does not create a new post' do
        expect {
          post :create, params: invalid_attributes
        }.to_not change(Post, :count).from(0)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let!(:post) { create(:post) }

      before do
        put :update, params: { id: post.id, title: 'updated title' }
      end

      it 'returns success' do
        expect(response).to be_success
      end

      it 'updates the requested post' do
        expect(post.reload.title).to eq('updated title')
      end
    end

    context 'with invalid params' do
      let!(:post) { create(:post) }

      before do
        put :update, params: { id: post.id, title: '' }
      end

      it 'returns unprocessable entity' do
        expect(response).to be_unprocessable
      end

      it 'does not update the requested post' do
        title = post.title
        expect(post.reload.title).to eq(title)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:post) { create(:post) }

    it 'returns no content' do
      delete :destroy, params: { id: post.id }

      expect(response).to be_no_content
    end

    it 'destroys the requested post' do
      expect {
        delete :destroy, params: { id: post.id }
      }.to change(Post, :count).by(-1)
    end
  end
end
