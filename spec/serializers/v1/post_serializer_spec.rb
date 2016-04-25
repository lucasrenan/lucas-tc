require 'rails_helper'

RSpec.describe V1::PostSerializer do
  let(:post) { build(:post) }

  subject { described_class.new(post) }

  describe '#to_json' do
    it 'serializes the post' do
      expected_json = {
        id: post.id,
        title: post.title,
        text: post.text,
        user_id: post.user_id
      }

      expect(subject.to_json).to eq(expected_json.to_json)
    end
  end
end
