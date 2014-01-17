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
      learn_result.learned_items_hash.should == [{:id=>"node-31", :type=>"KnowledgeNode"}]
      # 第二次学习
      learn_result = node(31).do_learn(@user)
      learn_result.exp_num.should == 5
      learn_result.learned_items_hash.should == []
    }

    it{
      # 第一次学习
      learn_result = checkpoint(1).do_learn(@user)
      learn_result.exp_num.should == 10
      learn_result.learned_items_hash.should == [{:id=>"node-1", :type=>"KnowledgeNode"}, {:id=>"node-2", :type=>"KnowledgeNode"}, {:id=>"node-3", :type=>"KnowledgeNode"}, {:id=>"node-4", :type=>"KnowledgeNode"}, {:id=>"node-5", :type=>"KnowledgeNode"}, {:id=>"set-1", :type=>"KnowledgeSet"}, {:id=>"node-6", :type=>"KnowledgeNode"}, {:id=>"node-7", :type=>"KnowledgeNode"}, {:id=>"node-8", :type=>"KnowledgeNode"}, {:id=>"node-9", :type=>"KnowledgeNode"}, {:id=>"set-2", :type=>"KnowledgeSet"}, {:id=>"node-31", :type=>"KnowledgeNode"}, {:id=>"node-32", :type=>"KnowledgeNode"}, {:id=>"node-33", :type=>"KnowledgeNode"}, {:id=>"node-34", :type=>"KnowledgeNode"}, {:id=>"set-8", :type=>"KnowledgeSet"}, {:id=>"node-35", :type=>"KnowledgeNode"}, {:id=>"node-10", :type=>"KnowledgeNode"}, {:id=>"node-11", :type=>"KnowledgeNode"}, {:id=>"node-12", :type=>"KnowledgeNode"}, {:id=>"node-13", :type=>"KnowledgeNode"}, {:id=>"node-14", :type=>"KnowledgeNode"}, {:id=>"set-3", :type=>"KnowledgeSet"}, {:id=>"checkpoint-1", :type=>"KnowledgeCheckpoint"}]
      # 第二次学习
      learn_result = checkpoint(1).do_learn(@user)
      learn_result.exp_num.should == 5
      learn_result.learned_items_hash.should == []
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

