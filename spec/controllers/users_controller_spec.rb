require "spec_helper"

describe UsersController do
  before{
    @user = FactoryGirl.create :user
  }

  context '#exp_info init' do
    before {
      get :exp_info, {id: @user.id}, {:course => 'javascript'} 
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
      net = KnowledgeNet.get_by_name("javascript")
      @checkpoint = net.find_checkpoint_by_id("checkpoint-1")
      @node = net.find_node_by_id("node-31")

      @user.add_exp('javascript',8,@checkpoint,@user.to_json)
      @user.add_exp('javascript',14,@node,@user.to_json)

      get :exp_info, {id: @user.id,:course => 'javascript'}
      @json = JSON::parse(response.body)
    }

    it {
      @json['level'].should == 2
      @json['level_up_exp_num'].should  == ExperienceStatus::LEVEL_UP_EXP_NUM[1]
      @json['exp_num'].should           == 12
    }
  end
end