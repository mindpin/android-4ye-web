require "spec_helper.rb"

describe KnowledgeLearned do
  def node(id)
    @net.find_node_adapter_by_id("node-#{id}")
  end

  def checkpoint(id)
    @net.find_checkpoint_adapter_by_id("checkpoint-#{id}")
  end

  def set(id)
    @net.find_set_adapter_by_id("set-#{id}")
  end

  before{
    @net = KnowledgeNetAdapter.find("test1")
    @user = FactoryGirl.create :user
    #set-8 => set-2
    #set-2 => set-1 => checkpoint-1 => set-4
    #set-2 => set-3 => checkpoint-1 => set-4

    # set-8 下的节点
    #node-31 => node-35(选)
    #node-31 => node-32 => node-33 => node-34

    # set-2 下的节点
    #node-6 => node-7 => node-8 => node-9

    # set-1 下的节点
    #node-1 => node-2 => node-4 => node-5
    #node-1 => node-3(选)

    # set-3 下的节点
    #node-10 => node-11
    #node-10 => node-14
    #node-11 => node-12(选)
    #node-11 => node-13

    # set-4 下的根节点
    #node-15
  }

  it{
    # 1 初始情况下的解锁和学习状态
    # 解锁状态
    set(8).is_unlocked?(@user).should == true
    set(2).is_unlocked?(@user).should == false
    set(1).is_unlocked?(@user).should == false
    set(3).is_unlocked?(@user).should == false

    checkpoint(1).is_unlocked?(@user).should == true

    node(31).is_unlocked?(@user).should == true
    node(32).is_unlocked?(@user).should == false
    node(33).is_unlocked?(@user).should == false
    node(34).is_unlocked?(@user).should == false
    node(35).is_unlocked?(@user).should == false

    # 学习状态
    set(8).is_learned?(@user).should == false
    set(2).is_learned?(@user).should == false
    set(1).is_learned?(@user).should == false
    set(3).is_learned?(@user).should == false

    checkpoint(1).is_learned?(@user).should == false

    node(31).is_learned?(@user).should == false
    node(32).is_learned?(@user).should == false
    node(33).is_learned?(@user).should == false
    node(34).is_learned?(@user).should == false
    node(35).is_learned?(@user).should == false
  }

  it{
    # 2 初始情况下学习第一个单元的第一个节点
    node(31).do_learn(@user)

    # 解锁状态
    set(8).is_unlocked?(@user).should == true
    set(2).is_unlocked?(@user).should == false
    set(1).is_unlocked?(@user).should == false
    set(3).is_unlocked?(@user).should == false
    
    checkpoint(1).is_unlocked?(@user).should == true

    node(31).is_unlocked?(@user).should == true
    node(32).is_unlocked?(@user).should == true
    node(33).is_unlocked?(@user).should == false
    node(34).is_unlocked?(@user).should == false
    node(35).is_unlocked?(@user).should == true


    # 学习状态
    set(8).is_learned?(@user).should == false
    set(1).is_learned?(@user).should == false
    set(2).is_learned?(@user).should == false
    set(3).is_learned?(@user).should == false

    checkpoint(1).is_learned?(@user).should == false

    node(31).is_learned?(@user).should == true
    node(32).is_learned?(@user).should == false
    node(33).is_learned?(@user).should == false
    node(34).is_learned?(@user).should == false
    node(35).is_learned?(@user).should == false
  }

  it{
    # 3 初始情况下学习第一个单元下的所有必须节点
    node(31).do_learn(@user)
    node(32).do_learn(@user)
    node(33).do_learn(@user)
    node(34).do_learn(@user)

    # 解锁状态
    set(8).is_unlocked?(@user).should == true
    set(2).is_unlocked?(@user).should == true
    set(1).is_unlocked?(@user).should == false
    set(3).is_unlocked?(@user).should == false
    
    checkpoint(1).is_unlocked?(@user).should == true

    node(31).is_unlocked?(@user).should == true
    node(32).is_unlocked?(@user).should == true
    node(33).is_unlocked?(@user).should == true
    node(34).is_unlocked?(@user).should == true
    node(35).is_unlocked?(@user).should == true

    node(6).is_unlocked?(@user).should == true

    # 学习状态
    set(8).is_learned?(@user).should == true
    set(2).is_learned?(@user).should == false
    set(1).is_learned?(@user).should == false
    set(3).is_learned?(@user).should == false

    checkpoint(1).is_learned?(@user).should == false

    node(31).is_learned?(@user).should == true
    node(32).is_learned?(@user).should == true
    node(33).is_learned?(@user).should == true
    node(34).is_learned?(@user).should == true
    node(35).is_learned?(@user).should == false

    node(6).is_learned?(@user).should == false
  }

  it {
    # 4 初始情况下学习第一个检查点包括的所有单元下的节点
    node(31).do_learn(@user)
    node(32).do_learn(@user)
    node(33).do_learn(@user)
    node(34).do_learn(@user)

    node(6).do_learn(@user)
    node(7).do_learn(@user)
    node(8).do_learn(@user)
    node(9).do_learn(@user)

    node(1).do_learn(@user)
    node(2).do_learn(@user)
    node(4).do_learn(@user)
    node(5).do_learn(@user)

    node(10).do_learn(@user)
    node(14).do_learn(@user)
    node(11).do_learn(@user)
    node(13).do_learn(@user)

    # 解锁状态
    set(8).is_unlocked?(@user).should == true
    set(2).is_unlocked?(@user).should == true
    set(1).is_unlocked?(@user).should == true
    set(3).is_unlocked?(@user).should == true
    
    checkpoint(1).is_unlocked?(@user).should == true

    node(31).is_unlocked?(@user).should == true
    node(32).is_unlocked?(@user).should == true
    node(33).is_unlocked?(@user).should == true
    node(34).is_unlocked?(@user).should == true
    node(35).is_unlocked?(@user).should == true

    node(6).is_unlocked?(@user).should == true
    node(7).is_unlocked?(@user).should == true
    node(8).is_unlocked?(@user).should == true
    node(9).is_unlocked?(@user).should == true

    node(1).is_unlocked?(@user).should == true
    node(2).is_unlocked?(@user).should == true
    node(4).is_unlocked?(@user).should == true
    node(5).is_unlocked?(@user).should == true
    node(3).is_unlocked?(@user).should == true

    node(10).is_unlocked?(@user).should == true
    node(14).is_unlocked?(@user).should == true
    node(11).is_unlocked?(@user).should == true
    node(13).is_unlocked?(@user).should == true
    node(12).is_unlocked?(@user).should == true

    # 学习状态
    set(8).is_learned?(@user).should == true
    set(2).is_learned?(@user).should == true
    set(1).is_learned?(@user).should == true
    set(3).is_learned?(@user).should == true

    checkpoint(1).is_learned?(@user).should == true

    node(31).is_learned?(@user).should == true
    node(32).is_learned?(@user).should == true
    node(33).is_learned?(@user).should == true
    node(34).is_learned?(@user).should == true
    node(35).is_learned?(@user).should == false

    node(6).is_learned?(@user).should == true
    node(7).is_learned?(@user).should == true
    node(8).is_learned?(@user).should == true
    node(9).is_learned?(@user).should == true

    node(1).is_learned?(@user).should == true
    node(2).is_learned?(@user).should == true
    node(4).is_learned?(@user).should == true
    node(5).is_learned?(@user).should == true
    node(3).is_learned?(@user).should == false

    node(10).is_learned?(@user).should == true
    node(14).is_learned?(@user).should == true
    node(11).is_learned?(@user).should == true
    node(13).is_learned?(@user).should == true
    node(12).is_learned?(@user).should == false
  }

  it {
    # 5 初始情况下学习第一个检查点
    checkpoint(1).do_learn(@user)

    # 解锁状态
    set(8).is_unlocked?(@user).should == true
    set(2).is_unlocked?(@user).should == true
    set(1).is_unlocked?(@user).should == true
    set(3).is_unlocked?(@user).should == true
    
    checkpoint(1).is_unlocked?(@user).should == true

    node(31).is_unlocked?(@user).should == true
    node(32).is_unlocked?(@user).should == true
    node(33).is_unlocked?(@user).should == true
    node(34).is_unlocked?(@user).should == true
    node(35).is_unlocked?(@user).should == true

    node(6).is_unlocked?(@user).should == true
    node(7).is_unlocked?(@user).should == true
    node(8).is_unlocked?(@user).should == true
    node(9).is_unlocked?(@user).should == true

    node(1).is_unlocked?(@user).should == true
    node(2).is_unlocked?(@user).should == true
    node(4).is_unlocked?(@user).should == true
    node(5).is_unlocked?(@user).should == true
    node(3).is_unlocked?(@user).should == true

    node(10).is_unlocked?(@user).should == true
    node(14).is_unlocked?(@user).should == true
    node(11).is_unlocked?(@user).should == true
    node(13).is_unlocked?(@user).should == true
    node(12).is_unlocked?(@user).should == true

    # 学习状态
    set(8).is_learned?(@user).should == true
    set(2).is_learned?(@user).should == true
    set(1).is_learned?(@user).should == true
    set(3).is_learned?(@user).should == true

    checkpoint(1).is_learned?(@user).should == true

    node(31).is_learned?(@user).should == true
    node(32).is_learned?(@user).should == true
    node(33).is_learned?(@user).should == true
    node(34).is_learned?(@user).should == true
    node(35).is_learned?(@user).should == true

    node(6).is_learned?(@user).should == true
    node(7).is_learned?(@user).should == true
    node(8).is_learned?(@user).should == true
    node(9).is_learned?(@user).should == true

    node(1).is_learned?(@user).should == true
    node(2).is_learned?(@user).should == true
    node(4).is_learned?(@user).should == true
    node(5).is_learned?(@user).should == true
    node(3).is_learned?(@user).should == true

    node(10).is_learned?(@user).should == true
    node(14).is_learned?(@user).should == true
    node(11).is_learned?(@user).should == true
    node(13).is_learned?(@user).should == true
    node(12).is_learned?(@user).should == true
  }

  it{
    set(8).set.nodes.count.should == 5
    set(8).learned_node_count(@user).should == 0

    node(31).do_learn(@user)
    node(32).do_learn(@user)
    node(33).do_learn(@user)

    set(8).learned_node_count(@user).should == 3

    @user.can_learn_knowledge_node_id(@net.net.id).should == ["node-34", "node-35"]
  }
end
