module Rubygoo
  class RubygameRenderAdapter

    def initialize(screen)
      @screen = screen
      TTF.setup
    end

    def draw_box(x1,y1,x2,y2,color)
      @screen.draw_box [x1,y1], [x2,y2], convert_color(color)
    end

    def fill_screen(color)
      @screen.draw_box_s [0,0], [@screen.width,@screen.height], convert_color(color)
    end

    def fill(x1,y1,x2,y2,color)
      @screen.draw_box_s [x1,y1], [x2,y2], convert_color(color)
    end

    def convert_color(goo_color)
      [goo_color.r,goo_color.g,goo_color.b,goo_color.a]
    end

    def start_drawing(); end

    def finish_drawing()
      @screen.flip
    end

    def draw_image(img, x, y, color=nil)
      img.blit @screen, [x,y]
    end

    def size_text(text, font_file, font_size)
      @font_cache ||= {}
      @font_cache[font_file] ||= {}
      font = @font_cache[font_file][font_size] ||= TTF.new(font_file, font_size)

      font.size_text text
    end

    def render_text(text, font_file, font_size, color)
      @font_cache ||= {}
      @font_cache[font_file] ||= {}
      font = @font_cache[font_file][font_size] ||= TTF.new(font_file, font_size)

      text_image = font.render text, true, convert_color(color)
    end

  end
end
