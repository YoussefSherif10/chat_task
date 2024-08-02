require 'rails_helper'

RSpec.describe V1::ChatsController, type: :controller do
  let!(:application) { create(:application, token: 'AppToken-5050') }
  let!(:chat) { create(:chat, application: application) }
  let(:valid_attributes) { { application_token: application.token } }
  let(:invalid_attributes) { { application_token: nil } }

  before do
    allow(Utils::GenerateNumbers).to receive(:generate_number).and_return(1)
  end

  describe 'GET #index' do
    before { get :index, params: { application_token: application.token } }

    it 'returns a success response' do
      expect(response).to be_successful
    end

    it 'returns paginated chats' do
      json_response = JSON.parse(response.body)
      expect(json_response['data']).not_to be_empty
    end
  end

  describe 'GET #show' do
    context 'with valid number' do
      before { get :show, params: { application_token: application.token, number: chat.number } }

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns the chat' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['number']).to eq(chat.number)
      end
    end

    context 'with invalid number' do
      before { get :show, params: { application_token: application.token, number: 9999 } }

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Chat not found')
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Chat' do
        expect {
          post :create, params: { application_token: application.token }
        }.to change(Chat, :count).by(1)
      end

      it 'renders a JSON response with the new chat' do
        post :create, params: { application_token: application.token }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['number']).to eq(1)
      end
    end

    context 'with invalid parameters' do
      before { post :create, params: { application_token: 'invalid-token' } }

      it 'renders a JSON response with errors for the new chat' do
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested chat' do
      expect {
        delete :destroy, params: { application_token: application.token, number: chat.number }
      }.to change(Chat, :count).by(-1)
    end

    it 'renders a no content response' do
      delete :destroy, params: { application_token: application.token, number: chat.number }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET #search_messages' do
    let!(:message) { create(:message, chat: chat, content: 'Hello world') }

    before do
      allow(Message).to receive(:search).and_return([message])
      get :search_messages, params: { application_token: application.token, number: chat.number, message_query: 'Hello' }
    end

    it 'returns a success response' do
      expect(response).to be_successful
    end

    it 'returns the searched messages' do
      json_response = JSON.parse(response.body)
      expect(json_response['data']).not_to be_empty
      expect(json_response['data'].first['attributes']['content']).to eq('Hello world')
    end
  end
end
