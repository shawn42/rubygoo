require 'gosu'
include Gosu
class GosuRenderer

  def build_font(font_file,font_size)
    @font_cache ||= {}
    @font_cache[font_file] ||= {}
    font = @font_cache[font_file][font_size]
    return font if font
    @font_cache[font_file][font_size] = Font.new(font_file, font_size)
  end

  def build_color(rgba_array)
    # do we need to dup here?
    c = rgba_array.dup
    c = c.unshift(c.pop)
    Color.new *c
  end

  def draw_container(conontainer, screen)
  end

  def flip(screen)
  end

  def draw_button(button, screen)
#    if button.focussed
#      screen.fill button.focus_color, button.rect
#    elsif button.bg_color
#      screen.fill button.bg_color, button.rect
#    end
    if button.border_color
      x1 = button.rect[0]
      y1 = button.rect[1]
      x2 = button.rect[2] + x1
      y2 = button.rect[3] + y1
      c = button.border_color
      
#      screen.draw_box [x1,y1],[x2,y2], button.border_color
      # TODO create colors using the renderer
      screen.draw_quad(x1, y1, c, x2, y1, c, x1, y2, c, x2, y2, c)
    end

      # TODO create rendered text using the renderer
#    button.rendered_text.blit screen, [button.x,button.y]
  end
end
