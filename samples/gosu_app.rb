require 'rubygems'
#require 'unprof'
$: << './lib'
$: << File.dirname(__FILE__)
require 'rubygoo'
require 'gosu'
include Gosu
include Rubygoo

require 'create_gui'
class RubygooWindow < Window
  include CreateGui
  def initialize()

    super(640, 480, false)

    # TODO, how can I do this more cleanly?
    %w{a b c d e f g h i j k l m n o p q r s t u v w x y z}.each do |letter|
      eval "::Kb#{letter.upcase} = #{self.char_to_button_id(letter)}"
    end

    # how do I get rid of this?
    require 'gosu_app_adapter'
    factory = AdapterFactory.new
    @render_adapter = factory.renderer_for :gosu, self
    icon = Image.new self, File.dirname(__FILE__) + "/icon.png"
    app = create_gui(@render_adapter,icon)
    @app_adapter = factory.app_for :gosu, app, self
    self.caption = "Gosu Tutorial Game"

  end

  def update
    @app_adapter.update Gosu::milliseconds 
  end

  def draw
    @app_adapter.draw @render_adapter
  end

  # in gosu this captures mouse and keyboard events
  def button_down(id)
    close if id == Gosu::Button::KbEscape
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
