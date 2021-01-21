require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 5) }

    before { get :index, params: { question_id: question } }

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answer) { create(:answer) }

    it 'renders show view' do
      get :show, params: { id: answer, question_id: question }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'renders new view' do
      get :new, params: { question_id: question }
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    let(:answer) { create(:answer) }

    it 'renders edit view' do
      get :edit, params: { question_id: question, id: answer }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do

      it 'saves a new answer to the database' do
        expect { post :create, params: { question_id: question, answer: { body: 'MyText', question_id: question } } }.to change(Answer, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: { body: 'MyText', question_id: question } }
        expect(response).to redirect_to question_answer_path(question, assigns(:answer))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer'
      it 're-renders new view'
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'changes answer attributes'
      it 'redirects to updated answer'
    end

    context 'with invalid attributes' do
      it 'does not change the answer'
      it 're-renders edit view'
    end
  end

  describe 'DELETE #destroy' do

  end
end
