require File.dirname(__FILE__) + '/spec_helper'

describe Tres::App do
  before do
    FileUtils.rm_rf TMP/'temp'
    stub_listener!
    @app = Tres::App.new TMP/'temp'
  end

  context 'creating a new app' do
    it "creates a folder for the app on" do
      File.directory?(TMP/'temp').should be_true
    end

    it "creates a assets folder with scripts and styles in it" do
      File.directory?(TMP/'temp'/'assets').should be_true
      File.directory?(TMP/'temp'/'assets'/'stylesheets').should be_true
      File.directory?(TMP/'temp'/'assets'/'javascripts').should be_true
    end

    it "creates a build folder in the app's folder" do
      File.directory?(TMP/'temp'/'build').should be_true
    end

    it "creates a packager" do
      @app.asset_packager.should be_a Tres::AssetPackager
    end

    it "creates a listener for templates" do
      @app.listener.should_not be_nil # yeah, sorta
    end
  end  
end