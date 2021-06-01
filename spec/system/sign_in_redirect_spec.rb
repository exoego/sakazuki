require "rails_helper"

RSpec.describe "Sign-in redirect", type: :system do
  let!(:sakes) { FactoryBot.create_list(:sake, 3) }
  let(:id) { sakes[0].id }
  let!(:user) { FactoryBot.create(:user) }

  def sign_in_process
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "commit"
  end

  before do
    driven_by(:rack_test)
    sign_out(user)
  end

  context "when non-signed-in user tries to edit sake" do
    before do
      visit sake_path(id)
      click_link "edit-#{id}"
    end

    it "redirects user to new_user_session_path" do
      expect(page).to have_current_path new_user_session_path
    end

    it "redirect to edit_sake_path after user sign-in" do
      sign_in_process
      expect(page).to have_current_path edit_sake_path(id)
    end
  end

  context "when non-signed-in user tries to new sake" do
    before do
      visit sakes_path
      click_link "new-sake"
    end

    it "redirects user to new_user_session_path" do
      expect(page).to have_current_path new_user_session_path
    end

    it "redirects user to new_sake_path after user sign-in" do
      sign_in_process
      expect(page).to have_current_path new_sake_path
    end
  end

  context "when user presses sign-in button on sake show page" do
    before do
      visit sake_path(id)
      click_link "sign-in"
    end

    it "moves to new_user_session_path " do
      expect(page).to have_current_path new_user_session_path
    end

    it "redirects user to sake show page after user sign-in" do
      sign_in_process
      expect(page).to have_current_path sake_path(id)
    end
  end

  context "when user presses sign-in button on sign-in page" do
    before do
      visit new_user_session_path
      click_link "sign-in"
    end

    it "redirects user to root_path after user sign-in" do
      sign_in_process
      expect(page).to have_current_path root_path
    end
  end
end
