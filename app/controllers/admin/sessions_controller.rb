module Admin
  class SessionsController < ApplicationController
    def new
      if admin_authenticated?
        redirect_to admin_dashboard_path
      end

      @admin = AdminUser.new
    end

    def create
      authenticate_admin

      if admin_authenticated?
        redirect_to admin_dashboard_path, notice: "Welcome, #{current_admin.full_name}!"
      else
        @admin             = AdminUser.new(sign_in_params)
        flash.now[:alert] = "Invalid email or password"
        render :new
      end
    end

    def destroy
      warden.logout(:admin)
      redirect_to root_url, notice: "Logged out"
    end

    private

    def sign_in_params
      params.require(:admin_user).permit(:email, :password)
    end
  end
end
