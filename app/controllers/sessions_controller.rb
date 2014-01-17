class SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    self.resource = warden.authenticate!({:scope=>:user, :recall=>"sessions#sign_failure"})
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    
    render :json => _user_info
  end

  def sign_failure
    render :json => {:sign_in => 'failure'}, :status => 401
  end

  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?
    render :json => {:sign_out => 'success'}
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