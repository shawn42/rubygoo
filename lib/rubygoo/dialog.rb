module Rubygoo
  class Dialog < Container

    def initialize(opts, &close_callback)
      super opts
      @close_callback = close_callback if block_given?
      @modal_target = opts[:modal]
    end
    
    def added()
      super

      @bg_color = theme_property :bg_color
      @color = theme_property :color

      @border_color = theme_property :border_color
      @focus_color = theme_property :focus_color

      @rect = Rect.new [@x-@x_pad,@y-@y_pad,@w+2*@x_pad,@h+2*@y_pad]
    end

    def modal?()
      @modal_target
    end

    # show the dialog by adding it to the @modal_target and
    # intercepting all of its events
    def show()
      @modal_target.add_modal self
    end

    # close this modal dialog
    def close()
      @modal_target.remove_modal self
    end

  end
end

