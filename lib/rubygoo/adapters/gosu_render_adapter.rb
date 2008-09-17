class GosuRenderAdapter

  def initialize(window)
    @window = window
  end

  def draw_box_filled(x1,y1,x2,y2,color)
    c = convert_color(color)
    @window.draw_quad x1, y1, c, x2, y1, c, x1, y2, c, x2, y2, c
  end

  def draw_box(x1,y1,x2,y2,color)
    c = convert_color(color)
    @window.draw_line x1, y1, c, x2, y1, c
    @window.draw_line x2, y1, c, x2, y2, c
    @window.draw_line x2, y2, c, x1, y2, c
    @window.draw_line x1, y2, c, x1, y1, c
  end

  # fill in a rect with color or full screen if no color
  def fill(color,rect=nil)
    if rect.nil? 
      draw_box_filled 0, 0, @window.width, @window.height, color
    else
      draw_box_filled rect[0], rect[1], rect[2], rect[3], color
    end
  end

  # make static for now for migration ease of rendering fonts
  def convert_color(goo_color)
    Gosu::Color.new goo_color.a,goo_color.r,goo_color.g,goo_color.b
  end

  def start_drawing(); end

  def finish_drawing(); end

  def draw_image(img, x, y)
    # z is unused here
    img.draw x, y, 1
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
    text_image = Image.from_text(@window, text, font_file, font_size, 2, 9999, :left)
  end


end
