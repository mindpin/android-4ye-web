class ImageData
  include Mongoid::Document
  include Mongoid::Timestamps

  field :file,     :type => String
  field :origin_file_name, :type => String

  mount_uploader :file, ImageDataUploader

  attr_accessible :file, :file_cache
end