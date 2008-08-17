class CheckBox < Widget
  attr_accessor :checked
  can_fire :checked
  def initialize(opts={})
    super opts
  end

  def added()
    @checked = false
    @color = theme_property :color
    @bg_color = theme_property :bg_color
    @border = theme_property :border
    @focus_color = theme_property :focus_color
    @checked_color = theme_property :checked_color

    @rect = Rect.new [@x-@x_pad,@y-@y_pad,@w+2*@x_pad,@h+2*@y_pad]
  end

  def checked?()
    @checked
  end
  def toggle()
    if checked?
      uncheck
    else
      check
    end
  end
  def check()
    @checked = true
    fire :checked
  end
  def uncheck()
    @checked = false
    fire :checked
  end

  # called when there is a mouse click
  def mouse_up(event)
    toggle
  end

  # called when a key press is sent to us
  def key_pressed(event)
    case event.key
    when K_SPACE
      toggle
    end
  end

  def draw(screen)
    if @focussed
      screen.fill @focus_color, @rect
    elsif @bg_color
      screen.fill @bg_color, @rect
    end

    if @checked
      screen.fill @checked_color, @rect.inflate(-@x_pad,-@y_pad)
    end

    if @border
      x1 = @rect[0]
      y1 = @rect[1]
      x2 = @rect[2] + x1
      y2 = @rect[3] + y1
      screen.draw_box [x1,y1],[x2,y2], @border
    end
  end
end

