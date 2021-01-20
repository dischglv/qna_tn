require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #index' do
    let(:answers) { create_list(:answer, 5) }
    let(:question) { create(:question) }

    it 'populates an array of all answers' do
      get :index, params: { question_id: question }
      expect(assigns(:answers)).to match_array(answers)
    end
    it 'renders index view' do
      get :index, params: { question_id: question }
      expect(response).to render_template :index
    end
  end
end
