require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    let(:message) { build(:message) }

    it 'belongs to chat' do
      association = Message.reflect_on_association(:chat)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:counter_cache]).to be true
    end
  end

  describe 'callbacks' do
    let(:message) { build(:message) }

    before do
      allow(Utils::GenerateNumbers).to receive(:generate_number).and_return(1)
      message.save
    end

    context 'before_create' do
      it 'sets the message number' do
        expect(message.number).to eq(1)
      end
    end
  end
end
