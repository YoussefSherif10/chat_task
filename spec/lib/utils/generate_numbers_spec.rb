require 'rails_helper'

RSpec.describe Utils::GenerateNumbers, type: :module do
  describe '.generate_number' do
    let(:application) { create(:application, token: 'AppToken-4043') }

    before do
      # Clear the database before each test to avoid contamination
      Chat.destroy_all
    end

    context 'when there are existing numbers' do
      let!(:chat1) { create(:chat, number: 1, application: application) }
      let!(:chat2) { create(:chat, number: 2, application: application) }

      it 'returns the next number' do
        next_number = Utils::GenerateNumbers.generate_number(entity: Chat)
        expect(next_number).to eq(3)
      end
    end

    context 'when there are no existing numbers' do
      it 'returns 1' do
        next_number = Utils::GenerateNumbers.generate_number(entity: Chat)
        expect(next_number).to eq(1)
      end
    end

    context 'when some records have nil numbers' do
      let!(:chat1) { create(:chat, number: 1, application: application) }
      let!(:chat2) { create(:chat, number: nil, application: application) }

      it 'ignores records with nil numbers and generates a valid number' do
        next_number = Utils::GenerateNumbers.generate_number(entity: Chat)
        expect(next_number).to eq(3)
      end
    end
  end
end
