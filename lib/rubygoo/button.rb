class Button < Widget
  attr_accessor :text
  can_fire :pressed
  def initialize(text, opts={})
    super opts
    @text = text
  end

  def added()
    font = theme_property :font
    font_size = theme_property :font_size
    @color = theme_property :color
    @bg_color = theme_property :bg_color
    @border_color = theme_property :border_color
    @font = TTF.new(File.join(@app.theme_dir,font), font_size)
    @focus_color = theme_property :focus_color

    @rendered_text = @font.render @text, true, @color

    @rect = Rect.new [@x-@x_pad,@y-@y_pad,@rendered_text.width+2*@x_pad,@rendered_text.height+2*@y_pad]
  end

  # called when there is a mouse click
  def mouse_up(event)
    fire :pressed, event
  end

  # called when a key press is sent to us
  def key_pressed(event)
    case event.key
    when K_SPACE
      fire :pressed, event
    end
  end

  def draw(screen)
    if @focussed
      screen.fill @focus_color, @rect
    elsif @bg_color
      screen.fill @bg_color, @rect
    end
    if @border_color
      x1 = @rect[0]
      y1 = @rect[1]
      x2 = @rect[2] + x1
      y2 = @rect[3] + y1
      screen.draw_box [x1,y1],[x2,y2], @border_color
    end

    @rendered_text.blit screen, [@x,@y]
  end
end

