# -*- coding: utf-8 -*-
class Api::IndexController < ApplicationController
  def index
    if !user_signed_in?
      return redirect_to '/api/account/sign_in'
    end
  end

  def user_profile
    if current_user.blank?
      return render :json => {:sign_in => 'failure'}, :status => 401
    end
    render :json => _user_info
  end

  def _user_info
    return {
      :id     => current_user.id,
      :name   => current_user.name,
      :login  => current_user.login,
      :email  => current_user.email,
      :avatar => "#{request.protocol}#{request.host_with_port}#{current_user.normal_avatar_url}"
    }
  end
end
