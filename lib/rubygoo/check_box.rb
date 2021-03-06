require 'label'
module Rubygoo
  class CheckBox < Widget
    attr_accessor :checked
    attr_reader  :label_text
    can_fire :checked

    DEFAULT_PARAMS = {:align=>:right}
    DEFAULT_PARAMS.keys.each do |k|
      goo_prop k
    end

    def initialize(opts={})
      opts = DEFAULT_PARAMS.merge opts
      @checked = opts[:checked]

      @label_text = opts[:label_text]
      @label_alignment = opts[:align]

      super opts
    end

    def added()
      @color = theme_property :color
      @bg_color = theme_property :bg_color
      @border_color = theme_property :border_color
      @focus_color = theme_property :focus_color
      @checked_color = theme_property :checked_color
      @hover_color = theme_property :hover_color

      @rect = Rect.new [@x-@padding_left,@y-@padding_top,@w+2*@padding_left,@h+2*@padding_top]
      unless @label_text.nil? or @label_text.empty?
        @label = Label.new @label_text, :x=>0,:y=>0, :relative=>@relative, :visible=>false
        @parent.add @label

        case @label_alignment
        when :right
          lx = @x+2*@padding_left+@w
          ly = @y
        when :left
          ly = @y
          lx = @x-2*@padding_left-@label.w
        end
        @label.x = lx
        @label.y = ly
        @label.show
      end
    end

    def checked?()
      @checked
    end

    def toggle()
      if checked?
        uncheck
      else
        check
      end
    end

    def check()
      @checked = true
      fire :checked, self
    end

    def uncheck()
      @checked = false
      fire :checked, self
    end

    # called when there is a mouse click
    def mouse_up(event)
      toggle
    end

    # called when there is a mouse click at the end of a drag
    def mouse_drag(event)
      toggle
    end

    # called when a key press is sent to us
    def key_pressed(event)
      case event.data[:key]
      when K_SPACE
        toggle
      end
    end

    def draw(adapter)
      x1 = @rect[0]
      y1 = @rect[1]
      x2 = @rect[2] + x1
      y2 = @rect[3] + y1
      if @focussed
        adapter.fill x1, y1, x2, y2, @focus_color
      elsif @bg_color
        adapter.fill x1, y1, x2, y2, @bg_color
      end

      if @checked
        rect = @rect.inflate(-@padding_left,-@padding_top)
        cx1 = rect[0]
        cy1 = rect[1]
        cx2 = rect[2] + x1
        cy2 = rect[3] + y1
        adapter.fill cx1, cy1, cx2, cy2, @checked_color
      end

      if mouse_over? and @hover_color
        adapter.fill x1, y1, x2, y2, @hover_color
      end

      if @border_color
        adapter.draw_box x1, y1, x2, y2, @border_color
      end
    end

    # DSL methods
    def label_text(new_val=nil)
      @label_text = new_val if new_val
      @label_text
    end

  end
end

