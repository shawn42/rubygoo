module Rubygoo
  class RubygameRenderAdapter

    def initialize(screen)
      @screen = screen
      TTF.setup
    end

    def draw_box(x1,y1,x2,y2,color)
      @screen.draw_box [x1,y1], [x2,y2], convert_color(color)
    end

    def draw_line(x1,y1,x2,y2,color)
      c = convert_color(color)
      @screen.draw_line_a [x1, y1], [x2, y2], c
    end

    def draw_circle(cx,cy,radius,color)
      @screen.draw_circle_a [cx,cy],radius,convert_color(color)
    end

    def draw_circle_filled(cx,cy,radius,color)
      @screen.draw_circle_s [cx,cy],radius,convert_color(color)
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

    def draw_image(img, to_x, to_y, color=nil)
      img.blit @screen, [to_x,to_y]
    end

    def draw_partial_image(img, to_x, to_y,
                   from_x=nil,from_y=nil,from_w=nil,from_h=nil, color=nil)
      if from_x
        if from_w
          from = [from_x,from_y,from_w,from_h]
        else
          from = [from_x,from_y]
        end
        img.blit @screen, [to_x,to_y], from
      else
        img.blit @screen, [to_x,to_y]
      end
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
