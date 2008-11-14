require 'publisher'
module Rubygoo
  # contains radio buttons, allowing only one to be checked at a time
  class RadioGroup < Container

    def initialize(opts={})
      # TODO add label, border
      super opts
    end

    def add(*widgets)
      widgets.uniq.each do |w|
        if w.respond_to? :checked?
          w.when :checked do |*opts|
            widget = opts.first
            if widget.checked?
              update_group_selection widget
            end
          end
        end
      end

      super *widgets 
    end

    def update_group_selection(selected_widget)
      @widgets.each do |w|
        if w.respond_to? :checked?
          if w.checked?
            unless selected_widget == w
              w.uncheck
            end
          end
        end
      end
    end
  end

end

