module Rubygoo
  # this is basically a round checkbox
  class RadioButton < CheckBox

    def draw(adapter)
      x1 = @rect[0]
      y1 = @rect[1]
      x2 = @rect[2] + x1
      y2 = @rect[3] + y1

      radius = (@rect[2]/2.0).ceil

      if @focussed
        adapter.draw_circle @rect.centerx, @rect.centery, radius, @focus_color
      elsif @bg_color
        adapter.draw_circle @rect.centerx, @rect.centery, radius, @bg_color
      end

      if @checked
        adapter.draw_circle_filled @rect.centerx, @rect.centery, radius-@x_pad, @checked_color
      end

      if mouse_over? and @hover_color
        adapter.draw_circle_filled @rect.centerx, @rect.centery, radius-@x_pad, @hover_color
      end

      if @border_color
        adapter.draw_circle @rect.centerx, @rect.centery, radius, @border_color
      end
    end
  end
end

