module Rubygoo
  class Button < Widget
    can_fire :pressed
    def initialize(text, opts={})
      @icon = opts[:icon]
      @text = text

      super opts
    end

    def added()
      font = theme_property :font
      @font_size = @opts[:font_size]
      @font_size ||= theme_property :font_size 
      @color = theme_property :color
      @bg_color = theme_property :bg_color
      @border_color = theme_property :border_color
      @focus_color = theme_property :focus_color
      @hover_color = theme_property :hover_color
      @disabled_color = theme_property :disabled_color

      @font_file = File.join(@app.theme_dir,font)
      @rendered_text ||= @app.renderer.render_text @text, @font_file, @font_size, @color

      @w = @rendered_text.width+2*@x_pad
      @h = @rendered_text.height+2*@y_pad
      @x = @x - @x_pad
      @y = @y - @y_pad

      update_rect
    end

    # called when there is a mouse click
    def mouse_up(event)
      fire :pressed, event
    end

    # called when there is a mouse click at the end of a drag
    def mouse_drag(event)
      fire :pressed, event
    end

    # called when a key press is sent to us
    def key_pressed(event)
      case event.data[:key]
      when K_SPACE
        fire :pressed, event
      end
    end

    def draw(adapter)
      x1 = @rect[0]
      y1 = @rect[1]
      x2 = @rect[2] + x1
      y2 = @rect[3] + y1
      

      if @focussed
        adapter.fill x1, y1, x2, y2, @focus_color
      elsif @bg_color
        adapter.fill x1, y1, x2, y2, @bg_color
      end
      if @border_color
        adapter.draw_box x1, y1, x2, y2, @border_color
      end

      if mouse_over? and @hover_color
        adapter.fill x1, y1, x2, y2, @hover_color
      end

      if @disabled_color and !enabled?
        adapter.fill x1, y1, x2, y2, @disabled_color
      end

      if @icon
        # TODO center icon
        ix = x1#+((x2-x1)-@icon.w)
        iy = y1#+((y2-y1)-@icon.h)
        adapter.draw_image @icon, ix+@x_pad,iy+@y_pad
      end

      adapter.draw_image @rendered_text, @x+@x_pad, @y+@y_pad, @color
    end

    #DSL methods
    def icon_image(new_val=nil)
      @icon = new_val if new_val
      @icon
    end
  end
end

