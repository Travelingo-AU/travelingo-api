module SpecHelpers
  module FeatureSpecHelpers
    def sign_in_user(admin)
      visit "/"

      within ".sign-in-form" do
        fill_in "Email", with: admin.email
        fill_in "Password", with: admin.password
        click_on "Sign-in"
      end

      expect(page.current_path).to eq "/admin/dashboard"
    end

    def page_alert
      page.find(".alert")
    end

    def admin_page_alert
      page.find(".flash")
    end
  end
end

RSpec.configuration.include SpecHelpers::FeatureSpecHelpers, type: :feature
