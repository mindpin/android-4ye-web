require "spec_helper"

describe SessionsController do
  before{
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create :user
  }

  it "正确登陆" do
    controller.current_user.should == nil
    post :create, :user => {:login => @user.login, :password => '1234'} 
    json = JSON::parse(response.body)
    response.status.should == 200
    json["id"].should == @user.id
    json["name"].should == @user.name
    json["login"].should == @user.login
    json["email"].should == @user.email
    json["avatar"].should == "http://test.host#{@user.normal_avatar_url}"
    controller.current_user.should == @user
  end

  it "登陆密码错误" do
    controller.current_user.should == nil
    post :create, :user => {:login => @user.login, :password => 'abc'} 
    json = JSON::parse(response.body)
    response.status.should == 401
    controller.current_user.should == nil
  end

  it "登出" do
    sign_in @user
    controller.current_user.should == @user
    post :destroy
    response.status.should == 200
    controller.current_user.should == nil
  end

end