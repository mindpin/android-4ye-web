require "spec_helper.rb"

describe ExperienceLog do
  let(:user){FactoryGirl.create :user}
  let(:user1){FactoryGirl.create :user}

  describe ExperienceLog::UserMethods do
    before {
      @delta_num = 8
      @model = {:type => 'set', :id=>"set_101"}
      @data_json = user.to_json
    }

    describe '.add_exp' do
      it {
        expect{
          user.add_exp(@delta_num,@model,@data_json)
        }.to change{
          ExperienceLog.count
        }.by(1)
      }

      it {
        user.add_exp(@delta_num,@model,@data_json)
        user.experience_logs.first.before_exp.should  == 0
        user.experience_logs.first.after_exp.should   == 8

        user.experience_logs.first.model_type.should == @model[:type]
        user.experience_logs.first.model_id.should.  == @model[:id]
      }
    end

    describe '.experience_logs' do
      it {
        user.add_exp(@delta_num,@model,@data_json)
        user1.add_exp(@delta_num,@model,@data_json)
        user.add_exp(@delta_num,@model,@data_json)

        user.experience_logs.count.should == 2
        user1.experience_logs.count.should == 1
      }
    end

    describe '.experience_status' do
      it {
        status = user.experience_status
        status.level.should == 1
        status.level_up_exp_num.should == ExperienceStatus::LEVEL_UP_EXP_NUM[0]
        status.exp_num.should == 0
      }

      it {
        user.add_exp(8,@model,@data_json)
        status = user.experience_status
        status.level.should == 1
        status.level_up_exp_num.should == ExperienceStatus::LEVEL_UP_EXP_NUM[0]
        status.exp_num.should == 8
      }

      it {
        user.add_exp(8,@model,@data_json)
        user.add_exp(14,@model,@data_json)
        status = user.experience_status
        status.level.should == 2
        status.level_up_exp_num.should == ExperienceStatus::LEVEL_UP_EXP_NUM[1]
        status.exp_num.should == 12
      }
    end

  end




end