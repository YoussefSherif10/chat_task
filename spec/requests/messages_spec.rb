require 'rails_helper'

RSpec.describe V1::MessagesController, type: :controller do
  let!(:application) { create(:application, token: 'AppToken-4040') }
  let!(:chat) { create(:chat, application: application) }
  let!(:message) { create(:message, chat: chat) }

  before do
    allow(Utils::GenerateNumbers).to receive(:generate_number).and_return(1)
  end

  describe 'GET #index' do
    before { get :index, params: { application_token: application.token, chat_number: chat.number } }

    it 'returns a success response' do
      expect(response).to be_successful
    end

    it 'returns paginated messages' do
      json_response = JSON.parse(response.body)
      expect(json_response['data']).not_to be_empty
    end
  end

  describe 'GET #show' do
    context 'with valid message number' do
      before { get :show, params: { application_token: application.token, chat_number: chat.number, message_number: message.number } }

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns the message' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['number']).to eq(message.number)
      end
    end

    context 'with invalid message number' do
      before { get :show, params: { application_token: application.token, chat_number: chat.number, message_number: 9999 } }

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Message not found')
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Message' do
        expect {
          post :create, params: { application_token: application.token, chat_number: chat.number, message: { content: 'New message content' } }
        }.to change(Message, :count).by(1)
      end

      it 'renders a JSON response with the new message' do
        post :create, params: { application_token: application.token, chat_number: chat.number, message: { content: 'New message content' } }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end


  describe 'PATCH/PUT #update' do
    context 'with valid parameters' do
      before { patch :update, params: { application_token: application.token, chat_number: chat.number, message_number: message.number, message: { content: 'Updated message content' } } }

      it 'updates the requested message' do
        message.reload
        expect(message.content).to eq('Updated message content')
      end

      it 'renders a JSON response with the message' do
        expect(response).to be_successful
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['content']).to eq('Updated message content')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested message' do
      expect {
        delete :destroy, params: { application_token: application.token, chat_number: chat.number, message_number: message.number }
      }.to change(Message, :count).by(-1)
    end

    it 'renders a no content response' do
      delete :destroy, params: { application_token: application.token, chat_number: chat.number, message_number: message.number }
      expect(response).to have_http_status(:no_content)
    end
  end
end
