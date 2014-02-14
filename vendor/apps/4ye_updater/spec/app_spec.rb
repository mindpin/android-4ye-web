require "./lib/app.rb"
require "test/unit"
require "bundler"
Bundler.setup
require "rack/protection"
require "rack/test"

class UpdaterAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    UpdaterApp
  end

  def new_file
    Rack::Test::UploadedFile.new("./spec/bla.apk")
  end

  def json_response
    JSON.parse(last_response.body)
  end

  def rm_yaml
    FileUtils.rm("./spec/android.yaml")
  end

  def rm_apks
    FileUtils.rm(Dir["./spec/*.apk"])
  end

  def setup
    ENV["APK_STORE"] = "file"
    File.open("./spec/bla.apk", "w").close()

    @publish_path = "/api/publish"
    @version1 = "0.0.1"
    @version2 = "0.0.2"

    def VersionManager.file_path(platform)
      "./spec/#{platform}.yaml"
    end

    ApkUploader.send(:remove_const, "LOCAL_DIR")
    ApkUploader.const_set("LOCAL_DIR", "spec")
  end

  def teardown
    rm_yaml
    rm_apks
  end

  def test_publish_api_without_package
    post @publish_path, "version" => @version1
    assert(last_response.body.include?("no package provided"))
  end

  def test_publish_api_with_low_version
    post @publish_path, "version" => @version2, "package" => new_file 
    post "/api/check_version", "version" => @version2
    post @publish_path, "version" => @version1, "package" => new_file 
    assert(last_response.body.include?("low version"))
  end

  def test_publish_api_with_right_version_and_package
    post @publish_path, "version" => @version2, "package" => new_file 
    assert(last_response.body.include?("success"))
    assert(File.exists?("./spec/4ye-#{@version2}.apk"))
    assert_equal(json_response["newest_version"], @version2)
  end

  def test_publish_api_with_right_version_and_package_and_milestone
    post @publish_path, "version" => @version2, "package" => new_file, "is_milestone" => "true"
    assert_equal(json_response["newest_milestone"], @version2)
  end
end
