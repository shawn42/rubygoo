class TextField < Widget
  # a-z
  ABCS = (97..123)
  ACCEPTABLE_KEYS = [
    K_SPACE
  ]

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
    
    if @w == 1
      # we have the default from widget, we want to set the
      # default to 6 chars wide and 1 char tall
      size_text = @font.render "MMMMMM", true, @color
      @min_w,@min_h = size_text.size
    end

    set_text @text
  end

  def set_text(text)
    @text = text
    if text.nil? or text.empty?
      w = [@w,@min_w].max + @x_pad
      h = [@h,@min_h].max + @y_pad
      @rendered_text = nil
      @rect = Rect.new [@x,@y,w,h]
    else
      @rendered_text = @font.render @text, true, @color
      w = [@rendered_text.width,@min_w].max + @x_pad
      h = [@rendered_text.height,@min_h].max + @y_pad
      @rect = Rect.new [@x,@y,w,h]
    end
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
      abc = ABCS.include? key
      if abc or ACCEPTABLE_KEYS.include? key
        key -= 32 if @upcasing and abc
        set_text("#{@text}#{key.chr}")
      end
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

    @rendered_text.blit screen, [@x,@y] if @rendered_text
  end
end
