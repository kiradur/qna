require 'rails_helper'

feature 'User can add Badge to question', %q(
  In order to mark the best answer
  As an question's author
  I'd like to be able to add Badge
) do
  describe 'Authentithicated user asks question', js: true do
    given(:user) { create(:user) }

    background do
      login(user)
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'question text'
    end

    scenario 'add Badge' do
      within '.badge' do
        fill_in 'Name', with: 'Badge name test'
        attach_file 'Image', "#{Rails.root}/spec/fixtures/images/reward.png"
      end

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
    end

    scenario 'add invalid Badge image' do
      within '.badge' do
        fill_in 'Name', with: 'Badge name test'
      end

      click_on 'Ask'

      expect(page).to have_content 'You must add an image file.'
    end

    scenario 'add invalid Badge name' do
      within '.badge' do
        attach_file 'Image', "#{Rails.root}/spec/fixtures/images/reward.png"
      end

      click_on 'Ask'

      expect(page).to have_content "Badge name can't be blank"
    end
  end
end
