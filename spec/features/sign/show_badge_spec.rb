require 'rails_helper'

feature 'User can see their badge', %q(
  In order to see badges
  As an authenticated user
  I'd like to be see my badges
) do
  given(:user) { create(:user) }
  given(:image) { fixture_file_upload("#{Rails.root}/spec/fixtures/images/badge.png", 'image/png') }
  given(:second_image) { fixture_file_upload("#{Rails.root}/spec/fixtures/images/second_badge.png", 'image/png') }
  given(:question) { create(:question) }
  given!(:badge) { create(:badge, question: question, name: 'first reward', image: image ) }
  given(:second_question) { create(:question) }
  given!(:second_badge { create(:badge, question: second_question, name: 'second reward', image: second_image) }
  given(:answer) { create(:answer, question: question, user: user) }
  given(:second_answer) { create(:answer, question: second_question, user: user) }

  context 'With best answers' do
    background do
      login(user)
      answer.best!
      second_answer.best!
      visit user_badges_path(user)
    end

    scenario 'user is viewing their badges' do
      expect(page).to have_content question.title
      expect(page).to have_content second_question.title
      expect(page).to have_content 'first reward'
      expect(page).to have_content 'second reward'
      expect(page).to have_css "img[src*='badge.png']"
      expect(page).to have_css "img[src*='second_badge.png']"
    end
  end

  context 'Without best answers' do
    background do
      login(user)
      visit user_badges_path(user)
    end

    scenario 'user has no badges' do
      expect(page).to_not have_content question.title
      expect(page).to_not have_content second_question.title
      expect(page).to_not have_content 'first reward'
      expect(page).to_not have_content 'second reward'
      expect(page).to_not have_css "img[src*='badge.png']"
      expect(page).to_not have_css "img[src*='second_badge.png']"
    end
  end
end
