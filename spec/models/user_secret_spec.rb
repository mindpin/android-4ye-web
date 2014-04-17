require 'spec_helper'

describe UserSecret do
  before {
    @user = FactoryGirl.create :user
  }

  it{
    @user.user_secret.blank?.should == true

    @user = User.find(@user.id)

    @secret_1 = @user.secret
    @secret_1.blank?.should == false

    @user = User.find(@user.id)

    @user.user_secret.secret.blank?.should == false

    @user = User.find(@user.id)

    @user.secret.should == @secret_1
  }
end
