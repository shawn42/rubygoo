module Rubygoo
  # this class represents a collection of widgets that can be
  # tabbed through
  class TabGroup
    attr_accessor :selected_index, :widgets

    def initialize()
      @widgets = []
      @selected_index = 1
    end

    def add(*widgets)

      widgets.uniq.each do |w|
        unless @widgets.include? w
          if w.tab_to?
            @widgets << w
            w.focus_priority = @widgets.size unless w.focus_priority
          else
             if w.respond_to? :widgets and w.widgets.size > 0
              add *w.widgets
             end
             if w.respond_to? :queued_widgets and w.queued_widgets.size > 0
              add *w.queued_widgets
             end
          end
        end
      end

      @widgets.sort_by {|w| w.focus_priority}

    end

    def remove(*widgets)
      widgets.uniq.each do |w|
        @widgets.delete(w)
      end
    end

    def next()
      rotate 1
    end

    def previous()
      rotate -1
    end

    def focus(w)
      index = @widgets.index w
      if index
        @widgets[@selected_index]._unfocus if @widgets[@selected_index]
        @selected_index = index
        @widgets[@selected_index]._focus
      end
    end

    def rotate(dir)
      if @widgets.size > 0
        @widgets[@selected_index]._unfocus if @widgets[@selected_index]
        @selected_index += dir
        @selected_index %= @widgets.size
        @widgets[@selected_index]._focus
      end
    end

  end
end
