class LearnResult
  attr_reader :exp_num, :learned_items

  def initialize(exp_num, learned_items = [])
    @exp_num = exp_num
    @learned_items = learned_items
  end

  def learned_items_hash
    @learned_items.map do |item|
      {
        :id => item.id,
        :type => item.class.name.split("::").last
      }
    end
  end
end