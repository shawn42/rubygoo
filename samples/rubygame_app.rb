require 'rubygems'
#require 'unprof'
$: << './lib'
$: << File.dirname(__FILE__)
require 'rubygoo'
require 'rubygame'
#require 'create_gui_pretty'
require 'create_gui'
include Rubygame
include Rubygoo
include CreateGui

if $0 == __FILE__

  screen = Screen.new [600,480]
  screen.show_cursor = false

  factory = AdapterFactory.new
  render_adapter = factory.renderer_for :rubygame, screen
  icon = Surface.load File.dirname(__FILE__) + "/icon.png"
  app = create_gui(render_adapter,icon)
  app_adapter = factory.app_for :rubygame, app
  
  # rubygame standard stuff below here
  queue = EventQueue.new
  queue.ignore = [
    ActiveEvent, JoyAxisEvent, JoyBallEvent, JoyDownEvent,
    JoyHatEvent, JoyUpEvent, ResizeEvent 
  ]
  clock = Clock.new
  clock.target_framerate = 20

  catch(:rubygame_quit) do
    tick = 0
    loop do
      clean = true

      queue.each do |event|
        clean = false
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
        app_adapter.on_event event
      end
      tick += clock.tick

      unless clean
        app_adapter.update tick
        app_adapter.draw render_adapter
        tick = 0
      end
    end
  end
end

