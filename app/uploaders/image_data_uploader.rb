# -*- coding: utf-8 -*-
class ImageDataUploader < CarrierWave::Uploader::Base
  storage :aliyun

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def dir_prefix
    `ruby #{Rails.root.to_s}/deploy/sh/parse_property.rb ALIYUN_BASE_DIR`
  end

  def store_dir
    "/#{dir_prefix}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 给上传的文件重新命名
  def filename
    if original_filename.present?
      ext = file.extension.blank? ? '' : ".#{file.extension}"
      "#{secure_token}#{ext}"
    end
  end

  private
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) || model.instance_variable_set(var, randstr)
    end
end
