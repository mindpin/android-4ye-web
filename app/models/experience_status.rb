class ExperienceStatus
  LEVEL_UP_EXP_NUM = [10,15,23]
  attr_accessor :level, :level_up_exp_num, :exp_num

  def initialize(user)
    elog = user.experience_logs.last
    if elog.blank?
      self.level = 1
      self.level_up_exp_num = LEVEL_UP_EXP_NUM[0]
      self.exp_num = 0
      return
    else
      LEVEL_UP_EXP_NUM.each_with_index.reduce(0) do |level_num, (num, index)|
        level_num += num
        if level_num > elog.after_exp
          self.level =  index + 1
          self.level_up_exp_num = num
          self.exp_num = elog.after_exp - (level_num - self.level_up_exp_num)
          break
        end
        level_num
      end
    end
  end
end