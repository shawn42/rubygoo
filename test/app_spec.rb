require File.dirname(__FILE__)+"/test_setup.rb"

describe App do

  describe "basic app behavior" do
    before :each do
#      @widget = Map.new
    end

    it "should merge in defaults for any options not given" do
      @app = App.new
      for k,v in App::DEFAULT_PARAMS.dup.delete(:theme)
        @app.instance_variable_get("@#{k}").should == v
      end

      theme_dir = File.join(App::DEFAULT_PARAMS[:data_dir], 
                            App::DEFAULT_PARAMS[:theme])
      exp_theme = YAML::load_file(File.join(theme_dir,"config.yml"))
      @app.theme.should == exp_theme
    end

  end

end
