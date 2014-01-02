class UsersController < ApplicationController
  def exp_info
    current_user = User.find params[:id]
    status = current_user.experience_status(params[:course])
    render :json => {
                      :level            => status.level,
                      :level_up_exp_num => status.level_up_exp_num,
                      :exp_num          => status.exp_num
                    }
  end
end