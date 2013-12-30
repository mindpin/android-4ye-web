class ExperienceLog
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id,     :type => Integer
  field :before_exp,  :type => Integer
  field :after_exp,   :type => Integer
  field :model_type,  :type => String
  field :model_id,    :type => String
  field :data_json,   :type => Moped::BSON::Binary

  def user
    User.find(user_id)
  end

  module UserMethods
    def experience_logs
      ExperienceLog.where(:user_id => self.id)
    end

    def add_exp(delta_num,model,data_json)
      after_exp_elog = ExperienceLog.last
      before_exp = after_exp_elog.blank? ? 0:after_exp_elog.after_exp

      self.experience_logs.create(:before_exp => before_exp,
                                  :after_exp  => before_exp + delta_num,
                                  :model_type => model[:type],
                                  :model_id   => model[:id],
                                  :data_json  => data_json
                                 )
    end

    def experience_status
      ExperienceStatus.new self
    end
  end
end