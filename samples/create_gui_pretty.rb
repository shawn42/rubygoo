module CreateGui
  def create_gui(renderer, joystick_icon)
    p self.id
    my_app = app :renderer => renderer do

      p self.id
      label "click the button to set the time" do
        p self.id
        self.x = 20
        self.y = 30
      end
#
#      button "Click Me!" do 
#        x 70
#        y 80
#        x_pad 20
#        y_pad 20
#        icon joystick_icon
#        enabled false
#        on :pressed do |*opts|
#          # HOW TO DO THIS?
#          label.set_text(Time.now.to_s)
#        end
#      end
#
#      icon do
#        x 280
#        y 80
#        icon joystick_icon
#      end

#      # or use a hash to specify
#      check :x=>370, :y=>70, :w=>20, :h=>20, :label=> "Check me out!" do
#        on :mouse_enter do
#          puts "ENTERING #{self.class}"
#        end
#
#        on :mouse_exit do
#          puts "EXITING #{self.class}"
#        end
#
#        on :checked do
#          label.set_text("CHECKED [#{check.checked?}]")
#          if check.checked?
#            button.enable
#          else
#            button.disable
#          end
#        end
    end

    my_app
  end
end
