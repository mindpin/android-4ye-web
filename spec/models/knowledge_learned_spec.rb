require "spec_helper.rb"

describe KnowledgeLearned do
  before{
    @net = KnowledgeNet.get_by_name("test1")
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
    @set_8 = @net.find_set_by_id("set-8")
    @set_2 = @net.find_set_by_id("set-2")
    @set_1 = @net.find_set_by_id("set-1")
    @set_3 = @net.find_set_by_id("set-3")

    @checkpoint_1 = @net.find_checkpoint_by_id("checkpoint-1")

    @node_31 = @net.find_node_by_id("node-31")
    @node_32 = @net.find_node_by_id("node-32")
    @node_33 = @net.find_node_by_id("node-33")
    @node_34 = @net.find_node_by_id("node-34")
    @node_35 = @net.find_node_by_id("node-35")

    @node_6 = @net.find_node_by_id("node-6")
    @node_7 = @net.find_node_by_id("node-7")
    @node_8 = @net.find_node_by_id("node-8")
    @node_9 = @net.find_node_by_id("node-9")

    @node_1 = @net.find_node_by_id("node-1")
    @node_2 = @net.find_node_by_id("node-2")
    @node_4 = @net.find_node_by_id("node-4")
    @node_5 = @net.find_node_by_id("node-5")
    @node_3 = @net.find_node_by_id("node-3")

    @node_10 = @net.find_node_by_id("node-10")
    @node_14 = @net.find_node_by_id("node-14")
    @node_11 = @net.find_node_by_id("node-11")
    @node_13 = @net.find_node_by_id("node-13")
    @node_12 = @net.find_node_by_id("node-12")

    @set_4 = @net.find_set_by_id("set-4")
    @node_15 = @net.find_node_by_id("node-15")
  }

  it{
    # 1 初始情况下的解锁和学习状态
    # 解锁状态
    @set_8.is_unlocked?(@user).should == true
    @set_2.is_unlocked?(@user).should == false
    @set_1.is_unlocked?(@user).should == false
    @set_3.is_unlocked?(@user).should == false

    @checkpoint_1.is_unlocked?(@user).should == true

    @node_31.is_unlocked?(@user).should == true
    @node_32.is_unlocked?(@user).should == false
    @node_33.is_unlocked?(@user).should == false
    @node_34.is_unlocked?(@user).should == false
    @node_35.is_unlocked?(@user).should == false

    # 学习状态
    @set_8.is_learned?(@user).should == false
    @set_2.is_learned?(@user).should == false
    @set_1.is_learned?(@user).should == false
    @set_3.is_learned?(@user).should == false

    @checkpoint_1.is_learned?(@user).should == false

    @node_31.is_learned?(@user).should == false
    @node_32.is_learned?(@user).should == false
    @node_33.is_learned?(@user).should == false
    @node_34.is_learned?(@user).should == false
    @node_35.is_learned?(@user).should == false
  }

  it{
    # 2 初始情况下学习第一个单元的第一个节点
    @node_31.do_learn(@user)

    # 解锁状态
    @set_8.is_unlocked?(@user).should == true
    @set_2.is_unlocked?(@user).should == false
    @set_1.is_unlocked?(@user).should == false
    @set_3.is_unlocked?(@user).should == false
    
    @checkpoint_1.is_unlocked?(@user).should == true

    @node_31.is_unlocked?(@user).should == true
    @node_32.is_unlocked?(@user).should == true
    @node_33.is_unlocked?(@user).should == false
    @node_34.is_unlocked?(@user).should == false
    @node_35.is_unlocked?(@user).should == true


    # 学习状态
    @set_8.is_learned?(@user).should == false
    @set_1.is_learned?(@user).should == false
    @set_2.is_learned?(@user).should == false
    @set_3.is_learned?(@user).should == false

    @checkpoint_1.is_learned?(@user).should == false

    @node_31.is_learned?(@user).should == true
    @node_32.is_learned?(@user).should == false
    @node_33.is_learned?(@user).should == false
    @node_34.is_learned?(@user).should == false
    @node_35.is_learned?(@user).should == false
  }

  it{
    # 3 初始情况下学习第一个单元下的所有必须节点
    @node_31.do_learn(@user)
    @node_32.do_learn(@user)
    @node_33.do_learn(@user)
    @node_34.do_learn(@user)

    # 解锁状态
    @set_8.is_unlocked?(@user).should == true
    @set_2.is_unlocked?(@user).should == true
    @set_1.is_unlocked?(@user).should == false
    @set_3.is_unlocked?(@user).should == false
    
    @checkpoint_1.is_unlocked?(@user).should == true

    @node_31.is_unlocked?(@user).should == true
    @node_32.is_unlocked?(@user).should == true
    @node_33.is_unlocked?(@user).should == true
    @node_34.is_unlocked?(@user).should == true
    @node_35.is_unlocked?(@user).should == true

    @node_6.is_unlocked?(@user).should == true

    # 学习状态
    @set_8.is_learned?(@user).should == true
    @set_2.is_learned?(@user).should == false
    @set_1.is_learned?(@user).should == false
    @set_3.is_learned?(@user).should == false

    @checkpoint_1.is_learned?(@user).should == false

    @node_31.is_learned?(@user).should == true
    @node_32.is_learned?(@user).should == true
    @node_33.is_learned?(@user).should == true
    @node_34.is_learned?(@user).should == true
    @node_35.is_learned?(@user).should == false

    @node_6.is_learned?(@user).should == false
  }

  it {
    # 4 初始情况下学习第一个检查点包括的所有单元下的节点
    @node_31.do_learn(@user)
    @node_32.do_learn(@user)
    @node_33.do_learn(@user)
    @node_34.do_learn(@user)

    @node_6.do_learn(@user)
    @node_7.do_learn(@user)
    @node_8.do_learn(@user)
    @node_9.do_learn(@user)

    @node_1.do_learn(@user)
    @node_2.do_learn(@user)
    @node_4.do_learn(@user)
    @node_5.do_learn(@user)

    @node_10.do_learn(@user)
    @node_14.do_learn(@user)
    @node_11.do_learn(@user)
    @node_13.do_learn(@user)

    # 解锁状态
    @set_8.is_unlocked?(@user).should == true
    @set_2.is_unlocked?(@user).should == true
    @set_1.is_unlocked?(@user).should == true
    @set_3.is_unlocked?(@user).should == true
    
    @checkpoint_1.is_unlocked?(@user).should == true

    @node_31.is_unlocked?(@user).should == true
    @node_32.is_unlocked?(@user).should == true
    @node_33.is_unlocked?(@user).should == true
    @node_34.is_unlocked?(@user).should == true
    @node_35.is_unlocked?(@user).should == true

    @node_6.is_unlocked?(@user).should == true
    @node_7.is_unlocked?(@user).should == true
    @node_8.is_unlocked?(@user).should == true
    @node_9.is_unlocked?(@user).should == true

    @node_1.is_unlocked?(@user).should == true
    @node_2.is_unlocked?(@user).should == true
    @node_4.is_unlocked?(@user).should == true
    @node_5.is_unlocked?(@user).should == true
    @node_3.is_unlocked?(@user).should == true

    @node_10.is_unlocked?(@user).should == true
    @node_14.is_unlocked?(@user).should == true
    @node_11.is_unlocked?(@user).should == true
    @node_13.is_unlocked?(@user).should == true
    @node_12.is_unlocked?(@user).should == true

    # 学习状态
    @set_8.is_learned?(@user).should == true
    @set_2.is_learned?(@user).should == true
    @set_1.is_learned?(@user).should == true
    @set_3.is_learned?(@user).should == true

    @checkpoint_1.is_learned?(@user).should == true

    @node_31.is_learned?(@user).should == true
    @node_32.is_learned?(@user).should == true
    @node_33.is_learned?(@user).should == true
    @node_34.is_learned?(@user).should == true
    @node_35.is_learned?(@user).should == false

    @node_6.is_learned?(@user).should == true
    @node_7.is_learned?(@user).should == true
    @node_8.is_learned?(@user).should == true
    @node_9.is_learned?(@user).should == true

    @node_1.is_learned?(@user).should == true
    @node_2.is_learned?(@user).should == true
    @node_4.is_learned?(@user).should == true
    @node_5.is_learned?(@user).should == true
    @node_3.is_learned?(@user).should == false

    @node_10.is_learned?(@user).should == true
    @node_14.is_learned?(@user).should == true
    @node_11.is_learned?(@user).should == true
    @node_13.is_learned?(@user).should == true
    @node_12.is_learned?(@user).should == false
  }

  it {
    # 5 初始情况下学习第一个检查点
    @checkpoint_1.do_learn(@user)

    # 解锁状态
    @set_8.is_unlocked?(@user).should == true
    @set_2.is_unlocked?(@user).should == true
    @set_1.is_unlocked?(@user).should == true
    @set_3.is_unlocked?(@user).should == true
    
    @checkpoint_1.is_unlocked?(@user).should == true

    @node_31.is_unlocked?(@user).should == true
    @node_32.is_unlocked?(@user).should == true
    @node_33.is_unlocked?(@user).should == true
    @node_34.is_unlocked?(@user).should == true
    @node_35.is_unlocked?(@user).should == true

    @node_6.is_unlocked?(@user).should == true
    @node_7.is_unlocked?(@user).should == true
    @node_8.is_unlocked?(@user).should == true
    @node_9.is_unlocked?(@user).should == true

    @node_1.is_unlocked?(@user).should == true
    @node_2.is_unlocked?(@user).should == true
    @node_4.is_unlocked?(@user).should == true
    @node_5.is_unlocked?(@user).should == true
    @node_3.is_unlocked?(@user).should == true

    @node_10.is_unlocked?(@user).should == true
    @node_14.is_unlocked?(@user).should == true
    @node_11.is_unlocked?(@user).should == true
    @node_13.is_unlocked?(@user).should == true
    @node_12.is_unlocked?(@user).should == true

    # 学习状态
    @set_8.is_learned?(@user).should == true
    @set_2.is_learned?(@user).should == true
    @set_1.is_learned?(@user).should == true
    @set_3.is_learned?(@user).should == true

    @checkpoint_1.is_learned?(@user).should == true

    @node_31.is_learned?(@user).should == true
    @node_32.is_learned?(@user).should == true
    @node_33.is_learned?(@user).should == true
    @node_34.is_learned?(@user).should == true
    @node_35.is_learned?(@user).should == false

    @node_6.is_learned?(@user).should == true
    @node_7.is_learned?(@user).should == true
    @node_8.is_learned?(@user).should == true
    @node_9.is_learned?(@user).should == true

    @node_1.is_learned?(@user).should == true
    @node_2.is_learned?(@user).should == true
    @node_4.is_learned?(@user).should == true
    @node_5.is_learned?(@user).should == true
    @node_3.is_learned?(@user).should == false

    @node_10.is_learned?(@user).should == true
    @node_14.is_learned?(@user).should == true
    @node_11.is_learned?(@user).should == true
    @node_13.is_learned?(@user).should == true
    @node_12.is_learned?(@user).should == false
  }
end
