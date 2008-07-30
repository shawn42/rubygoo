require 'rubygems'
require 'rubygoo'

if $0 == __FILE__
  app = App.new 

  label = Label.new "I am a label", {:x=>20, :y=>30}
  app.add label

  button = Button.new "Click Me!", {:x=>70, :y=>80}
  button.on :clicked do |*opts|
    label.set_text(opts.first.pos.inspect)
  end
  app.add button

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
    JoyHatEvent, JoyUpEvent, ResizeEvent, MouseMotionEvent,
    MouseDownEvent
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
          when K_Q
            throw :rubygame_quit
          end
        when QuitEvent
          throw :rubygame_quit
        end

        app.on_event event
      end

      app.update clock.tick
      app.draw screen
    end
  end
end

