require File.dirname(__FILE__) + '/spec_helper'

describe Tres::TemplateManager do
  before do
    FileUtils.rm_rf TMP/'temp'
    @compiler = Tres::TemplateManager.new :root => Anagen.root
    clean_build!
  end

  context 'removing templates' do
    after  { restore_anagen! }

    it "removes a template from templates.js if removed from <APP ROOT>/templates" do
      @compiler.compile_to_templates_js 'book.haml'
      @compiler.remove_template 'book.haml'
      Anagen.templates_js.contents.should_not include "JST[\"book\"]"
    end

    it "removes a template from build/templates if removed from <APP ROOT>/templates" do
      @compiler.remove_template 'book.haml'
      File.exists?(Anagen.templates/'book.haml').should be_false
    end

    it "leaves build/index.html alone no matter what" do
      @compiler.compile_to_build 'index.html'
      @compiler.remove_template 'index.html'  
      File.exists?(Anagen.build/'index.html').should be_true
    end

    it "removes more than one template if you pass an array to #remove_template" do
      @compiler.remove_template ['book.haml', 'books/li.haml']
      File.exists?(Anagen.templates/'book.haml').should be_false
      File.exists?(Anagen.templates/'books/'/'li.haml').should be_false
    end
  end

  context 'compiling' do
    describe '#compile_to_build' do
      it "with a template not index.*, it simply copies it over to build/<path> if the extension is .html" do
        @compiler.compile_to_build 'books/li.haml'
        (Anagen.build_templates/'books'/'li.html').contents.should == (Anagen.templates/'books'/'li.haml').compile
      end

      it "with templates/index.*, compiles to build/index.html" do
        @compiler.compile_to_build 'index.html'
        (Anagen.build/'index.html').contents.should == (Anagen.templates/'index.html').contents
      end
    end

    context '#compile_to_templates_js' do
      it "adds a template to a global JST object in templates.js" do
        @compiler.compile_to_templates_js 'book.haml'
        Anagen.templates_js.contents.should include (Anagen.templates/'book.haml').escaped_compile
      end
    end

    context '#compile_all' do
      it 'compiles index.* to build/' do
        @compiler.stub :compile_to_templates_js => false
        @compiler.compile_all
        (Anagen.build/'index.html').contents.should == (Anagen.templates/'index.html').contents
      end

      it 'compiles everything else to build/js/templates.js' do
        @compiler.stub :compile_to_build => false
        @compiler.compile_all
        Anagen.templates_js.contents.should include (Anagen.templates/'book.haml').escaped_compile
        Anagen.templates_js.contents.should include (Anagen.templates/'books'/'li.haml').escaped_compile
      end
    end
  end

  context 'creating templates' do
    after { restore_anagen! }

    it "creates a new template with #new_template" do
      @compiler.new_template 'fridges.haml'
      File.exists?(Anagen.templates/'fridges.haml').should be_true
    end

    it "defaults to haml if no extension is provided" do
      @compiler.new_template 'cups'
      File.exists?(Anagen.templates/'cups.haml').should be_true
    end

    it "creates the directories to a path if necessary" do
      @compiler.new_template 'zomg/fridges.haml'
      File.directory?(Anagen.templates/'zomg').should be_true
    end

    it "raises TemplateExistsError if a template in the same path exists" do
      @compiler.new_template 'forks.haml'
      lambda { @compiler.new_template 'forks.haml' }.should raise_error(Tres::TemplateExistsError)
    end
  end
end