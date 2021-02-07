require 'rails_helper'

feature 'User can view a question with answers', %q{
  In order to read answers to a question
  As a user of the system
  I'd like to be able to view the question with answers
} do
  scenario 'User can view a question with answers' do
    question = create(:question)
    question.answers = create_list(:answer, 3, question: question)

    visit questions_path
    click_on 'Show question'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end

end
