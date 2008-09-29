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

  # show the dialog by adding it to the @modal_target and
  # intercepting all of its events
  def show()
    @modal_target.add_modal self
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

