require "bundler"
require "sinatra/base"
require File.expand_path('../version_updater.rb', __FILE__)
require File.expand_path('../feedback_saver.rb', __FILE__)

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

  post "/api/submit_exception" do
    return 406 if params[:feedback]
    MobileFeedBackSaver.new(params).response
  end

  post "/api/submit_feedback" do
    return 406 if params[:exception_type] || params[:exception_stack]
    MobileFeedBackSaver.new(params).response
  end

  protected

  def get_version(params)
    if params[:version] == "newest"
    then VersionManager.get_newest_version("android")
    else params[:version]
    end
  end
end
