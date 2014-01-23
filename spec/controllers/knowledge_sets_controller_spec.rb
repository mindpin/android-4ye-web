require "spec_helper"

describe Api::KnowledgeSetsController do
  before{
    @user = FactoryGirl.create :user
    sign_in @user

    @net_id = "test1"
    @net = KnowledgeNetAdapter.find(@net_id)

    @set_id = 'set-8'

    @set_adapter = @net.find_set_adapter_by_id(@set_id)
    @node_31_adapter = @net.find_node_adapter_by_id("node-31")
    @node_32_adapter = @net.find_node_adapter_by_id("node-32")
    @node_1_adapter = @net.find_node_adapter_by_id("node-1")
  }

  context '#knowledge_sets show' do
    before{
      get :show, {:knowledge_net_id => @net_id, :id => @set_id} 
      @json = JSON::parse(response.body)
    }

    it{
      @json.should == {
        "id"=>"set-8", 
        "name"=>"基础: 值", 
        "icon"=>"set-8", 
        "deep"=>1, 
        "is_learned"=>false, 
        "node_count"=>5, 
        "learned_node_count"=>0, 
        "nodes"=>[
          {"id"=>"node-31", "name"=>"字符串", "desc"=>"怎样在程序里表示一个字符串", "required"=>true, "is_learned"=>false}, 
          {"id"=>"node-32", "name"=>"整数", "desc"=>"怎样在程序里表示一个整数", "required"=>true, "is_learned"=>false}, 
          {"id"=>"node-33", "name"=>"小数", "desc"=>"怎样在程序里表示一个小数（浮点数）", "required"=>true, "is_learned"=>false}, 
          {"id"=>"node-34", "name"=>"布尔值", "desc"=>"怎样在程序里表示一个布尔值", "required"=>true, "is_learned"=>false}, 
          {"id"=>"node-35", "name"=>"转义字符", "desc"=>"字符串里的一类特殊字符的表示方法", "required"=>false, "is_learned"=>false}
        ], 
        "relations"=>[
          {"parent"=>"node-31", "child"=>"node-32"}, 
          {"parent"=>"node-31", "child"=>"node-35"}, 
          {"parent"=>"node-32", "child"=>"node-33"}, 
          {"parent"=>"node-33", "child"=>"node-34"}
        ]
      }

    }
  end

  context '#concepts' do
    before{
      @node_31_concept = FactoryGirl.create :concept, {
        :knowledge_node_id => @node_31_adapter.node.id,
        :knowledge_net_id => @net_id
      }
      @node_32_concept = FactoryGirl.create :concept, {
        :knowledge_node_id => @node_32_adapter.node.id,
        :knowledge_net_id => @net_id
      }
      @node_1_concept = FactoryGirl.create :concept, {
        :knowledge_node_id => @node_1_adapter.node.id,
        :knowledge_net_id => @net_id
      }

      get :concepts, :knowledge_net_id => @net_id, :id => 'set-8'
      @json = JSON::parse(response.body)
    }

    it{
      @json.count.should == 2
    }
  end

end