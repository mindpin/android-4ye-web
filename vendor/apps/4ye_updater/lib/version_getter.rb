require File.expand_path('../../external/version_manager/version_manager.rb', __FILE__)
require "json"

class VersionGetter
  UPDATE = {:force => 'force', :exist => 'exist', :none => 'none'}
  PLATFORM = {:android => 'android', :ios => 'ios'}

  attr_reader :version, :newest, :last_milestone, :update, :platform

  def initialize(params)
    @platform = PLATFORM[:android]
    @version = params[:version] || '0.0.0'
    @newest = VersionManager.get_newest_version(@platform)
    @last_milestone = VersionManager.get_newest_milestone_version(@platform)
    @update = _update
  end

  def response
    hash = {
      :newest         => @newest,
      :last_milestone => @last_milestone,
      :current        => @version,
      :update         => @update
    }
    JSON.generate(hash)
  end

  private
    def _update
      _check_version

      return UPDATE[:none] if @version == @newest

      return UPDATE[:force] if VersionManager.first_verion_more_than_second?(@last_milestone, @version) 

      UPDATE[:exist]
    end

    def _check_version
      if @newest.nil? && @last_milestone.nil?
        @newest,@last_milestone = @version,@version
        VersionManager.add_version(@platform, @version, false, '第一次')
      end
    end
end