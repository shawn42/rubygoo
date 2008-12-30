module Rubygoo
  class Button < Widget
    can_fire :pressed

    goo_prop :icon_image, :image, :hover_image

    def initialize(new_text, opts={})
      @icon_image = opts[:icon]
      @image = opts[:image]
      @hover_image = opts[:hover_image]
      @text = new_text

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
      @rendered_text ||= @app.renderer.render_text @text, @font_file, @font_size, @color if @text and !@text.empty?

      if @image
        @w = @image.width+2*@padding_left
        @h = @image.height+2*@padding_top
        @x = @x - @padding_left
        @y = @y - @padding_top
      else
        @w = @rendered_text.width+2*@padding_left
        @h = @rendered_text.height+2*@padding_top
        @x = @x - @padding_left
        @y = @y - @padding_top
      end

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
      
      img = @image.nil? ? @rendered_text : @image
      if @image
        adapter.draw_image @image, @x+@padding_left, @y+@padding_top, @color
      else

        if @focussed
          adapter.fill x1, y1, x2, y2, @focus_color
        elsif @bg_color
          adapter.fill x1, y1, x2, y2, @bg_color
        end
        if @border_color
          adapter.draw_box x1, y1, x2, y2, @border_color
        end

        if @disabled_color and !enabled?
          adapter.fill x1, y1, x2, y2, @disabled_color
        end

        if @icon_image
          # TODO center icon
          ix = x1#+((x2-x1)-@icon.w)
          iy = y1#+((y2-y1)-@icon.h)
          adapter.draw_image @icon_image, ix+@padding_left,iy+@padding_top
        end

        adapter.draw_image @rendered_text, @x+@padding_left, @y+@padding_top, @color
      end

      if mouse_over? and (@hover_image or @hover_color)
        if @hover_image
          adapter.draw_image @hover_image, @x+@padding_left, @y+@padding_top, @color
        else
          adapter.fill x1, y1, x2, y2, @hover_color
        end
      end

    end
  end
end

