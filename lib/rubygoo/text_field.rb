class TextField < Widget
  # a-z
  ABCS = (97..123)

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
    if text.nil? or text.empty?
      @rendered_text = Surface.new [@x_pad, @y_pad]
      @rect = Rect.new [@x,@y,@x_pad,@y_pad]
    else
      @rendered_text = @font.render @text, true, @color
      @rect = Rect.new [@x,@y,@rendered_text.width+@x_pad,@rendered_text.height+@y_pad]
    end
  end

  def undraw(screen)
    # not sure about this yet
    @old_background.blit screen, [@x,@y]
  end

  def key_released(event)
    case event.key
    when K_LSHIFT
      @upcasing = false
    when K_RSHIFT
      @upcasing = false
    end
  end

  def key_pressed(event)
    # TODO, use a carrot position
    case event.key
    when K_BACKSPACE
      set_text(@text.slice(0,@text.length-1))
    when K_RSHIFT
      @upcasing = true
    when K_LSHIFT
      @upcasing = true
    else
      # TODO how do I get shifted values? like !@#$%^&*()
      key = event.key
      key -= 32 if @upcasing and ABCS.include? key
      set_text("#{@text}#{key.chr}")
    end
  end

  def draw(screen)
    # TODO seperate the background box from the text
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
