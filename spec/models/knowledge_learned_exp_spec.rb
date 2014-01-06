require "spec_helper.rb"

describe KnowledgeLearned do
  def node(id)
    @net.find_node_adapter_by_id("node-#{id}")
  end

  def checkpoint(id)
    @net.find_checkpoint_adapter_by_id("checkpoint-#{id}")
  end


  before{
    @net = KnowledgeNetAdapter.test1_instance
    @user = FactoryGirl.create :user
  }

  it{
    # 第一次学习
    exp_num = node(31).do_learn(@user)
    exp_num.should == 10
    # 第二次学习
    exp_num = node(31).do_learn(@user)
    exp_num.should == 5
  }

  it{
    # 第一次学习
    exp_num = checkpoint(1).do_learn(@user)
    exp_num.should == 10
    # 第二次学习
    exp_num = checkpoint(1).do_learn(@user)
    exp_num.should == 5
  }
end