module Rubygoo
  class TextField < Widget
    SPACE = " "

    def initialize(text, opts={})
      super opts
      @text = text

      @max_length = opts[:max_length]
      @min_length = opts[:min_length]
      @min_length ||= 1

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
      @font_size = theme_property :font_size
      @color = theme_property :color
      @fg_color = theme_property :fg_color
      @bg_color = theme_property :bg_color
      @bg_select_color = theme_property :bg_select_color
      @fg_select_color = theme_property :fg_select_color
      @focus_color = theme_property :focus_color
      @border_color = theme_property :border_color

      @font_file = File.join(@app.theme_dir,font)

      # we have the default from widget, we want to set the
      # default to 6 chars wide and 1 char tall
      # wow, this is REALLY bad, but I think M is the widest char
      size = @app.renderer.size_text "M"*@min_length, @font_file, @font_size
      @min_w = size[0]
      @min_h = size[1]

      if @max_length
      size = @app.renderer.size_text "M"*@max_length, @font_file, @font_size
        @max_w = size[0]
        @max_h = size[1]
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
        @rendered_text = @app.renderer.render_text @text, @font_file, @font_size, @color
        w = [@rendered_text.width,@min_w].max + @x_pad
        h = [@rendered_text.height,@min_h].max + @y_pad
        if @max_length
          w = [w,@max_w].min
          h = [h,@max_h].min
        end
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

    def draw(adapter)
      x1 = @rect[0] - 2
      y1 = @rect[1] - 2
      x2 = @rect[2] + x1 + 4
      y2 = @rect[3] + y1 + 4

      adapter.fill x1, y1, x2, y2, @fg_color
      adapter.fill x1-2, y1-2, x2+2, y2+2, @bg_color
      if @border_color
        adapter.draw_box x1, y1, x2, y2, @border_color
      end
      defaultY = @app.renderer.size_text(@text.slice(0,1),@font_file,@font_size)[1]

      if @focussed
        caretX = @app.renderer.size_text(@text.slice(0,@caret_pos),@font_file,@font_size)[0]
        unless @select_pos.nil?
          # draw selection highlight
          selectX = @app.renderer.size_text(@text.slice(0,@select_pos),@font_file,@font_size)[0]
          selectX0 = [caretX, selectX].min
          selectX1 = [caretX, selectX].max
          if selectX0 < selectX1
            # TODO cache this height
            x = x1+1+selectX0
            y = y1+1
            adapter.fill x, y, x+selectX1-selectX0, y+defaultY, @bg_select_color
          end
        end
      end

      unless @text.nil? or @text.empty?
        @rendered_text = @app.renderer.render_text @text, @font_file, @font_size, @color
        adapter.draw_image @rendered_text, x1+1, y1+1, @color
      end

      # draw caret        
      if @focussed
        x = x1+1+caretX
        y = y1+1
        adapter.fill x, y, x+1, y+defaultY, @fg_select_color
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
        w = @app.renderer.size_text(@text.slice(l,c-l), @font_file, @font_size)[0]
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
      x = event.data[:x]
      y = event.data[:y]

      self.app.focus self

      @caret_pos = find_mouse_position([x,y])
      @select_pos = @caret_pos
      render
    end

    def mouse_dragging(event)
      x = event.data[:x]
      y = event.data[:y]
      @caret_pos = find_mouse_position([x,y])
      render
    end

    def mouse_drag(event)
      x = event.data[:x]
      y = event.data[:y]
      @caret_pos = find_mouse_position([x,y])
      render
    end

    def mouse_up(event)
      x = event.data[:x]
      y = event.data[:y]
      @caret_pos = find_mouse_position([x,y])
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

      mods = event.data[:mods]
      handlers = @key_handlers[event.data[:key]]
      unless handlers.nil?
        for handler in handlers
          handler.call event
        end

        render
        return
      end

      case event.data[:key]
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

      when *KEY2ASCII.keys
        # add regular text to the box
        if @caret_pos == @select_pos
          event_string = event.data[:string]
          unless event_string.nil? or event_string == ""
            @text = @text.slice(0,@caret_pos) + event_string + @text.slice(@caret_pos,@text.length-@caret_pos)
            @caret_pos += 1
          end
        else
          positions = [@caret_pos,@select_pos]
          min = positions.min
          max = positions.max
          @text = @text.slice(0,min) + event.data[:string] + @text.slice(max,@text.length-max)
          @caret_pos = min + 1
        end

        @select_pos = @caret_pos
      end

      render
    end
  end
end
