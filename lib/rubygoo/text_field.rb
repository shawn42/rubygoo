class TextField < Widget
  SPACE = " "

  def initialize(text, opts={})
    super opts
    @text = text

    # TODO make widget respect these?
    @max_length = opts[:max_length]
    @min_length = opts[:min_length]

    @key_handlers = {}
  end

  # Allows for registering callbacks for various key presses.
  # note: this will override default behavior such as K_RIGHT and
  # such 
  # Example:
  # text_field.on_key K_RETURN, K_KP_ENTER do |evt|
  #   puts "BOO-YAH"
  # end
  def on_key(*keys, &block)
    for key in keys
      @key_handlers[key] ||= []
      @key_handlers[key] << block
    end
  end

  def added()
    font = theme_property :font
    font_size = theme_property :font_size
    @color = theme_property :color
    @fg_color = theme_property :fg_color
    @bg_color = theme_property :bg_color
    @bg_select = theme_property :bg_select
    @fg_select = theme_property :fg_select
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

  def render()
    if @text.empty?
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

  def set_text(text)
    if text.nil?
      @text = ""
      @caret_pos = 0
      @select_pos = 0
    else
      @text = text
      @caret_pos = text.length
      @select_pos = @caret_pos
    end

    render

  end

  def draw(screen)
    screen.fill @fg_color, @rect
    screen.fill @bg_color, [@rect[0]+2,@rect[1]+2,@rect[2]-4,@rect[3]-4]
    if @border
      x1 = @rect[0]
      y1 = @rect[1]
      x2 = @rect[2] + x1
      y2 = @rect[3] + y1
      screen.draw_box [x1,y1],[x2,y2], @border
    end
    defaultY = @font.size_text(@text.slice(0,1))[1]
    x,y,w,h = @rect
    if @focussed
      caretX = @font.size_text(@text.slice(0,@caret_pos))[0]
      unless @select_pos.nil?
        # draw selection highlight
        selectX = @font.size_text(@text.slice(0,@select_pos))[0]
        selectX0 = [caretX, selectX].min
        selectX1 = [caretX, selectX].max
        if selectX0 < selectX1
          # TODO cache this height
          screen.fill(@bg_select, [x+1+selectX0, y+1, selectX1-selectX0, defaultY])
        end
      end
    end

    unless @text.nil? or @text.empty?
      @rendered_text = @font.render @text, true, @color
      @rendered_text.blit screen, [x+1,y+1]
    end

    # draw caret        
    if @focussed
      screen.fill(@fg_select, [x+1+caretX, y+1, 1, defaultY])
    end

    # don't really need this??
    return @rect
  end

  def on_unfocus()
    @caret_pos = 0
    @select_pos = 0
  end

  def on_focus()
    @select_pos = @text.length
    @caret_pos = @text.length
  end

  def find_mouse_position(pos)
    # put hit position in window relative coords
    x = pos[0] - @rect[0]
    y = pos[1] - @rect[1]

    # find the horizontal position within the text by binary search
    l,r = 0, @text.length
    c = 0
    while l < r
      c = (l + r + 1) / 2
      w = @font.size_text(@text.slice(l,c-l))[0]
      if x >= w
        l = c
        x -= w
      else
        if r == c
          if x > w / 2
            l = l + 1
          end
          break
        end

        r = c
      end
    end
    return l                
  end

  def mouse_down(event)
    return 0 unless contains? (event.pos)

    #    TODO rework focus and mouse events
    #    getFocus()
    @caret_pos = find_mouse_position(event.pos)
    @select_pos = @caret_pos
    @dragging = true
    render
  end

  def mouse_motion(event)
    return 0 unless @dragging
    @caret_pos = find_mouse_position(event.pos)
    render
  end

  def mouse_up(event)
    if not @dragging
      return 0
    end
    @caret_pos = find_mouse_position(event.pos)
    @dragging = false
    render
  end

  def delete_selected()
    return if @select_pos == @caret_pos
    if @caret_pos > @select_pos
      @caret_pos, @select_pos = @select_pos, @caret_pos
    end

    @text = @text.slice(0, @caret_pos) + 
      @text.slice(@select_pos,@text.length-@select_pos)
    render
    @select_pos = @caret_pos
  end

  def key_pressed(event)
    return if not @focussed
    @dragging = false

    mods = event.mods
    handlers = @key_handlers[event.key]
    unless handlers.nil?
      for handler in handlers
        handler.call event
      end

      render
      return
    end

    case event.key
    when K_LEFT
      if @caret_pos > 0
        @caret_pos -= 1
      end
      if mods.include? K_LCTRL or mods.include? K_RCTRL
        while @caret_pos > 0 and @text.slice(@caret_pos - 1,1) == SPACE
          @caret_pos -= 1
        end
        while @caret_pos > 0 and not @text.slice(@caret_pos - 1,1) == SPACE
          @caret_pos -= 1
        end
      end

      unless mods.include? K_LSHIFT or mods.include? K_RSHIFT
        @select_pos = @caret_pos
      end

    when K_RIGHT
      if @caret_pos < @text.length
        @caret_pos += 1
      end
      if mods.include? K_LCTRL or mods.include? K_RCTRL
        while @caret_pos < @text.length and not @text.slice(@caret_pos,1) == SPACE
          @caret_pos += 1
        end
        while @caret_pos < @text.length and @text.slice(@caret_pos,1) == SPACE
          @caret_pos += 1
        end
      end
      unless mods.include? K_LSHIFT or mods.include? K_RSHIFT
        @select_pos = @caret_pos
      end

    when K_HOME
      @caret_pos = 0
      unless mods.include? K_LSHIFT or mods.include? K_RSHIFT
        @select_pos = @caret_pos
      end

    when K_END
      @caret_pos = @text.length
      unless mods.include? K_LSHIFT or mods.include? K_RSHIFT
        @select_pos = @caret_pos
      end

    when K_BACKSPACE
      if @select_pos != @caret_pos
        delete_selected()
      elsif @caret_pos > 0
        @text = @text.slice(0,@caret_pos-1) + @text.slice(@caret_pos,@text.length-@caret_pos)
        @caret_pos -= 1
        @select_pos = @caret_pos
      end

    when K_DELETE
      if @select_pos != @caret_pos:
        delete_selected()
      elsif @caret_pos < @text.length:
        @text = @text.slice(0,@caret_pos) + @text.slice(@caret_pos+1,@text.length-@caret_pos-1)
        @select_pos = @caret_pos
      end

    when (32..127)
      # add regular text to the box
      if @caret_pos == @select_pos
        @text = @text.slice(0,@caret_pos) + event.string + @text.slice(@caret_pos,@text.length-@caret_pos)
        @caret_pos += 1
      else
        positions = [@caret_pos,@select_pos]
        min = positions.min
        max = positions.max
        @text = @text.slice(0,min) + event.string + @text.slice(max,@text.length-max)
        @caret_pos = min + 1
      end

      @select_pos = @caret_pos
    end

    render
  end
end
