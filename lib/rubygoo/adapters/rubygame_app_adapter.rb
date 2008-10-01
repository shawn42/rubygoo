require 'rubygame'
include Rubygame
include Mouse
include Key

module Rubygoo

  class RubygameAppAdapter

    def initialize(app)
      @app = app
    end

    def update(time)
      @app.update time
    end

    def draw(target)
      @app.draw target
    end

    # TODO convert keys?!?
    def on_event(event)
      case event
      when KeyUpEvent
        @app.on_event GooEvent.new(:key_released, { 
          :key => event.key, :mods => event.mods, :string => event.string})
      when KeyDownEvent
        @app.on_event GooEvent.new(:key_pressed, { 
          :key => event.key, :mods => event.mods, :string => event.string})
      when MouseUpEvent
        @app.on_event GooEvent.new(:mouse_up, { 
          :x => event.pos[0], :y => event.pos[1], :button => event.button})
      when MouseDownEvent
        @app.on_event GooEvent.new(:mouse_down, { 
          :x => event.pos[0], :y => event.pos[1], :button => event.button})
      when MouseMotionEvent
        @app.on_event GooEvent.new(:mouse_motion, { 
          :x => event.pos[0], :y => event.pos[1]})
      end
    end
  end

end
