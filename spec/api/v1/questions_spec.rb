require 'rails_helper'

describe 'Questions API', type: :request do

  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:user2) { create(:user) }
  let(:user2_access_token) { create(:access_token, resource_owner_id: user2.id) }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'Api Authorizable' do
      let(:method) { :get }
      let(:params_success) { { params: { access_token: access_token.token}, headers: headers } }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, links_attributes: [{name: 'Google', url: 'https://google.com'}]) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'Api Authorizable' do
      let(:method) { :get }
      let(:params_success) { { params: { access_token: access_token.token}, headers: headers } }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }
      let!(:comments) { create_list(:comment, 4, commentable: question) }
      let!(:file) { question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comments_response) { question_response['comments'] }
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
          expect(question_response['files'].size).to eq 1
        end

        it "returns file's url" do
          expect(question_response['files'].first).to have_key('file_url')
        end
      end

      describe 'links' do
        it 'returns list of links' do
          expect(question_response['links'].size).to eq 1
        end

        it 'returns all public attributes' do
          %w[id url name created_at updated_at].each do |attr|
            expect(question_response['links'].first[attr]).to eq question.links.first.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'Api Authorizable' do
      let(:method) { :post }
      let(:params_success) { { params: { access_token: access_token.token, question: attributes_for(:question)}, headers: headers } }
    end

    context 'with valid attributes' do
      let(:question_response) { json['question'] }

      it 'saves a question' do
        expect do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers
        end.to change(Question, :count).by(1)
      end

      it 'returns all public fields' do
        post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
        end
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid), headers: headers }
        end.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'Api Authorizable' do
      let(:method) { :patch }
      let(:params_success) { { params: { access_token: access_token.token, question: attributes_for(:question)}, headers: headers } }
    end

    context 'with valid attributes' do
      it 'changes the question' do
        expect do
          patch api_path, params: { access_token: access_token.token, question: { title: 'new title', body: 'new body' } }, headers: headers
          question.reload
        end.to change(question, :body)
      end
    end

    context 'with invalid attributes' do
      it "doesn't change the question" do
        expect do
          patch api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers
          question.reload
        end.to_not change(question, :body)
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'Api Authorizable' do
      let(:method) { :delete }
      let(:params_success) { { params: { access_token: access_token.token }, headers: headers } }
    end

    context 'author of the question' do
      it 'deletes the question' do
        expect do
          delete api_path, params: { access_token: access_token.token }, headers: headers
        end.to change(Question, :count).by(-1)
      end
    end

    context 'non-author of the question' do
      it 'does not delete the question' do
        expect do
          delete api_path, params: { access_token: user2_access_token.token }, headers: headers
        end.to_not change(Question, :count)
      end
    end
  end
end