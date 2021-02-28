require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let!(:awards) { create_list(:award, 3, question: question, user: user)}

    before do
      login user
      get :index
    end

    it 'populates an array of all user`s awards' do
      expect(assigns(:awards)).to match_array(awards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end