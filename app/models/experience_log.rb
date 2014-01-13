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

  # 传入的级别是当前级别，求得的是当前级别到下一级别所需的经验
  # 例如：传入的是 1 ，则求出的是 1 ~ 2 升级所需经验
  # 传入的是 3 ，则求出的是 3 ~ 4 升级所需经验
  def self.get_level_up_exp(level)
    base = 30
    p1 = 20 * (level - 1)
    p2 = 10 * (level - 2) * (level - 1) / 2

    return base + p1 + p2
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