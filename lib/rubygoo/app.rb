module Rubygoo
  class App < Container

    DEFAULT_PARAMS = {:theme=>'default',:x=>10,:y=>10,:width=>600,:height=>480,:data_dir=>File.join(File.dirname(__FILE__),"..","..","themes")}
    attr_accessor :theme_name, :theme, :data_dir, :theme_dir, :renderer

    def initialize(opts={})
      merged_opts = DEFAULT_PARAMS.merge opts
      @widgets = []
      @tabbed_widgets = []
      @focussed_widget = 0
      theme_name = merged_opts[:theme]
      @data_dir = merged_opts[:data_dir]
      @theme_name = theme_name
      @theme = load_theme theme_name
      @renderer = merged_opts[:renderer]
      super merged_opts

      # should this go here?
      @mouse = MouseCursor.new
      @mouse.parent = self
      @mouse.app = self.app
      @mouse.added
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
      @mouse.draw @renderer
      @renderer.finish_drawing
    end

    def add_tabbed_widget(w)
      w.focus_priority = @tabbed_widgets.size unless w.focus_priority
      @focussed_widget = 1
      w.focus if @tabbed_widgets.empty?
      @tabbed_widgets << w 
      @tabbed_widgets.sort_by {|w| w.focus_priority}
    end

    def focus_back()
      @tabbed_widgets[@focussed_widget].unfocus
      @focussed_widget += 1
      @focussed_widget %= @tabbed_widgets.size
      @tabbed_widgets[@focussed_widget].focus
    end

    def focus_forward()
      @tabbed_widgets[@focussed_widget].unfocus
      @focussed_widget -= 1
      @focussed_widget %= @tabbed_widgets.size
      @tabbed_widgets[@focussed_widget].focus
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
      else
        # ALL mouse events go here
        modal_mouse_call event.event_type, event

        if event.event_type == :mouse_motion
          @mouse.mouse_motion event
        end
      end
    end

  end
end
