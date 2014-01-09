require "spec_helper"

describe KnowledgeSetsController do
  before{
    @user = FactoryGirl.create :user
    sign_in @user
  }

  context '#knowledge_sets nodes' do
    before{
      get :nodes, {:knowledge_net_id => 'test1', :id => 'set-8'} 
      @json = JSON::parse(response.body)
    }

    it{
      @json.should == {
        "nodes" => [
          {"id"=>"node-31", "name"=>"字符串", "desc"=>"怎样在程序里表示一个字符串", "required"=>true, "is_unlocked"=>true, "is_learned"=>false}, 
          {"id"=>"node-32", "name"=>"整数", "desc"=>"怎样在程序里表示一个整数", "required"=>true, "is_unlocked"=>false, "is_learned"=>false}, 
          {"id"=>"node-33", "name"=>"小数", "desc"=>"怎样在程序里表示一个小数（浮点数）", "required"=>true, "is_unlocked"=>false, "is_learned"=>false}, 
          {"id"=>"node-34", "name"=>"布尔值", "desc"=>"怎样在程序里表示一个布尔值", "required"=>true, "is_unlocked"=>false, "is_learned"=>false}, 
          {"id"=>"node-35", "name"=>"转义字符", "desc"=>"字符串里的一类特殊字符的表示方法", "required"=>false, "is_unlocked"=>false, "is_learned"=>false}
        ], 
        "relations" => [
          {"parent"=>"node-31", "child"=>"node-32"}, 
          {"parent"=>"node-31", "child"=>"node-35"}, 
          {"parent"=>"node-32", "child"=>"node-33"}, 
          {"parent"=>"node-33", "child"=>"node-34"}
        ]
      }

    }
  end

end