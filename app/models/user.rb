# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :recoverable
  devise :database_authenticatable, :registerable, 
         :rememberable, :trackable, :validatable,
         :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  validates :login, :format => {:with => /\A\w+\z/, :message => '只允许数字、字母和下划线'},
                    :length => {:in => 3..20},
                    :presence => true,
                    :uniqueness => {:case_sensitive => false},
                    :unless => Proc.new { |user|
                      user.login == user.email
                    }

  validates :email, :uniqueness => {:case_sensitive => false}

  validates :name, :presence => true,
                   :uniqueness => {:case_sensitive => false}

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    self.where(:login => login).first || self.where(:email => login).first
  end

  # ------------ 以上是用户登录相关代码，不要改动
  # ------------ 任何代码请在下方添加

  validates :tagline, :length => {:in => 0..150}

  # carrierwave
  mount_uploader :avatar, AvatarUploader
  attr_accessible :name, :tagline, :avatar
  attr_accessor :avatar_cw, :avatar_ch, :avatar_cx, :avatar_cy

  mount_uploader :userpage_head, UserPageHeadUploader
  attr_accessible :userpage_head

  def normal_avatar_url
    avatar.versions[:normal].url
  end

  include ExperienceLog::UserMethods
end
