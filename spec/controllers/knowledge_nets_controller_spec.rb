require "spec_helper"

describe KnowledgeNetsController do
  before{
    @user = FactoryGirl.create :user
    sign_in @user
  }

  context '#exp_info init' do
    before {
      get :exp_info, {:id => 'test1'} 
      @json = JSON::parse(response.body)
    }

    it {
      @json['level'].should             == 1
      @json['level_up_exp_num'].should  == ExperienceStatus::LEVEL_UP_EXP_NUM[0]
      @json['exp_num'].should           == 0
    }
  end

  context '#exp_info add exp' do
    before {
      net_id = "test1"
      net = KnowledgeSpaceNetLib::KnowledgeNet.find(net_id)
      @checkpoint = net.find_checkpoint_by_id("checkpoint-1")
      @node = net.find_node_by_id("node-31")

      @user.add_exp(net_id,8,@checkpoint,@user.to_json)
      @user.add_exp(net_id,14,@node,@user.to_json)

      get :exp_info, {id: net_id}
      @json = JSON::parse(response.body)
    }

    it {
      @json['level'].should == 2
      @json['level_up_exp_num'].should  == ExperienceStatus::LEVEL_UP_EXP_NUM[1]
      @json['exp_num'].should           == 12
    }
  end

  context '#knowledge_nets list' do
    before {
      get :list
      @json = JSON::parse(response.body)
    }

    it {
      @json.should == [
        {"id"=>"javascript", "name"=>"javascript"}, 
        {"id"=>"test1", "name"=>"测试1"}
      ]
    }
  end

  context '#knowledge_nets show' do
    before {
      get :show, :id => 'test1'
      @json = JSON::parse(response.body)
    }

    it{
      @json.should == {
        "id"=>"test1", 
        "name"=>"测试1", 
        "sets"=>[
          {"id"=>"set-1", "name"=>"基础: 变量", "icon"=>"set-1", "deep"=>3, "is_unlocked"=>false, "is_learned"=>false, "node_count"=>5, "learned_node_count"=>0}, 
          {"id"=>"set-2", "name"=>"基础: 运算符", "icon"=>"set-2", "deep"=>2, "is_unlocked"=>false, "is_learned"=>false, "node_count"=>4, "learned_node_count"=>0}, 
          {"id"=>"set-3", "name"=>"基础: 语句", "icon"=>"set-3", "deep"=>3, "is_unlocked"=>false, "is_learned"=>false, "node_count"=>5, "learned_node_count"=>0}, 
          {"id"=>"set-4", "name"=>"选择结构", "icon"=>"set-4", "deep"=>5, "is_unlocked"=>false, "is_learned"=>false, "node_count"=>4, "learned_node_count"=>0}, 
          {"id"=>"set-5", "name"=>"循环结构", "icon"=>"set-5", "deep"=>6, "is_unlocked"=>false, "is_learned"=>false, "node_count"=>4, "learned_node_count"=>0}, 
          {"id"=>"set-6", "name"=>"对象 1", "icon"=>"set-6", "deep"=>6, "is_unlocked"=>false, "is_learned"=>false, "node_count"=>3, "learned_node_count"=>0}, 
          {"id"=>"set-7", "name"=>"对象 2", "icon"=>"set-7", "deep"=>7, "is_unlocked"=>false, "is_learned"=>false, "node_count"=>5, "learned_node_count"=>0}, 
          {"id"=>"set-8", "name"=>"基础: 值", "icon"=>"set-8", "deep"=>1, "is_unlocked"=>true, "is_learned"=>false, "node_count"=>5, "learned_node_count"=>0}
        ], 
        "checkpoints"=>[
          {"id"=>"checkpoint-1", "learned_sets"=>["set-1", "set-2", "set-8", "set-3"], "is_unlocked"=>true, "is_learned"=>false}
        ], 
        "relations"=>[
          {"parent"=>"set-1", "child"=>"checkpoint-1"}, 
          {"parent"=>"set-2", "child"=>"set-3"}, 
          {"parent"=>"set-2", "child"=>"set-1"}, 
          {"parent"=>"set-3", "child"=>"checkpoint-1"}, 
          {"parent"=>"set-4", "child"=>"set-5"}, 
          {"parent"=>"set-4", "child"=>"set-6"}, 
          {"parent"=>"set-6", "child"=>"set-7"}, 
          {"parent"=>"set-8", "child"=>"set-2"}, 
          {"parent"=>"checkpoint-1", "child"=>"set-4"}
        ]
      }
    }
  end
end