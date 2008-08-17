require 'rubygems'
$: << './lib'
require 'rubygoo'

if $0 == __FILE__
  app = App.new 

  label = Label.new "click the button to set the time", :x=>20, :y=>30

  button = Button.new "Click Me!", :x=>70, :y=>80, :x_pad=>20, :y_pad=>20
  button.on :pressed do |*opts|
    label.set_text(Time.now.to_s)
  end

  check = CheckBox.new :x=>370, :y=>70, :w=>20, :h=>20
  check.on :checked do
    label.set_text("CHECKED [#{check.checked?}]")
  end

  text_field = TextField.new "initial text", :x => 70, :y => 170

  text_field.on_key K_RETURN, K_KP_ENTER do |evt|
    puts "BOO-YAH"
  end


  # implicit tab ordering based on order of addition, can
  # specify if you want on widget creation

  # can add many or one at a time
  app.add text_field, label, button
  app.add check

#  pulldown = Pulldown.new {:x=>70, :y=>80}
#  pulldown.on :changed do |*opts|
#    label.set_text(opts.first)
#  end
#
#  app.add pulldown
  
  # rubygame standard stuff below here
  queue = EventQueue.new
  queue.ignore = [
    ActiveEvent, JoyAxisEvent, JoyBallEvent, JoyDownEvent,
    JoyHatEvent, JoyUpEvent, ResizeEvent 
  ]
  clock = Clock.new
  clock.target_framerate = 20

  screen = Screen.new [600,480]
  catch(:rubygame_quit) do
    loop do
      queue.each do |event|
        case event
        when KeyDownEvent
          case event.key
          when K_ESCAPE
            throw :rubygame_quit
          end
        when QuitEvent
          throw :rubygame_quit
        end

        # pass on our events to the GUI
        app.on_event event
      end

      app.update clock.tick
      app.draw screen
    end
  end
end

