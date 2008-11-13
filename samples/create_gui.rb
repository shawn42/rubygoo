module CreateGui
  def create_gui(renderer, icon)
    app = App.new :renderer => renderer

    label = Label.new "click the button to set the time", :x=>20, :y=>30

    button = Button.new "Click Me!", :x=>70, :y=>80, :x_pad=>20, :y_pad=>20, :icon => icon
    button.on :pressed do |*opts|
      label.set_text(Time.now.to_s)
    end

    check = CheckBox.new :x=>370, :y=>70, :w=>20, :h=>20
    check.on :checked do
      label.set_text("CHECKED [#{check.checked?}]")
    end

    text_field = TextField.new "initial text", :x => 70, :y => 170, :max_length => 20, :min_length => 6

    text_field.on_key K_RETURN, K_KP_ENTER do |evt|
      puts "BOO-YAH"
    end

    modal_button = Button.new "Modal dialogs", :x=>270, :y=>280, :x_pad=>20, :y_pad=>20
    modal_button.on :pressed do |*opts|
      # TODO make some of this stuff relative and/or make Dialog's
      # constructor take a layout to use
      modal = Dialog.new :modal => app, :x=>60, :y=>110, :w=>250, :h=>250

      modal.add Label.new("Message Here", :x=>20, :y=>70, :x_pad=>20, :y_pad=>20, :relative=>true)
      resize_me = Button.new "resize", :relative=>true, :x=>170, :y=>180
      resize_me.on :pressed do |*opts|
        modal.resize opts.first
      end

      ok_butt = Button.new("OK", :x=>70, :y=>180, :x_pad=>20, :y_pad=>20,:relative=>true)
      ok_butt.on :pressed do |*opts|
        app.remove_modal(modal)
      end
      modal.add ok_butt, resize_me

      modal.show
    end

    panel = Container.new :x=>10, :y=>380, :x_pad=>20, :y_pad=>20, :w=> 500, :h=>80
    panel_label = Label.new "On a scale of one to three", :x=>40, :y=>10, :w=>20, :h=>20, :relative=>true
    panel_check_one = CheckBox.new :x=>40, :y=>40, :w=>20, :h=>20, :relative=>true
    panel_check_two = CheckBox.new :x=>90, :y=>40, :w=>20, :h=>20, :relative=>true
    panel_check_three = CheckBox.new :x=>140, :y=>40, :w=>20, :h=>20, :relative=>true

    panel_check_one.when :checked do
      if panel_check_one.checked?
        panel_check_two.uncheck
        panel_check_three.uncheck
      end
    end
    panel_check_two.when :checked do
      if panel_check_two.checked?
        panel_check_one.uncheck
        panel_check_three.uncheck
      end
    end
    panel_check_three.when :checked do
      if panel_check_three.checked?
        panel_check_two.uncheck
        panel_check_one.uncheck
      end
    end

    panel.add panel_label, panel_check_one, panel_check_two, panel_check_three

    # implicit tab ordering based on order of addition, can
    # specify if you want on widget creation

    # can add many or one at a time
    app.add text_field, label, button, modal_button, panel
    app.add check

  #  pulldown = Pulldown.new {:x=>70, :y=>80}
  #  pulldown.on :changed do |*opts|
  #    label.set_text(opts.first)
  #  end
  #
  #  app.add pulldown
    app
  end
end
