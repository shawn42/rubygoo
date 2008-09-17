require 'rubygems'
$: << './lib'
require 'rubygoo'
require 'rubygame'
include Rubygame

def create_gui(renderer)
  app = App.new :renderer => renderer

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

  modal_button = Button.new "Modal dialogs", :x=>270, :y=>280, :x_pad=>20, :y_pad=>20
  modal_button.on :pressed do |*opts|
    msg = "I AM MODAL"
    # TODO make some of this stuff relative and/or make Dialog's
    # constructor take a layout to use
    modal = Dialog.new :modal => app, :x=>10, :y=>110, :w=>250, :h=>250

    modal.add Label.new("Message Here", :x=>70, :y=>180, :x_pad=>20, :y_pad=>20)
    ok_butt = Button.new("OK", :x=>90, :y=>280, :x_pad=>20, :y_pad=>20)
    ok_butt.on :pressed do |*opts|
      # TODO not sure about this yet
      app.remove(modal)
    end
    modal.add ok_butt

    modal.show
  end

  # implicit tab ordering based on order of addition, can
  # specify if you want on widget creation

  # can add many or one at a time
  app.add text_field, label, button, modal_button
  app.add check

#  pulldown = Pulldown.new {:x=>70, :y=>80}
#  pulldown.on :changed do |*opts|
#    label.set_text(opts.first)
#  end
#
#  app.add pulldown
  app
end

if $0 == __FILE__

  screen = Screen.new [600,480]

  factory = AdapterFactory.new
  render_adapter = factory.renderer_for :rubygame, screen
  app = create_gui(render_adapter)
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
        app_adapter.on_event event
      end

      app_adapter.update clock.tick
      app_adapter.draw render_adapter
    end
  end
end

