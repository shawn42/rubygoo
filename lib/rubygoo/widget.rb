require 'publisher'
require 'css_colors'
require 'goo_color'
require 'rect'
module Rubygoo
  class Widget
    extend Publisher

    # fire resized whenever a dimensional variable changes
    can_fire :resized, :mouse_enter, :mouse_exit, :focus, :unfocus,
      :key_pressed, :key_released, :mouse_down, :mouse_up, :mouse_drag, 
      :mouse_dragging, :mouse_motion, :enable, :disable, :hide, :show

    attr_accessor :enabled, :parent, :container, :opts,
      :x, :y, :w, :h, :app, :x_pad, :y_pad, :focussed,
      :focus_priority, :relative, :mouse_over, :visible

    DEFAULT_PARAMS = {
      :x => 0,
      :y => 0,
      :w => 1,
      :h => 1,
      :x_pad => 2,
      :y_pad => 2,
      :relative => false,
      :enabled => true,
      :visible => true,
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
      @enabled = merged_opts[:enabled]
      @visible = merged_opts[:visible]

      @opts = merged_opts

      update_rect
    end

    def update_rect()
      @rect = Rect.new [@x,@y,@w,@h]
    end

    def contains?(x, y)
      @rect.collide_point? x, y
    end

    def mouse_over?()
      @mouse_over
    end

    def _mouse_motion(event) #:nodoc:
      if contains?(event.data[:x],event.data[:y])
        unless @mouse_over
          @mouse_over = true
          fire :mouse_enter, event
          mouse_enter event
        end
      else
        if @mouse_over
          @mouse_over = false
          fire :mouse_exit, event
          mouse_exit event
        end
      end
      fire :mouse_motion, event
      mouse_motion event
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
      if prop_key.to_s.match(/color/i) and prop
        get_color prop
      else
        prop
      end
    end

    # converts theme property to a GooColor
    def get_color(color)
      new_color = nil
      if color.is_a? Array
        if color.size > 3
          new_color = color
        else
          # fill in zeros for all other colors
          (3 - color.size).times do
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

    # sets x and fires resized event
    def x=(val)
      @x = val
      update_rect
      fire :resized, self
    end

    # sets y and fires resized event
    def y=(val)
      @y = val
      update_rect
      fire :resized, self
    end

    # sets width and fires resized event
    def w=(val)
      @w = val
      update_rect
      fire :resized, self
    end

    # sets height and fires resized event
    def h=(val)
      @h = val
      update_rect
      fire :resized, self
    end

    # sets x padding and fires resized event
    def x_pad=(val)
      @x_pad = val
      update_rect
      fire :resized, self
    end

    # sets y padding and fires resized event
    def y_pad=(val)
      @y_pad = val
      update_rect
      fire :resized, self
    end

    def enabled?()
      @enabled
    end

    # called when the widget is disabled
    def disable()
      if enabled?
        fire :disable
        @enabled = false
      end
    end

    # called when the widget is enabled
    def enable()
      unless enabled?
        fire :enable
        @enabled = true
      end
    end

    def visible?()
      @visible
    end

    # called when the widget is hidden
    def hide()
      if visible?
        fire :hide
        @visible = false
        disable
      end
    end

    # called when the widget is shown
    def show()
      unless visible?
        fire :show
        @visible = true
        enable
      end
    end

    def _update(time) #:nodoc:
      update time
    end

    def _focus() #:nodoc:
      fire :focus
      @focussed = true
      focus
    end

    def _unfocus() #:nodoc:
      fire :unfocus
      @focussed = false
      unfocus
    end

    def _mouse_down(event) #:nodoc:
      fire :mouse_down, event
      mouse_down event
    end

    def _mouse_dragging(event) #:nodoc:
      fire :mouse_dragging, event
      mouse_dragging event
    end

    def _mouse_up(event) #:nodoc:
      fire :mouse_up, event
      mouse_up event
    end

    def _mouse_down(event) #:nodoc:
      fire :mouse_down, event
      mouse_down event
    end

    def _mouse_drag(event) #:nodoc:
      fire :mouse_drag, event
      mouse_drag event
    end

    def _key_pressed(event) #:nodoc:
      fire :key_pressed, event
      key_pressed event
    end

    def _key_released(event) #:nodoc:
      fire :key_released, event
      key_released event
    end

    def _draw(screen) #:nodoc:
      draw screen
    end

    #
    # STUFF TO OVER RIDE
    #

    # does this widget want tabbed focus? Widget do usually
    def tab_to?()
      true
    end

    def modal?()
      false
    end

    # called when the widget is added to a container
    def added()
    end

    # called when the widget is removed from a container
    def removed()
    end
    
    # called each update cycle with the amount of time that has
    # passed.  useful for animations, etc
    def update(time)
    end

    # called when there is a mouse motion and a button pressed
    def mouse_dragging(event)
    end

    # called when there is a mouse release w/o drag
    def mouse_up(event)
    end

    # called when there is a mouse click
    def mouse_down(event)
    end

    # called when there is a mouse release at the end of a drag
    def mouse_drag(event)
    end

    # called when the mouse first enters a widget
    def mouse_enter(event)
      fire :mouse_enter, event
    end

    # called when the mouse exits a widget
    def mouse_exit(event)
      fire :mouse_exit, event
    end

    # called when there is a mouse motion and no button pressed
    def mouse_motion(event)
    end
    
    # called when a key press is sent to us
    def key_pressed(event)
    end

    # called when a key release is sent to us
    def key_released(event)
    end

    # draw ourself on the screen
    def draw(screen)
    end

    # called when the widget receives focus
    def focus()
    end

    # called when the widget loses focus
    def unfocus()
    end

  end
end
