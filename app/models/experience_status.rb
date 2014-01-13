class ExperienceStatus
  attr_accessor :level, :level_up_exp_num, :exp_num, :total_exp_num

  def initialize(elog)
    if elog.blank?
      self.level = 1
      self.level_up_exp_num = ExperienceLog.get_level_up_exp(1)
      self.exp_num = 0
      self.total_exp_num = 0
      return
    else
      self.total_exp_num = elog.after_exp
      self.level = 1
      self.level_up_exp_num = ExperienceLog.get_level_up_exp(1)
      self.exp_num = elog.after_exp
      while(self.exp_num >= self.level_up_exp_num)
        self.exp_num = self.exp_num - self.level_up_exp_num
        self.level = self.level + 1
        self.level_up_exp_num = ExperienceLog.get_level_up_exp(self.level)
      end
    end
  end
end