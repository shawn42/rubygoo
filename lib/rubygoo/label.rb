class Label < Widget
  attr_accessor :text
  def initialize(text, opts={})
    super opts
    @text = text
  end

  def added()
    font = theme_property :font
    font_size = theme_property :font_size
    @color = theme_property :color
    @bg_color = theme_property :bg_color
    @focus_color = theme_property :focus_color
    @border = theme_property :border

    @font = TTF.new(File.join(@app.theme_dir,font), font_size)
    set_text @text
  end

  def set_text(text)
    @text = text
    @rendered_text = @font.render @text, true, @color
    @rect = Rect.new [@x,@y,@rendered_text.width+@x_pad,@rendered_text.height+@y_pad]
  end

  def undraw(screen)
    # not sure about this yet
    @old_background.blit screen, [@x,@y]
  end

  def draw(screen)
    if @focussed
      screen.fill @focus_color, @rect
    elsif @bg_color
      screen.fill @bg_color, @rect
    end

    if @border
      x1 = @rect[0]
      y1 = @rect[1]
      x2 = @rect[2] + x1
      y2 = @rect[3] + y1
      screen.draw_box [x1,y1],[x2,y2], @border
    end

    @rendered_text.blit screen, [@x,@y]
  end
end
