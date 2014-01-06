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

  describe "每次做完练习增加的经验值" do

    before{
      @course = "test1"
      @net = net(@course)
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
        Timecop.travel(Time.now - 1.day) do
          exp_num = node(9).do_learn(@user)
        end

        Timecop.travel(Time.now - 2.day) do
          node(16).do_learn(@user)
          node(16).do_learn(@user)
          node(16).do_learn(@user)
        end
      }

      it "1天前的经验值" do
        @day = Time.now.to_date - 1.day
        KnowledgeLearned.get_exp_by_day(@user, @day).should == 10
      end

      it "2天前的经验值" do
        @day = Time.now.to_date - 2.day
        KnowledgeLearned.get_exp_by_day(@user, @day).should == 20
      end
    end

  end



end