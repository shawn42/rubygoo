require 'publisher'
class Widget
  extend Publisher
  can_fire :clicked
  attr_accessor :enabled, :parent, :container, 
    :x, :y, :w, :h, :app, :x_pad, :y_pad, :focussed,
    :focus_priority

  DEFAULT_PARAMS = {
    :x => 0,
    :y => 0,
    :w => 1,
    :h => 1,
    :x_pad => 2,
    :y_pad => 2,
  }
  def initialize(opts={})
    merged_opts = DEFAULT_PARAMS.merge opts
    @x = merged_opts[:x]
    @y = merged_opts[:y]
    @x_pad = merged_opts[:x_pad]
    @y_pad = merged_opts[:y_pad]
    @w = merged_opts[:w]
    @h = merged_opts[:h]
    update_rect
  end

  def update_rect()
    @rect = Rect.new [@x,@y,@w+@x_pad,@h+@y_pad]
  end

  # called when the widget is added to a container
  def added()
  end

  # called when the widget is removed from a container
  def removed()
  end

  def contains?(pos)
    @rect.collide_point? pos[0], pos[1]
  end

  def enabled?()
    @enabled
  end

  def update(millis)
  end

  # draw ourself on the screen
  def draw(screen)
  end

  # called when there is a mouse click
  def clicked(event)
  end

  # called when a key press is sent to us
  def key_pressed(event)
  end

  def focus()
    @focussed = true
  end

  def unfocus()
    @focussed = false
  end
  
  def focussed?()
    @focussed
  end

  # gets the property for the class asking for it.
  # it will walk up the object hierarchy if needed
  def theme_property(prop_key)
    prop = nil
    parent = self.class
    until parent == Object
      class_theme = app.theme[parent.to_s]
      if class_theme
        class_prop = class_theme[prop_key]
        if class_prop
          prop = class_prop
          break
        end
      end
      parent = parent.superclass
    end
    prop
  end

end

