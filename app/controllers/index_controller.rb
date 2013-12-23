# -*- coding: utf-8 -*-
class IndexController < ApplicationController
  def index
    if !user_signed_in?
      return redirect_to '/account/sign_in'
    end
  end
end
