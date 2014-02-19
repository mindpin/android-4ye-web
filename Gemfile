# coding: utf-8
# source 'http://rubygems.org'
source 'http://ruby.taobao.org'

gem 'rails', '3.2.12' # RAILS #不要更新 3.2.13 有性能问题，等 3.2.14
gem 'mysql2', '0.3.11' # MYSQL数据库连接
gem 'json', '1.7.7' # JSON解析，RAILS默认引入的
gem "coderay", "~> 1.1.0"

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'jquery-rails', '~> 2.1' 
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'turbo-sprockets-rails3', '0.3.2' # 加速预编译
end

group :test do
  gem 'database_cleaner', '~> 1.2.0'
  gem 'rspec-rails', '~> 3.0.0.beta'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'timecop', '0.6.1' # 用于在测试中调整时间
  # 4ye_updater 需要
  gem "rack-test"
end

gem 'unicorn', '4.6.2'
# 登录验证
gem 'devise', '2.2.4'
# 页面渲染
gem 'haml', '4.0.3' # HAML模板语言
# 文件上传（fushang318增加） 
gem "carrierwave", "0.8.0"
gem 'carrierwave-mongoid'
gem 'rest-client'
gem 'carrierwave-aliyun', :git => 'git://github.com/huacnlee/carrierwave-aliyun.git', :ref => 'e7537c9ae0d9cda211c0a718c94a84c77c7d66af'
# carrierwave 用到的图片切割
gem "mini_magick", "3.5.0", :require => false
# mongoid
gem "mongoid", "~> 3.0.0"

gem "sinatra"

gem 'knowledge-space-net-lib',
    :git => 'git://github.com/mindpin/knowledge-space-net-lib.git',
    :tag => '0.4.0'

gem 'roles-field',
    :git => 'git://github.com/mindpin/roles-field.git'

gem 'mina',
    :git => 'git://github.com/fushang318/mina.git',
    :tag => 'v0.2.0fix'