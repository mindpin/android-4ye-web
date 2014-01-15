HASH = {
  :convert_base_path => '../public'
}

class R
  CONVERT_BASE_PATH = File.expand_path(HASH[:convert_base_path], Rails.root.join('config'))
  STATIC_FILES_DIR = "static_files"
  UPLOAD_BASE_PATH = File.join(CONVERT_BASE_PATH, STATIC_FILES_DIR)
end

project_4ye_path = File.expand_path("../../../",__FILE__)
aliyun_access_id = `ruby #{project_4ye_path}/deploy/sh/parse_property.rb ALIYUN_ACCESS_ID`
aliyun_access_key = `ruby #{project_4ye_path}/deploy/sh/parse_property.rb ALIYUN_ACCESS_KEY`

CarrierWave.configure do |config|
  config.aliyun_access_id = aliyun_access_id
  config.aliyun_access_key = aliyun_access_key
  # 你需要在 Aliyum OSS 上面提前创建一个 Bucket
  config.aliyun_bucket = "4ye-dev"
  # 是否使用内部连接，true - 使用 Aliyun 局域网的方式访问  false - 外部网络访问
  config.aliyun_internal = false
  # 配置存储的地区数据中心，默认: cn-hangzhou
  config.aliyun_area = "cn-qingdao" 
  # 使用自定义域名，设定此项，carrierwave 返回的 URL 将会用自定义域名
  # 自定于域名请 CNAME 到 you_bucket_name.oss.aliyuncs.com (you_bucket_name 是你的 bucket 的名称)
  # config.aliyun_host = "http://you_bucket_name.oss.aliyuncs.com" 
end
