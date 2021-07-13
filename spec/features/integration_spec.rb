require 'rails_helper'

RSpec.describe 'Freature test' do
  # Populate the database
  before :each do
    user = User.create(name: 'User1',
                       email: 'user1@example.com',
                       password: '123456',
                       password_confirmation: '123456')
  end

  describe 'Sign up process', type: :feature do
    it ' Signs up a user' do
      visit 'users/sign_up'
      within('#new_user') do
        fill_in 'Name', with: 'mike'
        fill_in 'Email', with: 'mike@example.com'
        fill_in 'Password', with: '123456'
        fill_in 'Password confirmation', with: '123456'
      end
      click_button 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

 
    it ' Signs up a user' do
      visit 'users/sign_up'

      click_button 'Sign up'
      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    end
  end




  describe 'log in process', type: :feature do
    it 'logs in' do
      visit 'users/sign_in'
      within('#new_user') do
        fill_in 'Email', with: 'user1@example.com'
        fill_in 'Password', with: '123456'
      end
      click_button 'Log in'
      expect(page).to have_content 'Signed in successfully.'
    end


    it 'logs in' do
      visit 'users/sign_in'
      within('#new_user') do
        fill_in 'Email', with: ''
        fill_in 'Password', with: '123456'
      end
      click_button 'Log in'
      expect(page).to have_content 'Invalid Email or password.'
    end
 end
end 
