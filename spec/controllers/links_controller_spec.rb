require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user, links_attributes: [{name: 'Google', url: 'https://google.com'}]) }

  describe 'DELETE #destroy' do

    context 'author of the link' do
      before { login(user) }

      it 'deletes the file' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question.links.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'non-author of the file' do
      before { login(user2) }

      it "doesn't delete the file" do
        expect do
          delete :destroy, params: { id: question.links.first }, format: :js
        end.to_not change(question.links, :count)
      end

      it 'returns :forbidden status' do
        delete :destroy, params: { id: question.links.first }, format: :js
        expect(response).to have_http_status :forbidden
      end
    end
  end
end