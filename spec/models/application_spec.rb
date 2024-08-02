require 'rails_helper'

RSpec.describe Application, type: :model do
  let!(:highest_token_application) { create(:application, token: 'AppToken-1000') }

  describe 'validations' do
    let (:application1) { build(:application, name: nil) }

    it 'validates presence of name' do
      expect(application1).not_to be_valid
      expect(application1.errors[:name]).to include("can't be blank")
    end

    let(:application) { build(:application, token: highest_token_application.token) }

    it 'validates uniqueness of token' do
      expect(application).not_to be_valid
      expect(application.errors[:token]).to include('has already been taken')
    end
  end

  describe 'associations' do
    let(:association) { Application.reflect_on_association(:chats) }

    it 'has many chats with dependent destroy' do
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  context 'when token already exists' do
    it 'raises a validation error' do
      expect {
        create(:application, token: highest_token_application.token)
      }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Token has already been taken')
    end
  end
end
