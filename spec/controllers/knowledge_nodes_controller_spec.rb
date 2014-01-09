require "spec_helper"

describe KnowledgeNodesController do
  def node(id)
    @net.find_node_adapter_by_id("node-#{id}")
  end

  def checkpoint(id)
    @net.find_checkpoint_adapter_by_id("checkpoint-#{id}")
  end


  context '#test_success' do
    before {
      @user = FactoryGirl.create :user
      sign_in @user

      @net_id = "test1"
      @node_id = "node-31"

      @net = KnowledgeNetAdapter.find(@net_id)

      Timecop.travel(Time.now - 4.day) do
        node(31).do_learn(@user)
      end

      Timecop.travel(Time.now - 3.day) do
        node(31).do_learn(@user)
        node(31).do_learn(@user)
        node(31).do_learn(@user)
      end

      Timecop.travel(Time.now - 2.day) do
        node(31).do_learn(@user)
        node(31).do_learn(@user)
      end


      Timecop.travel(Time.now - 1.day) do
        node(31).do_learn(@user)
        node(31).do_learn(@user)
        node(31).do_learn(@user)
        node(31).do_learn(@user)
      end

      Timecop.travel(Time.now) do
        node(31).do_learn(@user)
      end

      get :test_success, {:knowledge_net_id => @net_id, :id => @node_id} 
      @response = JSON::parse(response.body)
    }

    it "add_exp_num" do
      @response['add_exp_num'].should == 5
    end

    it "history_info" do
      @response['history_info'].should == [10, 15, 10, 20, 5]
    end

  end

end