require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles/me' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'Api Authorizable' do
      let(:method) { :get }
      let(:params_success) { { params: { access_token: access_token.token }, headers: headers } }
    end

    context 'authorized' do
      let(:me_response) { json['user'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[email id admin created_at updated_at].each do |attr|
          expect(me_response[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(me_response).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:profiles) { create_list(:user, 3) }
    let(:me) { profiles.last }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'Api Authorizable' do
      let(:method) { :get }
      let(:params_success) { { params: { access_token: access_token.token }, headers: headers } }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns list of profiles without authenticated user' do
        expect(json.size).to eq 2
      end

      it 'returns all public fields' do
        json.each do |profile_response|
          %w[email id admin created_at updated_at].each do |attr|
            expect(profile_response).to have_key(attr)
          end
        end
      end

      it 'does not return authenticated user' do
        json.each do |profile_response|
          expect(profile_response['id']).to_not eq me.id
        end
      end

      it 'does not return private fields' do
        json.each do |profile_response|
          %w[password encrypted_password].each do |attr|
            expect(profile_response).to_not have_key(attr)
          end
        end
      end
    end
  end
end