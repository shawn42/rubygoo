require 'publisher'
module Rubygoo
  class Label < Widget
    def initialize(text, opts={})
      @font_size = opts[:font_size]
      super opts
      @text = text
    end

    def added()
      font = theme_property :font
      @font_size ||= theme_property :font_size
      @color = theme_property :color
      @bg_color = theme_property :bg_color
      @focus_color = theme_property :focus_color
      @border_color = theme_property :border_color
      @font_file ||= File.join(@app.theme_dir,font)

      set_text @text
    end

    def set_text(text)
      @text = text
      @rendered_text = @app.renderer.render_text @text, @font_file, @font_size, @color
      @rect = Rect.new [@x,@y,@rendered_text.width+@x_pad,@rendered_text.height+@y_pad]
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

      adapter.draw_image @rendered_text, @x, @y, @color
    end

    def tab_to?()
      false
    end
  end
end
