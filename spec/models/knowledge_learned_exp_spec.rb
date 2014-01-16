require "spec_helper.rb"

describe KnowledgeLearned do
  def node(id)
    @net.find_node_adapter_by_id("node-#{id}")
  end

  def checkpoint(id)
    @net.find_checkpoint_adapter_by_id("checkpoint-#{id}")
  end


  describe "每次做完练习增加的经验值" do

    before{
      @net = KnowledgeNetAdapter.find("test1")
      @user = FactoryGirl.create :user
    }

    it{
      # 第一次学习
      learn_result = node(31).do_learn(@user)
      learn_result.exp_num.should == 10
      learn_result.learned_ids.should == ["node-31"]
      # 第二次学习
      learn_result = node(31).do_learn(@user)
      learn_result.exp_num.should == 5
      learn_result.learned_ids.should == []
    }

    it{
      # 第一次学习
      learn_result = checkpoint(1).do_learn(@user)
      learn_result.exp_num.should == 10
      learn_result.learned_ids.should == ["node-1", "node-2", "node-3", "node-4", "node-5", "set-1", "node-6", "node-7", "node-8", "node-9", "set-2", "node-31", "node-32", "node-33", "node-34", "set-8", "node-35", "node-10", "node-11", "node-12", "node-13", "node-14", "set-3", "checkpoint-1"]
      # 第二次学习
      learn_result = checkpoint(1).do_learn(@user)
      learn_result.exp_num.should == 5
      learn_result.learned_ids.should == []
    }



    describe "每天获取的经验值" do
      before {
        @net_id = "test1"

        Timecop.travel(Time.now - 1.day) do
          node(31).do_learn(@user)
        end

        Timecop.travel(Time.now - 2.day) do
          node(31).do_learn(@user)
          node(31).do_learn(@user)
          node(31).do_learn(@user)
        end
      }

      it "1天前的经验值" do
        @selected_date = Time.now.to_date - 1.day
        @user.get_by_day(@net_id, @selected_date).should == 10
      end

      it "2天前的经验值" do
        @selected_date = Time.now.to_date - 2.day
        @user.get_by_day(@net_id, @selected_date).should == 15
      end

    end



  end


end

