# 一些 session 信息
# 从默认的 secret_token 和 session_store 两个配置文件合并而来

Android4yeWeb::Application.config.secret_token = '3e9751783a4afb81071d579640c1f36b077aa7e29bcb7e407f66844f518536c067df3196c5a1b1e2abc2089ceff7bdb74e484375b08ee342683d36a17303c546'

case Rails.env
when 'production'
  Android4yeWeb::Application.config.session_store :cookie_store,
    :key => '_4ye_session'
when 'development'
  Android4yeWeb::Application.config.session_store :cookie_store,
    :key => '_4ye_session_devel'
end