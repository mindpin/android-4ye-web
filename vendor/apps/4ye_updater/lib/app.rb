require "bundler"
require "sinatra/base"
require File.expand_path('../version_updater.rb', __FILE__)

class UpdaterApp < Sinatra::Base
  configure :production, :development do
    enable :logging
  end

  get "/download/android/4ye-:version.apk" do
    version = get_version(params)
    return 404 if !version
    uploader = ApkUploader.new
    uploader.retrieve_from_store!("4ye-#{version}.apk")
    redirect uploader.file.url
  end

  post "/api/check_version" do
    VersionGetter.new(params).response
  end

  post "/api/publish" do
    VersionUpdater.new(params).response
  end

  protected

  def get_version(params)
    params[:version] == "newest" ? VersionManager.get_newest_version("android") : params[:version]
    
  end
end
