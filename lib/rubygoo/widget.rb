require 'publisher'
require 'css_colors'
require 'goo_color'
require 'rect'
module Rubygoo
  class Widget
    extend Publisher

    # fire resized whenever a dimensional variable changes
    can_fire :clicked, :resized

    attr_accessor :enabled, :parent, :container, 
      :x, :y, :w, :h, :app, :x_pad, :y_pad, :focussed,
      :focus_priority, :relative

    DEFAULT_PARAMS = {
      :x => 0,
      :y => 0,
      :w => 1,
      :h => 1,
      :x_pad => 2,
      :y_pad => 2,
      :relative => false,
    }
    def initialize(opts={})
      merged_opts = DEFAULT_PARAMS.merge opts
      @x = merged_opts[:x]
      @y = merged_opts[:y]
      @x_pad = merged_opts[:x_pad]
      @y_pad = merged_opts[:y_pad]
      @w = merged_opts[:w]
      @h = merged_opts[:h]
      @relative = merged_opts[:relative]
      update_rect
    end

    def update_rect()
      @rect = Rect.new [@x,@y,@w,@h]
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
    def mouse_down(event)
    end

    # called when there is a mouse motion and no button pressed
    def mouse_motion(event)
    end
    #
    # called when there is a mouse motion and a button pressed
    def mouse_dragging(event)
    end

    # called when there is a mouse release w/o drag
    def mouse_up(event)
    end

    # called when there is a mouse release at the end of a drag
    def mouse_drag(event)
    end

    # called when a key press is sent to us
    def key_pressed(event)
    end

    # called when a key release is sent to us
    def key_released(event)
    end

    # called when the widget receives focus
    def on_focus()
    end

    def focus()
      @focussed = true
      on_focus
    end

    # called when the widget loses focus
    def on_unfocus()
    end

    def unfocus()
      @focussed = false
      on_unfocus
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
            return nil if class_prop == :none
            prop = class_prop
            break
          end
        end
        parent = parent.superclass
      end
      if prop_key.to_s.match /color/i
        get_color prop
      else
        prop
      end
    end

    def get_color(color)
      new_color = nil
      if color.is_a? Array
        if color.size > 3
          new_color = color
        else
          # fill in zeros for all other colors
          3-color.size.times do
            color << 0
          end
          # fill in alpha as 255
          color << 255
        end
      elsif color.is_a? Symbol
        new_color = CSS_COLORS[color]
      else
        raise "invalid color"
      end

      GooColor.new *new_color 
    end

    # does this widget want tabbed focus? Widget do usually
    def tab_to?()
      true
    end

    def modal?()
      false
    end
    
    # called each update cycle with the amount of time that has
    # passed.  useful for animations, etc
    def update(time)
    end

    def x=(val)
      @x = val
      fire :resized, self
    end
    def y=(val)
      @y = val
      fire :resized, self
    end
    def w=(val)
      @w = val
      fire :resized, self
    end
    def h=(val)
      @h = val
      fire :resized, self
    end
    def x_pad=(val)
      @x_pad = val
      fire :resized, self
    end
    def y_pad=(val)
      @y_pad = val
      fire :resized, self
    end
  end
end
