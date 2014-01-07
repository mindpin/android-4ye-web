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



    describe "每天获取的经验值" do
      before {
        @course = "test1"

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
        KnowledgeLearned.get_exp_by_day(@user, @course, @selected_date).should == 10
      end

      it "2天前的经验值" do
        @selected_date = Time.now.to_date - 2.day
        KnowledgeLearned.get_exp_by_day(@user, @course, @selected_date).should == 15
      end

    end



  end


end

