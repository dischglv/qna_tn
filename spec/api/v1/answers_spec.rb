require 'rails_helper'

describe 'Answers API', type: :request do

  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:user2) { create(:user) }
  let(:user2_access_token) { create(:access_token, resource_owner_id: user2.id) }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'Api Authorizable' do
      let(:method) { :get }
      let(:params_success) { { params: { access_token: access_token.token}, headers: headers } }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:answers_response) { json }
      let(:answer_response) { json.first }

      before { get api_path, params: { access_token: access_token.token, question_id: question.id }, headers: headers }

      it 'returns list of answers' do
        expect(answers_response.size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, links_attributes: [{name: 'Google', url: 'https://google.com'}]) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'Api Authorizable' do
      let(:method) { :get }
      let(:params_success) { { params: { access_token: access_token.token}, headers: headers } }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }
      let!(:comments) { create_list(:comment, 4, commentable: answer) }
      let!(:file) { answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }

      before { get api_path, params: { access_token: access_token.token, question_id: question.id }, headers: headers }

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comments_response) { answer_response['comments'] }
        let(:comment_response) { comments_response.first }

        it 'returns list of comments' do
          expect(comments_response.size).to eq 4
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comments.first.send(attr).as_json
          end
        end
      end

      describe 'files' do
        it 'returns list of files' do
          expect(answer_response['files'].size).to eq 1
        end

        it "returns file's url" do
          expect(answer_response['files'].first).to have_key('file_url')
        end
      end

      describe 'links' do
        it 'returns list of links' do
          expect(answer_response['links'].size).to eq 1
        end

        it 'returns all public attributes' do
          %w[id url name created_at updated_at].each do |attr|
            expect(answer_response['links'].first[attr]).to eq answer.links.first.send(attr).as_json
          end
        end
      end
    end
  end
end