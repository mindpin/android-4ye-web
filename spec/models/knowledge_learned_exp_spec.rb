require "spec_helper.rb"

describe KnowledgeLearned do
  def node(id)
    @net.find_node_adapter_by_id("node-#{id}")
  end

  def checkpoint(id)
    @net.find_checkpoint_adapter_by_id("checkpoint-#{id}")
  end

  def net(id)
    KnowledgeNetAdapter.find(id)
  end

  before{
    @course = "test1"
    @net = net(@course)
    @user = FactoryGirl.create :user
  }

  it{
    # 第一次学习
    node(31).do_learn(@user)
    status = @user.experience_status(@course)
    status.total_exp_num.should == 10
    # 第二次学习
    node(31).do_learn(@user)
    status = @user.experience_status(@course)
    status.total_exp_num.should == 15
  }

  it{
    # 第一次学习
    checkpoint(1).do_learn(@user)
    status = @user.experience_status(@course)
    status.total_exp_num.should == 10
    # 第二次学习
    checkpoint(1).do_learn(@user)
    status = @user.experience_status(@course)
    status.total_exp_num.should == 15
  }
end