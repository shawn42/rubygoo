module Rubygoo
  class Container < Widget
    attr_accessor :widgets, :bg_color, :rect, :queued_widgets

    def initialize(opts={})
      super opts
      @auto_resize = opts[:auto_resize]
      # cannot get this if we don't have an app yet
      @bg_color = theme_property :bg_color if self.app
      @queued_widgets = []
      @widgets = []
      @modal_widgets = []
    end

    # called when we are added to another container
    def added() 
      @bg_color = theme_property :bg_color
      add *@queued_widgets
      @queued_widgets = []
    end

    # Add widget(s) to the container.
    def add(*widgets)
      widgets.uniq.each do |w|
        unless @widgets.include? w
          if self.app
            if w.relative
              w.x += @x
              w.y += @y
              w.update_rect
            end
            w.container = self
            w.parent = self
            w.app = self.app
            if !modal? and w.tab_to? and !w.modal?
              w.app.add_tabbed_widget w 
            end
            w.added

            if @auto_resize
              w.when :resized do |resized_widget|
                resize resized_widget
              end
            end

            @widgets << w
          else
            @queued_widgets << w
          end
        end
      end
      widgets
    end

    # Remove widget(s) to the container.
    def remove(*widgets)
      widgets.uniq.each do |w|
        widget = @widgets.delete(w)
        queued_widget = @queued_widgets.delete(w)
        modal_widget = @modal_widgets.delete(w)
        if widget or queued_widget or modal_widget
          w.removed
        end
      end
    end

    # draw ourself and our children
    def _draw(adapter)
      # any container specific code here (border_colors?)
      if @bg_color
        if app == self
          adapter.fill_screen @bg_color
        else
          x1 = @rect[0]
          y1 = @rect[1]
          x2 = @rect[2] + x1
          y2 = @rect[3] + y1
          adapter.fill x1, y1, x2, y2, @bg_color
        end
      end
      draw adapter unless app == self

      # draw kiddies 
      @widgets.select{|w|w.visible?}.each do |w|
        w._draw adapter
      end
    end

    # called when there is a mouse motion
    def _mouse_motion(event)
      mouse_motion event
      @widgets.select{|w|w.enabled?}.each do |w|
        w._mouse_motion event
      end
    end

    # called when there is a mouse click
    def _mouse_down(event)
      mouse_down event
      @widgets.select{|w|w.enabled? and w.contains? event.data[:x],event.data[:y] }.each do |w|
        w._mouse_down event
      end
    end

    # called when there is a mouse release
    def _mouse_up(event)
      mouse_up event
      @widgets.select{|w| w.contains? event.data[:x],event.data[:y] and w.enabled?}.each do |w|
        w._mouse_up event 
      end
    end

    # called when there is a mouse release after dragging
    def _mouse_drag(event)
      mouse_drag event
      @widgets.select{|w| w.contains? event.data[:x],event.data[:y] and w.enabled?}.each do |w|
        w._mouse_drag event
      end
    end

    # called when there is motion w/ the mouse button down
    def _mouse_dragging(event)
      mouse_dragging event
      @widgets.select{|w| w.contains? event.data[:x],event.data[:y] and w.enabled?}.each do |w|
        w._mouse_dragging event
      end
    end

    # pass on the key press to our widgets
    def _key_pressed(event)
      key_pressed event
      @widgets.select{|w| w.enabled? and w.focussed?}.each do |w|
        w._key_pressed event
      end
    end

    # pass on the key release to our widgets
    def _key_released(event)
      key_released event
      @widgets.select{|w| w.enabled? and w.focussed?}.each do |w|
        w._key_released event 
      end
    end

    # called each update cycle with the amount of time that has passed.  useful
    # for animations, etc
    def _update(time)
      update time unless app == self
      @widgets.select{|w|w.enabled?}.each do |w|
        w._update time
      end
    end

    # does this widget want tabbed focus? Containers don't usually
    def tab_to?
      false
    end

    # called when we need to update our size
    def resize(w)
      # check the rects of all our children?
      max_w = 1
      max_h = 1
      @widgets.each do |w|
        w_width = w.x + w.w
        w_height = w.y + w.h
        max_w = w_width if w_width > max_w
        max_h = w_height if w_height > max_h
      end
      @w = max_w - @x + 2*@x_pad
      @h = max_h - @y + 2*@y_pad
      update_rect
    end
  end
end

