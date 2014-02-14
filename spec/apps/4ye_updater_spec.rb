require "spec_helper"

describe UpdaterApp do
  include Rack::Test::Methods

  def app
    UpdaterApp
  end

  def new_file
    Rack::Test::UploadedFile.new("./spec/resources/bla.apk")
  end

  def json_response
    JSON.parse(last_response.body)
  end

  def rm_yaml
    FileUtils.rm(Dir["./spec/resources/*.yaml"])
  end

  def rm_apks
    FileUtils.rm(Dir["./spec/resources/*.apk"])
  end

  before do
    File.open("./spec/resources/bla.apk", "w").close()

    @publish_path = "/api/publish"
    @version1 = "0.0.1"
    @version2 = "0.0.2"

    def VersionManager.file_path(platform)
      "#{File.dirname(__FILE__)}/../resources/android.yaml"
    end
  end

  after do
    rm_yaml
    rm_apks
  end

  it "fails without package" do
    post @publish_path, "version" => @version1
    expect(last_response.body).to include "no package provided"
  end

  it "fails with low version" do
    post @publish_path, "version" => @version2, "package" => new_file 
    post @publish_path, "version" => @version1, "package" => new_file 
    expect(last_response.body).to include "low version"
  end

  it "succeeds with right version and package" do
    post @publish_path, "version" => @version2, "package" => new_file 
    expect(last_response.body).to include "success"
    uploader = ApkUploader.new
    uploader.retrieve_from_store!("4ye-#{@version2}.apk")
    url = URI.parse uploader.file.url
    res = Net::HTTP.new(url.host, url.port).request_head(url.path)
    expect(res.code).to eq "200"
    expect(json_response["newest_version"]).to eq @version2
  end

  it "saves milestone version" do
    post @publish_path, "version" => @version2, "package" => new_file, "is_milestone" => "true"
    expect(json_response["newest_milestone"]).to eq @version2
  end

  it "can download file" do
    post @publish_path, "version" => @version2, "package" => new_file, "is_milestone" => "true"
    get "/download/android/4ye-newest.apk"
    expect(last_response.status).to eq 302
  end
end
