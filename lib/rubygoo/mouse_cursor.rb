module Rubygoo
  class MouseCursor < Widget

    def added()
      cursor = theme_property :mouse_cursor
      @cursor_file = File.join(@app.theme_dir,cursor)
      @color = theme_property :color
      # use a 4px box for now
      @size = 4
    end

    def draw(adapter)
      adapter.draw_box @x, @y, @x+@size, @y+@size, @color
    end

    def mouse_motion(event)
      @x = event.data[:x]
      @y = event.data[:y]
    end
  end
end
