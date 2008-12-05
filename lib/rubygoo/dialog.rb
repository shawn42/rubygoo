module Rubygoo
  class Dialog < Container

    def initialize(opts)
      super opts
      @modal_target = opts[:modal]
    end
    
    def added()
      super

      @bg_color = theme_property :bg_color
      @color = theme_property :color

      @border_color = theme_property :border_color
      @focus_color = theme_property :focus_color
    end

    def modal?()
      @modal_target
    end

    # show the dialog by adding it to the @modal_target and
    # intercepting all of its events
    def display()
      @modal_target.add_modal self
    end

    # close this modal dialog
    def close()
      @modal_target.remove_modal self
    end

  end
end

