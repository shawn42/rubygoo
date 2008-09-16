class RubygameRenderer

  def build_font(font_file,font_size)
    @font_cache ||= {}
    @font_cache[font_file] ||= {}
    font = @font_cache[font_file][font_size]
    return font if font
    @font_cache[font_file][font_size] = TTF.new(font_file, font_size)
  end

  def build_color(rgba_array)
    rgba_array
  end

  def draw_container(container, screen)
    if container.rect.nil? or container.is_a? App
      screen.fill container.bg_color
    else
      screen.fill container.bg_color, container.rect
    end
  end

  def flip(screen)
    screen.update
  end

  def draw_button(button, screen)
    if button.focussed
      screen.fill button.focus_color, button.rect
    elsif button.bg_color
      screen.fill button.bg_color, button.rect
    end
    if button.border_color
      x1 = button.rect[0]
      y1 = button.rect[1]
      x2 = button.rect[2] + x1
      y2 = button.rect[3] + y1
      screen.draw_box [x1,y1],[x2,y2], button.border_color
    end

    button.rendered_text.blit screen, [button.x,button.y]
  end
end
