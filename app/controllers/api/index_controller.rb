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

  def user_info
    us = UserSecret.where(:secret => params[:secret]).first
    return render :json => {:error => "user not found"} if us.blank?
    user = User.find(us.user_id)
    render :json => __user_info(user)
  end

  def _user_info
    __user_info(current_user)
  end

  def __user_info(user)
    return {
      :id     => user.id,
      :name   => user.name,
      :login  => user.login,
      :email  => user.email,
      :secret => user.secret,
      :avatar => "#{request.protocol}#{request.host_with_port}#{user.normal_avatar_url}"
    }
  end
end
