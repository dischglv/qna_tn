require 'rails_helper'

feature 'User can view a question with answers', %q{
  In order to read answers to a question
  As a user of the system
  I'd like to be able to view the question with answers
} do
  scenario 'Authenticated user can view a question with answers' do
    question = create(:question)
    question.answers.create(body: 'text1')
    question.answers.create(body: 'text2')
    question.answers.create(body: 'text3')

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end

end
