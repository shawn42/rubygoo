class Dialog < Container
  
  def added()
    super
    font = theme_property :font
    font_size = theme_property :font_size
    @font = TTF.new(File.join(@app.theme_dir,font), font_size)

    @bg_color = theme_property :bg_color
    @color = theme_property :color

    @border = theme_property :border
    @focus_color = theme_property :focus_color

    @rect = Rect.new [@x-@x_pad,@y-@y_pad,@w+2*@x_pad,@h+2*@y_pad]
  end

  def initialize(opts, &close_callback)
    super opts
    @close_callback = close_callback if block_given?
    @modal = opts[:modal]
  end

#  def on_mouse_dragging(x,y,event); end
#  def on_mouse_motion(event); end
#  def on_mouse_drag(start_x, start_y, event); end
#  def on_click(event); end
#  def on_key_up(event); end
#  def draw(destination); end
#  def on_network(event); end
#  def update(time);end

end

