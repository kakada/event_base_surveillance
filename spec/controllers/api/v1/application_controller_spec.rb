require 'rails_helper'

class ApplicationController < Api::V1::ApplicationController; end

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render json: {}, status: 200
    end

    def create
      render json: {}, status: 201
    end
  end

  describe '#restrict_access' do
    before :each do
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context 'when no api key' do
      it 'returns 401' do
        get :index
        expect(response.status).to eq(401)
      end
    end

    context 'when wrong api key' do
      it 'returns 401' do
        request.headers['Authorization'] = "Token #{SecureRandom.hex}"
        get :index
        expect(response.status).to eq(401)
      end
    end

    context 'when wrong ip address' do
      let! (:api_key) { create(:api_key) }

      it 'returns 401' do
        allow(request).to receive(:remote_ip).and_return('1.1.1.1')
        request.headers['Authorization'] = "Token #{api_key.access_token}"
        get :index

        expect(response.status).to eq(401)
      end
    end

    context 'when only permission read' do
      let! (:api_key) { create(:api_key, :permission_read) }

      before(:each) do
        controller.request.remote_addr = api_key.ip_address
        request.headers['Authorization'] = "Token #{api_key.access_token}"
      end

      it 'returns 200' do
        get :index
        expect(response.status).to eq(200)
      end

      it 'returns 401' do
        post :create
        expect(response.status).to eq(401)
      end
    end

    context 'when only permission write' do
      let! (:api_key) { create(:api_key, :permission_write) }

      before(:each) do
        controller.request.remote_addr = api_key.ip_address
        request.headers['Authorization'] = "Token #{api_key.access_token}"
      end

      it 'returns 401' do
        get :index
        expect(response.status).to eq(401)
      end

      it 'returns 201' do
        post :create
        expect(response.status).to eq(201)
      end
    end

    context 'when both permission read and write' do
      let! (:api_key) { create(:api_key) }

      before(:each) do
        controller.request.remote_addr = api_key.ip_address
        request.headers['Authorization'] = "Token #{api_key.access_token}"
      end

      it 'returns 200' do
        get :index
        expect(response.status).to eq(200)
      end

      it 'returns 201' do
        post :create
        expect(response.status).to eq(201)
      end
    end
  end
end
