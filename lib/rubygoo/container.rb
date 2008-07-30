class Container < Widget

  attr_accessor :widgets

  def initialize(opts={})
    super opts
    @bg_color = theme_property :bg_color
    @widgets = []
  end

  # Add widget(s) to the container.
  def add(*widgets)
    widgets.uniq.each do |w|
      unless @widgets.include? w
        w.container = self
        w.parent = self
        w.app = self.app
        w.app.add_tabbed_widget w
        w.added
        @widgets << w
      end
    end
    widgets
  end

  # Remove widget(s) to the container.
  def remove(*widgets)
    widgets.uniq.each do |w|
      @widgets.delete(w).removed
    end
  end

  # draw ourself and our children
  def draw(screen)
    # any container specific code here (borders?)
    screen.fill @bg_color

    # draw kiddies 
    @widgets.each do |w|
      w.draw screen
    end
  end

  # called when there is a mouse click
  def clicked(event)
    @widgets.each do |w|
      w.clicked event if w.contains? event.pos 
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

