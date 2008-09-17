class RubygameRenderAdapter

  def initialize(screen)
    @screen = screen
    TTF.setup
  end

  def draw_box(x1,y1,x2,y2,color)
    @screen.draw_box [x1,y1], [x2,y2], convert_color(color)
  end

  # fill in a rect with color or full screen if no color
  def fill(color,rect=nil)
    if rect.nil? 
      @screen.fill convert_color(color)
    else
      @screen.fill convert_color(color), rect
    end
  end

  def convert_color(goo_color)
    [goo_color.r,goo_color.g,goo_color.b,goo_color.a]
  end

  def start_drawing(); end

  def finish_drawing()
    @screen.flip
  end

  def draw_image(img, x, y)
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
