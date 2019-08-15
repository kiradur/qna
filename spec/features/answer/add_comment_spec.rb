require 'rails_helper'

  feature 'User can add comments to answer', %q(
   In order discuss the answer
   As an user
   I'd like to be able to add comments
 ), js: true do
   given(:question) { create(:question) }
   given!(:answer) { create(:answer, question: question) }

    describe 'Authentithicated user' do
     given(:user) { create(:user) }
     given(:comment_text) { 'Comment text' }

      background do
       login(user)
       visit question_path(question)
     end

      scenario 'add valid comment' do
       within "#answer-#{answer.id}" do
         expect(page).to_not have_content comment_text

          click_on 'Add comment'

          expect(page).to_not have_link 'Add comment'

          within '.comment-form' do
           fill_in 'Body', with: comment_text
           click_on 'Comment'
         end

          expect(page).to have_content comment_text
         expect(page).to_not have_link 'Comment'
       end
     end

      scenario 'add invalid comment' do
       within "#answer-#{answer.id}" do
         click_on 'Add comment'
         within '.comment-form' do
           fill_in 'Body', with: ''
           click_on 'Comment'
         end

          expect(page).to have_content "Body can't be blank"
       end
     end
   end

    scenario 'Unauthentithicated user tries add comment' do
     visit question_path(question)

      within "#answer-#{answer.id}" do
       expect(page).to_not have_link 'Add comment'
     end
   end
 end