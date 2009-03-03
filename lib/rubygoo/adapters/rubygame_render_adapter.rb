require 'clipper'
module Rubygoo
  class RubygameRenderAdapter
    attr_reader :clipper

    def initialize(screen)
      @screen = screen
      TTF.setup
    end

    def width()
      @screen.width
    end

    def height()
      @screen.height
    end

    def draw_box(x1,y1,x2,y2,color)
      @screen.draw_box [@clipper.tx+x1,@clipper.ty+y1], [@clipper.tx+x2,@clipper.ty+y2], convert_color(color)
    end

    def draw_line(x1,y1,x2,y2,color)
      c = convert_color(color)
      @screen.draw_line_a [@clipper.tx+x1, @clipper.ty+y1], [@clipper.tx+x2, @clipper.ty+y2], c
    end

    def draw_circle(cx,cy,radius,color)
      @screen.draw_circle_a [@clipper.tx+cx,@clipper.ty+cy],radius,convert_color(color)
    end

    def draw_circle_filled(cx,cy,radius,color)
      @screen.draw_circle_s [@clipper.tx+cx,@clipper.ty+cy],radius,convert_color(color)
    end

    def fill_screen(color)
      @screen.draw_box_s [0,0], [width,height], convert_color(color)
    end

    def fill(x1,y1,x2,y2,color)
      @screen.draw_box_s [@clipper.tx+x1,@clipper.ty+y1], [@clipper.tx+x2,@clipper.ty+y2], convert_color(color)
    end

    def convert_color(goo_color)
      [goo_color.r,goo_color.g,goo_color.b,goo_color.a]
    end

    def start_drawing()
      @clipper = Clipper.new :w => width, 
        :h => height
      @screen.clip = @clipper
    end

    def finish_drawing()
      @screen.flip
    end

    def draw_image(img, to_x, to_y, color=nil)
      img.blit @screen, [@clipper.tx+to_x,@clipper.ty+to_y]
    end

    def draw_partial_image(img, to_x, to_y,
                   from_x=nil,from_y=nil,from_w=nil,from_h=nil, color=nil)
      if from_x
        if from_w
          from = [@clipper.tx+from_x,@clipper.ty+from_y,from_w,from_h]
        else
          from = [@clipper.tx+from_x,@clipper.ty+from_y]
        end
        img.blit @screen, [@clipper.tx+to_x,@clipper.ty+to_y], from
      else
        img.blit @screen, [@clipper.tx+to_x,@clipper.ty+to_y]
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

    def apply_clip(clip)
      delta_clip = @clipper.apply_clip clip
      @screen.clip = @clipper
      delta_clip
    end

    def remove_clip(clip)
      @clipper.remove_clip clip
      @screen.clip = @clipper
    end

    def apply_trans(trans)
      delta_trans = @clipper.apply_trans trans
      @screen.clip = @clipper
      delta_trans
    end

    def remove_trans(trans)
      @clipper.remove_trans trans
      @screen.clip = @clipper
    end

  end
end
