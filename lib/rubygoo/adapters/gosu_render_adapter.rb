module Rubygoo
  class DelayedText
    def initialize(font, text)
      @font, @text = font, text
    end
    def draw(x, y, z, r, g, b); @font.draw(@text, x, y, z); end; 
    def width()
      @width ||= @font.text_width(@text).ceil
    end
    def height()
      @height ||= @font.height
    end
  end

  class GosuRenderAdapter

    def initialize(window)
      @window = window
    end

    def draw_box(x1,y1,x2,y2,color)
      c = convert_color(color)
      @window.draw_line x1, y1, c, x2, y1, c
      @window.draw_line x2, y1, c, x2, y2, c
      @window.draw_line x2, y2, c, x1, y2, c
      @window.draw_line x1, y2, c, x1, y1, c
    end

    def fill_screen(color)
      c = convert_color(color)
      @window.draw_quad 0, 0, c, @window.width, 0, c, 0, @window.height, c, @window.width, @window.height, c
    end

    def fill(x1,y1,x2,y2,color)
      c = convert_color(color)
      @window.draw_quad x1, y1, c, x2, y1, c, x1, y2, c, x2, y2, c
    end

    def convert_color(goo_color)
      Gosu::Color.new goo_color.a,goo_color.r,goo_color.g,goo_color.b
    end

    def start_drawing(); end

    def finish_drawing(); end

    def draw_image(img, x, y, color=nil)
      # z is unused here
      if color
        img.draw x, y, 0,1,1,convert_color(color)
      else
        img.draw x, y, 0
      end
    end

    def size_text(text, font_file, font_size)
      @font_cache ||= {}
      @font_cache[font_file] ||= {}
      font = @font_cache[font_file][font_size] ||= Font.new(@window, font_file, font_size)

      return [font.text_width(text),font.height]
    end

    def render_text(text, font_file, font_size, color)
      @font_cache ||= {}
      @font_cache[font_file] ||= {}
      font = @font_cache[font_file][font_size] ||= Font.new(@window, font_file, font_size)

      # TODO how do you set the color here?
#      text_image = Image.from_text(@window, text, font_file, font_size, 2, font.text_width(text).ceil, :left)
      DelayedText.new font, text
#      text_image = font.draw(text, 0, 0, 1)
    end

  end
end
