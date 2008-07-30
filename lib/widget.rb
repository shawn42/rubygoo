require 'publisher'
class Widget
  extend Publisher
  can_fire :clicked
  attr_accessor :enabled, :parent, :container, 
    :x, :y, :w, :h, :app, :x_pad, :y_pad

  DEFAULT_PARAMS = {
    :x => 0,
    :y => 0,
    :w => 1,
    :h => 1,
    :x_pad => 2,
    :y_pad => 2,
  }
  def initialize(opts={})
    merged_opts = DEFAULT_PARAMS.merge opts
    @x = merged_opts[:x]
    @y = merged_opts[:y]
    @x_pad = merged_opts[:x_pad]
    @y_pad = merged_opts[:y_pad]
    @w = merged_opts[:w]
    @h = merged_opts[:h]
    update_rect
  end

  def update_rect()
    @rect = Rect.new [@x,@y,@w+@x_pad,@h+@y_pad]
  end

  # called when the widget is added to a container
  def added()
  end

  # called when the widget is removed from a container
  def removed()
  end

  def contains?(pos)
    @rect.collide_point? pos[0], pos[1]
  end

  def enabled?()
    @enabled
  end

  def update(millis)
  end

  # draw ourself on the screen
  def draw(screen)
  end

  # called when there is a mouse click
  def clicked(event)
  end

end

class Container < Widget

  attr_accessor :widgets

  def initialize(opts={})
    super opts
    @widgets = []
  end

  # Add widget(s) to the container.
  def add(*widgets)
    widgets.uniq.each do |w|
      unless @widgets.include? w
        w.container = self
        w.parent = self
        w.app = self.app
        w.added
        @widgets << w
      end
    end
    widgets
  end

  # Remove widget(s) to the container.
  def remove(*widgets)
    widgets.uniq.each do |w|
      @widgets.delete(w).removed
    end
  end

  # draw ourself and our children
  def draw(screen)
    # any container specific code here (borders?)
    screen.fill @theme['App'][:bg_color]

    # draw kiddies 
    @widgets.each do |w|
      w.draw screen
    end
  end

  # called when there is a mouse click
  def clicked(event)
    @widgets.each do |w|
      w.clicked event if w.contains? event.pos 
    end
  end

end

class App < Container

  DEFAULT_PARAMS = {:theme=>'default',:x=>10,:y=>10,:width=>600,:height=>480,:data_dir=>File.join(File.dirname(__FILE__),"..","themes")}
  attr_accessor :theme_name, :theme, :data_dir, :theme_dir

  def initialize(opts={})
    merged_opts = DEFAULT_PARAMS.merge opts
    super merged_opts
    @widgets = []
    theme_name = merged_opts[:theme]
    @data_dir = merged_opts[:data_dir]
    @theme_name = theme_name
    @theme = load_theme theme_name

    TTF.setup
  end

  def app()
    self
  end

  def load_theme(theme_name)
    @theme_dir = File.join(@data_dir,theme_name)
    @theme = YAML::load_file(File.join(@theme_dir,"config.yml"))
  end

  def draw(screen)
    # hack for now, until I implement backgrounds
    screen.fill [0,0,0]
    super screen
    screen.update
  end

  # this is where all the rubygame to rubygoo event mapping will
  # happen
  def on_event(event)
    case event
    when KeyDownEvent
      case event.key
      when K_F
        puts "F was pressed in app"
      end
    when MouseUpEvent
      clicked event
    end
  end

end

class Label < Widget
  attr_accessor :text
  def initialize(text, opts={})
    super opts
    @text = text
  end

  def added()
    class_key = self.class.to_s
    font = @app.theme[class_key][:font]
    font_size = @app.theme[class_key][:font_size]
    @color = @app.theme[class_key][:color]
    @bg_color = @app.theme[class_key][:bg_color]
    @border = @app.theme[class_key][:border]

    @font = TTF.new(File.join(@app.theme_dir,font), font_size)
    set_text @text
  end

  def set_text(text)
    @text = text
    @rendered_text = @font.render @text, true, @color
    @rect = Rect.new [@x,@y,@rendered_text.width+@x_pad,@rendered_text.height+@y_pad]
  end

  def undraw(screen)
    # not sure about this yet
    @old_background.blit screen, [@x,@y]
  end

  def draw(screen)
    # draw the bg box if color is set
    if @bg_color
      screen.fill @bg_color, @rect
    end

    if @border
      x1 = @rect[0]
      y1 = @rect[1]
      x2 = @rect[2] + x1
      y2 = @rect[3] + y1
      screen.draw_box [x1,y1],[x2,y2], @border
    end

    @rendered_text.blit screen, [@x,@y]
  end
end

class Button < Widget
  attr_accessor :text
  def initialize(text, opts={})
    super opts
    @text = text
  end

  def added()
    class_key = self.class.to_s
    font = @app.theme[class_key][:font]
    font_size = @app.theme[class_key][:font_size]
    @color = @app.theme[class_key][:color]
    @bg_color = @app.theme[class_key][:bg_color]
    @border = @app.theme[class_key][:border]
    @font = TTF.new(File.join(@app.theme_dir,font), font_size)

    @rendered_text = @font.render @text, true, @color

    @rect = Rect.new [@x-@x_pad,@y-@y_pad,@rendered_text.width+2*@x_pad,@rendered_text.height+2*@y_pad]
  end

  # called when there is a mouse click
  def clicked(event)
    fire :clicked, event
  end

  def draw(screen)
    if @bg_color
      screen.fill @bg_color, @rect
    end
    if @border
      x1 = @rect[0]
      y1 = @rect[1]
      x2 = @rect[2] + x1
      y2 = @rect[3] + y1
      screen.draw_box [x1,y1],[x2,y2], @border
    end

    @rendered_text.blit screen, [@x,@y]
  end
end

