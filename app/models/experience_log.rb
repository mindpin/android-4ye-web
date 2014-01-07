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
  field :net_id,      :type => String

  def user
    User.find(user_id)
  end


  module UserMethods
    def experience_logs
      ExperienceLog.where(:user_id => self.id)
    end

    def add_exp(net_id,delta_num,model,data_json)
      return nil if model.blank?
      after_exp_elog = ExperienceLog.last
      before_exp = after_exp_elog.blank? ? 0:after_exp_elog.after_exp

      self.experience_logs.create(:before_exp => before_exp,
                                  :after_exp  => before_exp + delta_num,
                                  :model_type => model.class.name,
                                  :model_id   => model.id,
                                  :data_json  => data_json,
                                  :net_id     => net_id
                                 )
    end

    def experience_status(net_id)
      elog = self.experience_logs.where(:net_id => net_id).last
      ExperienceStatus.new elog
    end


    def get_by_day(net_id, selected_date)

      exp = ExperienceLog.where(
        :user_id => self.id,
        :net_id     => net_id,
        :created_at => selected_date.beginning_of_day..selected_date.end_of_day
      )

      exp.map { |e| e.after_exp - e.before_exp }.inject(:+) || 0
    end

  end
end