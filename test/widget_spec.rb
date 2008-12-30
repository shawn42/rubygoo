require File.dirname(__FILE__)+"/test_setup.rb"

describe Widget do

  describe "basic widget behavior" do
    before :each do
      @widget = Widget.new
    end

    it "should merge in defaults for any options not given" do
      for k,v in Widget::DEFAULT_PARAMS
        @widget.instance_variable_get("@#{k}").should == v
      end
    end

    it "should define props methods for each of the default params" do
      Widget::DEFAULT_PARAMS.keys.each_with_index do |k,i|
        @widget.should.respond_to? k 
        @widget.send(k,i)
        @widget.send(k).should == i
      end
    
    end

  end

end
