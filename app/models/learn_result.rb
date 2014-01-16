class LearnResult
  attr_reader :exp_num, :learned_item

  def initialize(exp_num, learned_item = [])
    @exp_num = exp_num
    @learned_item = learned_item
  end

  def learned_ids
    @learned_item.map do |item|
      item.id
    end
  end
end