class ExperienceLog
  CHECK_POINT  = 'Checkpoint'
  NODE         = 'Node'

  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id,     :type => Integer
  field :before_exp,  :type => Integer
  field :after_exp,   :type => Integer
  field :model_type,  :type => String
  field :model_id,    :type => String
  field :data_json,   :type => Moped::BSON::Binary
  field :course,      :type => String

  def user
    User.find(user_id)
  end

  module UserMethods
    def experience_logs
      ExperienceLog.where(:user_id => self.id)
    end

    def add_exp(course,delta_num,model,data_json)
      return nil if model.blank?
      after_exp_elog = ExperienceLog.last
      before_exp = after_exp_elog.blank? ? 0:after_exp_elog.after_exp

      self.experience_logs.create(:before_exp => before_exp,
                                  :after_exp  => before_exp + delta_num,
                                  :model_type => model.class.name,
                                  :model_id   => model.id,
                                  :data_json  => data_json,
                                  :course     => course
                                 )
    end

    def experience_status(course)
      elog = self.experience_logs.where(:course => course).last
      ExperienceStatus.new elog
    end

  end
end