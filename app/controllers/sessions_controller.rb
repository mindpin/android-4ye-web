class SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    self.resource = warden.authenticate!({:scope=>:user, :recall=>"sessions#sign_failure"})
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if session[:is_admin_login]
      return redirect_to "/admin"
    end
    render :json => _user_info
  end

  def sign_failure
    if session[:is_admin_login]
      return redirect_to "/admin"
    end
    render :json => {:sign_in => 'failure'}, :status => 401
  end

  def destroy
    is_admin_login = session[:is_admin_login]
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?
    if is_admin_login
      session[:is_admin_login] = true
      return redirect_to "/admin"
    end
    render :json => {:sign_out => 'success'}
  end

  def _user_info
    return {
      :id     => current_user.id,
      :name   => current_user.name,
      :login  => current_user.login,
      :email  => current_user.email,
      :secret => current_user.secret,
      :avatar => "#{request.protocol}#{request.host_with_port}#{current_user.normal_avatar_url}"
    }
  end
end