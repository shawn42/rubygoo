module Rubygoo
  class ScrollableContainer < Container

    alias old_add add

    def initialize(opts)
      super opts
      @scroll_bars = opts[:scroll_bars]
      # add in scroll buttons
      if @scroll_bars
        @up_butt = Button.new ">", :x => @w-20, :y => 0, :relative => true
        @up_butt.when :pressed do |event|
          @internal_container.ty -= 10
        end
        @down_butt = Button.new "<", :x => @w-20, :y => @h-20, :relative => true
        @down_butt.when :pressed do |event|
          @internal_container.ty += 10
        end
      end
      @internal_container = Container.new opts
    end

    def added()
      super
      old_add @internal_container
      old_add @up_butt, @down_butt if @scroll_bars
    end

    def add(*w)
      @internal_container.add *w
    end

    def mouse_down(event)
      @last_x = event.data[:x]
      @last_y = event.data[:y]
    end

    def mouse_dragging(event)
      data = event.data

      dx = @last_x - data[:x]
      dx = data[:x] - @last_x
      dy = @last_y - data[:y]

      @last_x = data[:x]
      @last_y = data[:y]

      con = @internal_container
      # TODO, cache this call
      req_w, req_h = con.required_lot_size

      if dy < 0
        min_ty = [con.h - req_h,0].min
        if con.ty < min_ty or con.ty + dy < min_ty
          con.ty = min_ty 
        else
          con.ty += dy
        end
      elsif dy > 0
        max_ty = 0
        if con.ty > 0 or con.ty + dy > 0
          con.ty = max_ty 
        else
          con.ty += dy
        end
      end

      if dx < 0
        min_tx = [con.w - req_w,0].min
        if con.tx < min_tx or con.tx + dx < min_tx
          con.tx = min_tx 
        else
          con.tx += dx
        end
      elsif dx > 0
        max_tx = 0
        if con.tx > 0 or con.tx + dx > 0
          con.tx = max_tx 
        else
          con.tx += dx
        end
      end
      p con.tx

    end
  end
end
