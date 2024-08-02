require 'rails_helper'

RSpec.describe Chat, type: :model do
  describe 'associations' do
    let(:chat) { build(:chat) }

    it 'belongs to application' do
      association = Chat.reflect_on_association(:application)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:counter_cache]).to be true
    end

    it 'has many messages with dependent destroy' do
      association = Chat.reflect_on_association(:messages)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  describe 'callbacks' do
    let(:chat) { build(:chat) }

    before do
      allow(Utils::GenerateNumbers).to receive(:generate_number).and_return(1)
      chat.save
    end

    context 'before_create' do
      it 'sets the chat number' do
        expect(chat.number).to eq(1)
      end
    end
  end
end
