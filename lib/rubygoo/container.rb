module Rubygoo
  class Container < Widget

    attr_accessor :widgets, :bg_color, :rect

    def initialize(opts={})
      super opts
      # cannot get this if we don't have an app yet
      @bg_color = theme_property :bg_color if self.app
      @queued_widgets = []
      @widgets = []
      @modal_widgets = []
    end

    # called when we are added to another container
    def added() 
      add *@queued_widgets
      @queued_widgets = []
    end

    def add_modal(widget)
      @modal_widgets << widget
      add widget
    end

    # Add widget(s) to the container.
    def add(*widgets)
      widgets.uniq.each do |w|
        unless @widgets.include? w
          if self.app
            w.container = self
            w.parent = self
            w.app = self.app
            w.app.add_tabbed_widget w
            w.added
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
    def draw(screen)
      # any container specific code here (border_colors?)
      if @bg_color
        if app == self
          screen.fill @bg_color
        else
          screen.fill @bg_color, @rect
        end
      end

      # draw kiddies 
      @widgets.each do |w|
        w.draw screen
      end
    end

    # called when there is a mouse motion
    def mouse_motion(event)
      @widgets.each do |w|
        w.mouse_motion event #if w.contains? [event.data[:x],event.data[:y]] 
      end
    end

    # called when there is a mouse click
    def mouse_down(event)
      @widgets.each do |w|
        w.mouse_down event if w.contains? [event.data[:x],event.data[:y]] 
      end
    end

    # called when there is a mouse release
    def mouse_up(event)
      @widgets.each do |w|
        w.mouse_up event if w.contains? [event.data[:x],event.data[:y]] 
      end
    end

    # pass on the key press to our widgets
    def key_pressed(event)
      @widgets.each do |w|
        w.key_pressed event if w.focussed?
      end
    end

    # pass on the key release to our widgets
    def key_released(event)
      @widgets.each do |w|
        w.key_released event if w.focussed?
      end
    end

    # distribute our mouse events to our modals first
    def modal_mouse_call(meth, event)
      if @modal_widgets.empty?
        @widgets.each do |w|
          w.send meth, event if w.contains? [event.data[:x],event.data[:y]] 
        end
      else
        @modal_widgets.last.send meth, event
      end
    end

    # distribute our keyboard events to our modals first
    def modal_keyboard_call(meth, event)
      if @modal_widgets.empty?
        @widgets.each do |w|
          w.send meth, event if w.focussed?
        end
      else
        @modal_widgets.last.send meth, event
      end
    end
  end
end

