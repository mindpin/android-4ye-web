require "spec_helper.rb"

describe ExperienceLog do
  let(:user){FactoryGirl.create :user}
  let(:user1){FactoryGirl.create :user}

  describe ExperienceLog::UserMethods do
    before(:all){
      net = KnowledgeNet.get_by_name("javascript")
      @checkpoint = net.find_checkpoint_by_id("checkpoint-1")
      @node = net.find_node_by_id("node-31")
    }

    before {
      @delta_num = 8
      @model = {:type => 'set', :id=>"set_101"}
      @data_json = user.to_json
      @course = 'javascript'
    }

    describe '.add_exp' do
      it {
        expect{
          user.add_exp(@course,@delta_num,@checkpoint,@data_json)
          user.add_exp(@course,@delta_num,@node,@data_json)
        }.to change{
          ExperienceLog.count
        }.by(2)
      }

      it {
        user.add_exp(@course,@delta_num,@checkpoint,@data_json)
        user.experience_logs.first.before_exp.should  == 0
        user.experience_logs.first.after_exp.should   == 8

        user.experience_logs.first.model_type.should == @checkpoint.class.name
        user.experience_logs.first.model_id.should  == @checkpoint.checkpoint_id

        user.experience_logs.first.course.should  == @course

      }
    end

    describe '.experience_logs' do
      it {
        user.add_exp(@course,@delta_num,@checkpoint,@data_json)
        user1.add_exp(@course,@delta_num,@node,@data_json)
        user.add_exp(@course,@delta_num,@checkpoint,@data_json)

        user.experience_logs.count.should == 2
        user1.experience_logs.count.should == 1
      }
    end

    describe '.experience_status(@course)' do
      it {
        status = user.experience_status(@course)
        status.level.should == 1
        status.level_up_exp_num.should == ExperienceStatus::LEVEL_UP_EXP_NUM[0]
        status.exp_num.should == 0
      }

      it {
        user.add_exp(@course,8,@checkpoint,@data_json)
        status = user.experience_status(@course)
        status.level.should == 1
        status.level_up_exp_num.should == ExperienceStatus::LEVEL_UP_EXP_NUM[0]
        status.exp_num.should == 8
      }

      it {
        user.add_exp(@course,8,@node,@data_json)
        user.add_exp(@course,14,@checkpoint,@data_json)
        status = user.experience_status(@course)
        status.level.should == 2
        status.level_up_exp_num.should == ExperienceStatus::LEVEL_UP_EXP_NUM[1]
        status.exp_num.should == 12
      }
    end

  end




end