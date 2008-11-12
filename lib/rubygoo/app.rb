module Rubygoo
  class App < Container

    DEFAULT_PARAMS = {:theme=>'default',:x=>10,:y=>10,:data_dir=>File.join(File.dirname(__FILE__),"..","..","themes"),:mouse_cursor => true}
    attr_accessor :theme_name, :theme, :data_dir, :theme_dir, :renderer, :tab_groups

    def initialize(opts={})
      merged_opts = DEFAULT_PARAMS.merge opts
      @widgets = []
      @tab_groups = []
      @tab_groups << TabGroup.new

      theme_name = merged_opts[:theme]
      @data_dir = merged_opts[:data_dir]
      @theme_name = theme_name
      @theme = load_theme theme_name
      @renderer = merged_opts[:renderer]
      super merged_opts

      # should this go here?
      @mouse_cursor = merged_opts[:mouse_cursor]
      if @mouse_cursor
        @mouse = MouseCursor.new
        @mouse.parent = self
        @mouse.app = self.app
        @mouse.added
      end
      @mouse_dragging = false
    end

    def app()
      self
    end

    def load_theme(theme_name)
      @theme_dir = File.join(@data_dir,theme_name)
      @theme = YAML::load_file(File.join(@theme_dir,"config.yml"))
    end

    def draw(screen)
      @renderer.start_drawing
      super @renderer
      @mouse.draw @renderer if @mouse_cursor
      @renderer.finish_drawing
    end

    def focus(w)
      @tab_groups.last.focus w
    end

    def add_tabbed_widget(w)
      @tab_groups[0].add w
    end

    def add_tab_group(tg)
      @tab_groups << tg
    end

    def focus_back()
      @tab_groups.last.previous
    end

    def focus_forward()
      @tab_groups.last.next
    end

    def on_event(event)
      case event.event_type
      when :key_released
        modal_keyboard_call :key_released, event
      when :key_pressed
        case event.data[:key]
        when K_TAB
          if event.data[:mods].include? K_LSHIFT or event.data[:mods].include? K_RSHIFT
            focus_back
          else
            focus_forward
          end
        else
          modal_keyboard_call :key_pressed, event
        end
      when :mouse_down
        modal_mouse_call :mouse_down, event
        # TODO: I know this is simplistic and doesn't account for which button
        # is being pressed/released
        @mouse_start_x = event.data[:x]
        @mouse_start_y = event.data[:y]
      when :mouse_up
        x = event.data[:x]
        y = event.data[:y]
        if @mouse_start_x == x and @mouse_start_y == y
          modal_mouse_call :mouse_up, event
        else
          modal_mouse_call :mouse_drag, event
        end
        @mouse_start_x = nil
        @mouse_start_y = nil
      when :mouse_motion
        x = event.data[:x]
        y = event.data[:y]
        if @mouse_start_x
          modal_mouse_call :mouse_dragging, event
        else
          modal_mouse_call :mouse_motion, event
        end
        @mouse.mouse_motion event if @mouse_cursor
      end
    end

    # redirects all events to this widget
    def add_modal(widget)
      @modal_widgets << widget
      tg = TabGroup.new
      tg.add(widget)
      self.app.add_tab_group tg
      add widget
    end

    def remove_modal(widget)
      self.app.pop_tab_group
      remove widget
    end

    def pop_tab_group()
      @tab_groups.pop
    end

    # distribute our mouse events to our modals first
    def modal_mouse_call(meth, event)
      if @modal_widgets.empty?
        @widgets.each do |w|
          w.send meth, event if w.contains? [event.data[:x],event.data[:y]] 
        end
      else
        @modal_widgets.last.send meth, event
      end
    end

    # distribute our keyboard events to our modals first
    def modal_keyboard_call(meth, event)
      if @modal_widgets.empty?
        @widgets.each do |w|
          w.send meth, event if w.focussed?
        end
      else
        @modal_widgets.last.send meth, event
      end
    end

  end
end
