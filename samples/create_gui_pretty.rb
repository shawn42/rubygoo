module CreateGui
  def create_gui(renderer, joystick_icon)
    my_app = goo_app :renderer => renderer do

      label "click the button to set the time", :id => :display_label do
        x 20
        y 30
      end

      button "Click Me!", :id => :clicky do 
        x 70
        y 80
        padding_left 20
        padding_top 20
        icon_image joystick_icon
        enabled false
      end

      icon do
        x 280
        y 80
        icon_image joystick_icon
      end

      # or use a hash to specify
      check_box :x=>370,:y=>70, :w=>20,:h=>20,:id=>:checky  do
        label_text "Check me out!"
      end

      # setup events
      get(:clicky).on :pressed do
        get(:display_label).set_text(Time.now.to_s)
      end
      get(:checky).when :mouse_enter do
        puts "ENTERING"
      end
      get(:checky).when :checked do
        get(:display_label).set_text("CHECKED [#{get(:checky).checked?}]")
        if get(:checky).checked?
          get(:clicky).enable
        else
          get(:clicky).disable
        end
      end
    end


    my_app
  end
end
