class GosuAppAdapter

  def initialize(app,main_window)
    @app = app
    @main_window = main_window
  end

  def update(time)
    @app.update time
  end

  def draw(target)
    @app.draw target
  end

  # TODO convert keys?!?
  def button_down(id)
    case id
    when MsLeft
      @app.on_event GooEvent.new(:mouse_down, { 
        :x => @main_window.mouse_x, :y => @main_window.mouse_y, 
        :button => MOUSE_LEFT})

    # gosu doens't track mouse motion?
    when MouseMotionEvent
      @app.on_event GooEvent.new(:mouse_motion, { 
        :x => event.pos[0], :y => event.pos[1]})
    else
      # assume it's a key
      # where do I get the mods? ie shift,alt,ctrl
      # where do I get the string rep of the char?
      mods = []
      mods << K_LALT if @main_window.button_down? KbLeftAlt
      mods << K_RALT if @main_window.button_down? KbRightAlt
      mods << K_LCTRL if @main_window.button_down? KbLeftControl
      mods << K_RCTRL if @main_window.button_down? KbRightControl
      mods << K_LSHIFT if @main_window.button_down? KbLeftShift
      mods << K_RSHIFT if @main_window.button_down? KbRightShift
      button_string = @main_window.button_id_to_char(id)
      @app.on_event GooEvent.new(:key_pressed, { 
        :key => id, :mods => mods, :string => button_string})
    end
  end

  def button_up(id)
    # TODO copy and tweak from above
  end


end
