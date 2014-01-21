# -*- coding: utf-8 -*-
class IndexController < ApplicationController
  def index
    render :text => ""
  end

  def debug
    if current_user.blank?
      session[:debug] = true
      return redirect_to "/account/sign_in"
    end

    if !current_user.is_admin?
      return render :text => "没有管理员权限"
    end
  end

  def debug_net
    @net = KnowledgeSpaceNetLib::KnowledgeNet.find(params[:net_id])
  end

  def debug_set
    @net = KnowledgeSpaceNetLib::KnowledgeNet.find(params[:net_id])
    @set = @net.find_set_by_id(params[:set_id])
  end
end
