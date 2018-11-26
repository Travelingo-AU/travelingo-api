require 'spec_helper'

RSpec.feature "[AUTH/ADMIN] Admin sign-in" do
  describe "success" do

    let!(:admin) { create(:admin, email: "email@example.com", full_name: "John") }

    scenario "with valid credentials" do
      visit "/"

      within ".sign-in-form" do
        fill_in "Email", with: "email@example.com"
        fill_in "Password", with: "password"
        click_on "Sign-in"
      end

      aggregate_failures do
        expect(page.current_path).to eq "/admin/dashboard"
        expect(admin_page_alert).to have_text(/Welcome, John/i)
      end
    end
  end

  describe "error" do

    scenario "if user does not exists, fail sign-in" do
      visit "/"

      within ".sign-in-form" do
        fill_in "Email", with: "wrong@example.com"
        fill_in "Password", with: "nope"
        click_on "Sign-in"
      end

      aggregate_failures do
        expect(page.current_path).to eq("/admin/sign_in"), "should stay on sign-in page"
        expect(page_alert).to have_text(/Invalid email or password/i)
      end
    end

    scenario "if user does not exists, fail private zone access" do
      visit "/admin"

      aggregate_failures do
        expect(page.current_path).to eq("/admin/sign_in"), "should redirect if admin is not signed-in"
        expect(page_alert).to have_text(/You need to be authenticated/i)
      end
    end
  end
end
