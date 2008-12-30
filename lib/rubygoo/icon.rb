module Rubygoo
  # Icon is basically a place holder for images
  class Icon < Widget
    def initialize(opts={})
      @icon = opts[:icon]
      super opts
    end

    def added()
      update_rect
    end

    def draw(adapter)
      x1 = @rect[0]
      y1 = @rect[1]
      x2 = @rect[2] + x1
      y2 = @rect[3] + y1

      # TODO center icon
      ix = x1#+((x2-x1)-@icon.w)
      iy = y1#+((y2-y1)-@icon.h)
      adapter.draw_image @icon, ix+@padding_left,iy+@padding_top
    end

    #DSL methods
    def icon_image(new_val=nil)
      @icon = new_val if new_val
      @icon
    end

  end

end

