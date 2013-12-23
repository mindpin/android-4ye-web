class SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    # if !request.xhr?
    #   return super
    # end
    p 11
    p 22
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    p 33
    sign_in(resource_name, resource)
    p 44
    ### respond_with resource, :location => after_sign_in_path_for(resource)
    render :json => {:sign_in => 'ok', :location => after_sign_in_path_for(resource)} # 必须响应 json 否则会被 jquery 判为 error
  raise e
    p e
  end
end