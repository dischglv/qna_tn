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
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: { question_id: question } } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: { question_id: question } }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      let(:answer) { create(:answer) }

      before { patch :update, params: { question_id: question, id: answer, answer: { body: 'new body', question_id: question } } }

      it 'changes answer attributes' do
        answer.reload

        expect(answer.body).to eq 'new body'
        expect(answer.question_id).to eq question.id
      end

      it 'redirects to updated answer' do
        expect(response).to redirect_to question_answer_path(question, assigns(:answer))
      end
    end

    context 'with invalid attributes' do
      let(:answer) { create(:answer) }

      before { patch :update, params: { question_id: question, id: answer, answer: { body: nil } } }

      it 'does not change the answer' do
        answer.reload

        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { question_id: question, id: answer} }.to change(Answer, :count).by(-1)
    end
    it 'redirects to index' do
      delete :destroy, params: { question_id: question, id: answer}
      expect(response).to redirect_to question_answers_path(answer.question)
    end
  end
end
