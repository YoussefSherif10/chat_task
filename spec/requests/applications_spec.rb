require 'rails_helper'

RSpec.describe V1::ApplicationsController, type: :controller do
  let!(:application) { create(:application, token: 'AppToken-200') }
  let(:valid_attributes) { { name: 'Test Application' } }
  let(:invalid_attributes) { { name: nil } }

  describe 'GET #index' do
    before { get :index }

    it 'returns a success response' do
      expect(response).to be_successful
    end

    it 'returns paginated applications' do
      json_response = JSON.parse(response.body)
      expect(json_response['data']).not_to be_empty
    end
  end

  describe 'GET #show' do
    context 'with valid token' do
      before { get :show, params: { token: application.token } }

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns the application' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['name']).to eq(application.name)
      end
    end

    context 'with invalid token' do
      before { get :show, params: { token: 'invalid-token' } }

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Application not found')
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Application' do
        expect {
          post :create, params: { application: valid_attributes }
        }.to change(Application, :count).by(1)
      end

      it 'renders a JSON response with the new application' do
        post :create, params: { application: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['name']).to eq('Test Application')
      end
    end

    context 'with invalid parameters' do
      before { post :create, params: { application: invalid_attributes } }

      it 'renders a JSON response with errors for the new application' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { name: 'Updated Application' } }

      before { patch :update, params: { token: application.token, application: new_attributes } }

      it 'updates the requested application' do
        application.reload
        expect(application.name).to eq('Updated Application')
      end

      it 'renders a JSON response with the application' do
        expect(response).to be_successful
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['name']).to eq('Updated Application')
      end
    end

    context 'with invalid parameters' do
      before { patch :update, params: { token: application.token, application: invalid_attributes } }

      it 'renders a JSON response with errors for the application' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested application' do
      expect {
        delete :destroy, params: { token: application.token }
      }.to change(Application, :count).by(-1)
    end

    it 'renders a no content response' do
      delete :destroy, params: { token: application.token }
      expect(response).to have_http_status(:no_content)
    end
  end
end
