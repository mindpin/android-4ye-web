require "bundler"
Bundler.setup(:default)
require "carrierwave-aliyun"

class ApkUploader < CarrierWave::Uploader::Base
  storage :aliyun

  process :force_content_type

  def force_content_type
    file.content_type = "application/octet-stream"
  end

  def filename=(str)
    @_filename = str
  end

  def filename
    @_filename
  end

  def dir_prefix
    `ruby #{Rails.root.to_s}/deploy/sh/parse_property.rb ALIYUN_BASE_DIR`
  end

  def store_dir
    "/#{dir_prefix}/android"
  end

  def cache_dir
    "/tmp/apk_uploads/"
  end
end
