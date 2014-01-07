require "spec_helper"

describe KnowledgeNodesController do
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
    @user = FactoryGirl.create :user

    sign_in @user

    net_id = "javascript"
    node_id = "node-31"
    net_adapter = KnowledgeNetAdapter.find(net_id)
    node_adapter = net_adapter.find_node_adapter_by_id(node_id)

    @id = node_adapter.node.id


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

  }

  context '#test_success' do
    before {
      get :test_success, {net_id: @net_id, id: @id}
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