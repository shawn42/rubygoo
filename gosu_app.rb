require 'rubygems'
$: << './lib'
require 'rubygoo'

if $0 == __FILE__
  app = App.new :renderer => 'gosu'

#  label = Label.new "click the button to set the time", :x=>20, :y=>30

  button = Button.new "Click Me!", :x=>70, :y=>80, :x_pad=>20, :y_pad=>20
  button.on :pressed do |*opts|
#    label.set_text(Time.now.to_s)
    puts "button clicked"
  end

#  check = CheckBox.new :x=>370, :y=>70, :w=>20, :h=>20
#  check.on :checked do
#    label.set_text("CHECKED [#{check.checked?}]")
#  end
#
#  text_field = TextField.new "initial text", :x => 70, :y => 170
#
#  text_field.on_key K_RETURN, K_KP_ENTER do |evt|
#    puts "BOO-YAH"
#  end
#
#  modal_button = Button.new "Modal dialogs", :x=>270, :y=>280, :x_pad=>20, :y_pad=>20
#  modal_button.on :pressed do |*opts|
#    msg = "I AM MODAL"
#
#    # TODO make some of this stuff relative and/or make Dialog's
#    # constructor take a layout to use
#    modal = Dialog.new :modal => true, :x=>10, :y=>70, :w=>250, :h=>350
#
#    modal.add Label.new("Message Here", :x=>90, :y=>280, :x_pad=>20, :y_pad=>20)
#    ok_butt = Button.new("OK", :x=>70, :y=>280, :x_pad=>20, :y_pad=>20)
#    ok_butt.on :pressed do |*opts|
#      # TODO not sure about this yet
#      app.remove(modal)
#    end
#    modal.add ok_butt
#
#    # modal to the whole app, could just be for a particular
#    # container
#    #    modal.do_modal app, msg do |d|
#    # optional block
#    #      puts "modal dialog finished, do your saving/updating now"
#    #    end
#    app.add modal
#  end

  # implicit tab ordering based on order of addition, can
  # specify if you want on widget creation

  # can add many or one at a time
#  app.add text_field, label, button, modal_button
#  app.add check
  app.add button

  #  pulldown = Pulldown.new {:x=>70, :y=>80}
  #  pulldown.on :changed do |*opts|
  #    label.set_text(opts.first)
  #  end
  #
  #  app.add pulldown


  require 'gosu'
  require 'rubygame'
  include Gosu
  include Rubygame
  class GosuEventConverter
    KEYS_TO_RUBYGAME = {
      Button::KbEscape => K_ESCAPE,
      Button::KbTab => K_TAB,
      Button::KbSpace => K_SPACE

    }
    def convert(event)


    end
  end

  class GameWindow < Window
    attr_accessor :app
    def initialize(app)
      @app = app
      super(640, 480, false)
      self.caption = "Gosu Tutorial Game"
    end

    def update
      app.update Gosu::milliseconds 
    end

    def draw
      # possibly need to set something like GosuRenderer vs
      # RubygameRenderer that each know how to draw a textbox in
      # its own way?
      app.draw self
    end

    # in gosu this captures mouse and keyboard events
    def button_down(id)
      event = nil
      case id
      when MsLeft
        event = MouseDownEvent.new [mouse_x,mouse_y], MOUSE_LEFT
      when Button::KbEscape
        close
      else
      end
      app.on_event event if event
    end

    def button_up(id)
    end
  end

  window = GameWindow.new app
  window.show

end
