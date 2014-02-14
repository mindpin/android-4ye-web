# 一些 session 信息
# 从默认的 secret_token 和 session_store 两个配置文件合并而来
project_4ye_path = File.expand_path("../../../",__FILE__)
PUBLISH_NAME          = `ruby #{project_4ye_path}/deploy/sh/parse_property.rb PUBLISH_NAME`
SESSION_SECRET_TOKEN  = `ruby #{project_4ye_path}/deploy/sh/parse_property.rb SESSION_SECRET_TOKEN`


case Rails.env
when 'production'
  Android4yeWeb::Application.config.secret_token = SESSION_SECRET_TOKEN
  Android4yeWeb::Application.config.session_store :cookie_store,
    :key => "_#{PUBLISH_NAME}_session"
when 'development'
  Android4yeWeb::Application.config.secret_token = SESSION_SECRET_TOKEN
  Android4yeWeb::Application.config.session_store :cookie_store,
    :key => "_#{PUBLISH_NAME}_session_devel"
when 'test'
  Android4yeWeb::Application.config.secret_token = SESSION_SECRET_TOKEN
  Android4yeWeb::Application.config.session_store :cookie_store,
    :key => "_#{PUBLISH_NAME}_session_test"
end