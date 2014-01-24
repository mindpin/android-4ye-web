class Admin::ApplicationController < ActionController::Base
  layout "admin"
  before_filter :is_admin
  def is_admin
    session[:is_admin_login] = true
    if current_user.blank?
      return redirect_to "/account/sign_in"
    end
    if !current_user.is_admin?
      render :template => "admin/401"
    end
  end
end
