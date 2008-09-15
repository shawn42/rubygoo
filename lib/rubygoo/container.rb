class Container < Widget

  attr_accessor :widgets

  def initialize(opts={})
    super opts
    # cannot get this if we don't have an app yet
    @bg_color = theme_property :bg_color if self.app
    @queued_widgets = []
    @widgets = []
  end

  # called when we are added to another container
  def added() 
    add *@queued_widgets
    @queued_widgets = []
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
      if widget
        widget.removed
      else
        widget = @queued_widgets.delete(w)
        widget.removed if widget
      end
    end
  end

  # draw ourself and our children
  def draw(screen)
    # any container specific code here (borders?)
    if self.app == self
      screen.fill @bg_color
    else
      screen.fill @bg_color, @rect
    end

    # draw kiddies 
    @widgets.each do |w|
      w.draw screen
    end
  end

  # called when there is a mouse motion
  def mouse_motion(event)
    @widgets.each do |w|
      w.mouse_motion event if w.contains? event.pos 
    end
  end

  # called when there is a mouse click
  def mouse_down(event)
    @widgets.each do |w|
      w.mouse_down event if w.contains? event.pos 
    end
  end

  # called when there is a mouse release
  def mouse_up(event)
    @widgets.each do |w|
      w.mouse_up event if w.contains? event.pos 
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

end

