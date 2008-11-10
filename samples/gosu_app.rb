require 'rubygems'
$: << './lib'
require 'rubygoo'

require 'gosu'
include Gosu
include Rubygoo

class RubygooWindow < Window
  def initialize()

    super(640, 480, false)

    # TODO, how can I do this cleaner?
    %w{a b c d e f g h i j k l m n o p q r s t u v w x y z}.each do |letter|
      eval "::Kb#{letter.upcase} = #{self.char_to_button_id(letter)}"
    end
    # how do I get rid of this?
    require 'gosu_app_adapter'
    factory = AdapterFactory.new
    @render_adapter = factory.renderer_for :gosu, self
    app = create_gui(@render_adapter)
    @app_adapter = factory.app_for :gosu, app, self
    self.caption = "Gosu Tutorial Game"

  end

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
        app.remove_modal(modal)
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

  def update
    @app_adapter.update Gosu::milliseconds 
  end

  def draw
    # possibly need to set something like GosuRenderer vs
    # RubygameRenderer that each know how to draw a textbox in
    # its own way?
    @app_adapter.draw @render_adapter
  end

  # in gosu this captures mouse and keyboard events
  def button_down(id)
    @app_adapter.button_down id
  end

  def button_up(id)
    @app_adapter.button_up id
  end
end

if $0 == __FILE__

  window = RubygooWindow.new 
  window.show

end
