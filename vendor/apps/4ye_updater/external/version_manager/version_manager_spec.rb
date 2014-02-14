require './version_manager'

android_file = File.dirname(__FILE__) + '/android.yaml'
ios_file = File.dirname(__FILE__) + '/ios.yaml'


# 在没有YAML文件的情况下，测试 add_version
describe VersionManager do
  before {
    File.delete(android_file) if File.exists?(android_file)
    File.delete(ios_file) if File.exists?(ios_file)
  }

  it "add_version 正常添加, 文件不为空" do
    expect(VersionManager.add_version('ios', '5.0', true, 'five')).to be > 0
  end

  it "add_version 正常添加, 文件不为空" do
    expect(VersionManager.add_version('android', '3.0', true, 'five')).to be > 0
  end

  it "add_version 正常添加, 文件为空" do
    expect(VersionManager.add_version('android', '3.0', nil, 'five')).to eq(nil)
  end
end


describe VersionManager do
  before {
    File.open(android_file, 'w+') {|f| f.write('') }
    File.open(ios_file, 'w+') {|f| f.write('') }
  }

  it "get_newest_version 最新版本号" do
    expect(VersionManager.get_newest_version('android')).to eq(nil)
  end

  it "get_newest_milestone_version 最新里程碑" do
    expect(VersionManager.get_newest_milestone_version('android')).to eq(nil)
  end

  it "get_changelog" do
    expect(VersionManager.get_changelog('android', '1.0')).to eq(nil)
  end

  describe "初始化 android yaml 数据" do
    before {
      VersionManager.add_version('android', '1.0.0', true, 'one')
      VersionManager.add_version('android', '2.0.3', true, 'two')
      VersionManager.add_version('android', '3.1.2', true, 'three')
      VersionManager.add_version('android', '4.3.5', false, 'four')
    }

    it "get_newest_version 最新版本号" do
      expect(VersionManager.get_newest_version('android')).to eq('4.3.5')
    end

    it "get_newest_milestone_version 最新里程碑 version" do
      expect(VersionManager.get_newest_milestone_version('android')).to eq('3.1.2')
    end

    it "get_changelog" do
      expect(VersionManager.get_changelog('android', '2.0.3')).to eq('two')
    end


    describe "正确添加 add_version" do
      before {
        VersionManager.add_version('android', '5.0.1', false, 'five')
      }

      it "get_newest_version 最新版本号" do
        expect(VersionManager.get_newest_version('android')).to eq('5.0.1')
      end

      it "get_newest_milestone_version 最新里程碑 version" do
        expect(VersionManager.get_newest_milestone_version('android')).to eq('3.1.2')
      end

      it "get_changelog" do
        expect(VersionManager.get_changelog('android', '3.1.2')).to eq('three')
      end

      it "文件长度" do
        expect(VersionManager.init_yaml(android_file).length).to eq(5)
      end
    end


    describe "使用非法参数" do
      it "add_version 添加, platform = abc" do
        expect(VersionManager.add_version('abc', '5.0', true, 'five')).to eq(nil)
      end

      it "add_version 添加, platform 为空" do
        expect(VersionManager.add_version('', '5.0', true, 'five')).to eq(nil)
      end

      it "add_version 添加, version 为空" do
        expect(VersionManager.add_version('android', '', true, 'five')).to eq(nil)
      end

      it "add_version 添加, is_milestone 为空" do
        expect(VersionManager.add_version('android', '5.0.1', '', 'five')).to eq(nil)
      end

      it "add_version 添加, changelog 为空" do
        expect(VersionManager.add_version('android', '5.0.1', 'true', '')).to eq(nil)
      end

      it "add_version 添加, version 相同" do
        expect(VersionManager.add_version('android', '3.1.2', 'true', 'three')).to eq(nil)
      end

      it "add_version 添加, is_milestone 为其它值" do
        expect(VersionManager.add_version('android', '6.0.0', 'in_milestone', 'six')).to eq(nil)
      end

    end


    describe "version 最大的排到最前面" do
      it "非法的 version" do
        expect(VersionManager.add_version('android', 'a.0.1', false, 'five')).to eq(nil)
      end

      it "非法的 version" do
        expect(VersionManager.add_version('android', '3.0.1.9', false, 'five')).to eq(nil)
      end

      it "非法的 version" do
        expect(VersionManager.add_version('android', '3', false, 'five')).to eq(nil)
      end

      it "非法的 version" do
        expect(VersionManager.add_version('android', '5000,.0', true, 'five')).to eq(nil)
      end

      it "非法的 version" do
        expect(VersionManager.add_version('android', '23.12,23', true, 'five')).to eq(nil)
      end

      it "非法的 version" do
        expect(VersionManager.add_version('android', '23.12.99.11', true, 'five')).to eq(nil)
      end

      it "非法的 version" do
        expect(VersionManager.add_version('android', 'aa.bb.cc', true, 'five')).to eq(nil)
      end

      it "第一个数字没有最大" do
        expect(VersionManager.add_version('android', '3.0.1', false, 'five')).to eq(nil)
      end

      describe "第一个数字一样的情况下" do
        it "第二个数字没有最大" do
          expect(VersionManager.add_version('android', '4.2.8', false, 'five')).to eq(nil)
        end

        describe "第二个数字一样的情况下" do
          it "第三个数字没有最大" do
            expect(VersionManager.add_version('android', '4.3.0', false, 'five')).to eq(nil)
          end

          it "第三个数字最大" do
            expect(VersionManager.add_version('android', '4.3.12', false, 'four')).to be > 0
          end

          it "第三个数字最大" do
            expect(VersionManager.add_version('android', '4.3.9', false, 'four')).to be > 0
          end

          it "第三个数字一样" do
            expect(VersionManager.add_version('android', '4.3.5', false, 'four')).to eq(nil)
          end

        end

        it "第二个数比较大的情况" do
          expect(VersionManager.add_version('android', '4.4.1', false, 'four')).to be > 0
        end

      end

    end


    describe "同时添加到 android ios yaml" do
      before {
        VersionManager.add_version('android', '1.0.0', true, 'one')
        VersionManager.add_version('ios', '1.0.0', false, 'one')
        VersionManager.add_version('ios', '2.0.0', false, 'two')
        VersionManager.add_version('ios', '3.0.0', false, 'three')
        VersionManager.add_version('android', '4.3.5', false, 'four')
        VersionManager.add_version('android', '5.0.1', true, 'five')
        VersionManager.add_version('android', '6.0.0', false, 'six')
        VersionManager.add_version('ios', '4.0.0', false, 'four')
      }

      it "android get_newest_version 最新版本号" do
        expect(VersionManager.get_newest_version('android')).to eq('6.0.0')
      end

      it "android get_newest_milestone_version 最新里程碑 version" do
        expect(VersionManager.get_newest_milestone_version('android')).to eq('5.0.1')
      end

      it "android get_changelog" do
        expect(VersionManager.get_changelog('android', '5.0.1')).to eq('five')
      end


      it "ios get_newest_version 最新版本号" do
        expect(VersionManager.get_newest_version('ios')).to eq('4.0.0')
      end

      it "ios get_newest_milestone_version 最新里程碑 version" do
        expect(VersionManager.get_newest_milestone_version('ios')).to eq(nil)
      end

      it "ios get_changelog" do
        expect(VersionManager.get_changelog('ios', '3.0.0')).to eq('three')
      end

      it "android 文件长度" do
        expect(VersionManager.init_yaml(android_file).length).to eq(6)
      end

      it "ios 文件长度" do
        expect(VersionManager.init_yaml(ios_file).length).to eq(4)
      end
    end

    

  end

end
