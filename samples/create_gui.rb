module CreateGui
  def create_gui(renderer, icon)
    app = App.new :renderer => renderer

    label = Label.new "click the button to set the time", :x=>20, :y=>30

    button = Button.new "Click Me!", :x=>70, :y=>80, :padding_left=>20, :padding_top=>20, :icon => icon, :enabled => false
    button.on :pressed do |*opts|
      label.set_text(Time.now.to_s)
    end

    icon_widget = Icon.new :x => 280, :y => 80, :icon => icon

    check = CheckBox.new :x=>370, :y=>70, :w=>20, :h=>20, :label=> "Check me out!"
    check.on :mouse_enter do
      puts "ENTERING #{self.class}"
    end
    check.on :mouse_exit do
      puts "EXITING #{self.class}"
    end

    check.on :checked do
      label.set_text("CHECKED [#{check.checked?}]")
      if check.checked?
        button.enable
      else
        button.disable
      end
    end

    text_field = TextField.new "initial text", :x => 70, :y => 170, :max_length => 20, :min_length => 6

    text_field.on_key K_RETURN, K_KP_ENTER do |evt|
      puts "BOO-YAH"
    end

    modal_button = Button.new "Modal dialogs", :x=>270, :y=>240, :padding_left=>20, :padding_top=>20
    modal_button.on :pressed do |*opts|
      modal = Dialog.new :modal => app, :x=>60, :y=>110, :w=>250, :h=>250

      modal.add Label.new("Message Here", :x=>20, :y=>70, :padding_left=>20, :padding_top=>20, :relative=>true)
      resize_me = Button.new "resize", :relative=>true, :x=>170, :y=>180
      resize_me.on :pressed do |*opts|
        modal.resize opts.first
      end

      ok_butt = Button.new("OK", :x=>70, :y=>180, :padding_left=>20, :padding_top=>20,:relative=>true)
      ok_butt.on :pressed do |*opts|
        modal.close
      end
      modal.add ok_butt, resize_me

      modal.display
    end

    grp = RadioGroup.new :x=>10, :y=>380, :padding_left=>20, :padding_top=>20, :w=> 500, :h=>80
    grp_label = Label.new "RadioGroups are fun!", :x=>40, :y=>10, :w=>20, :h=>20, :relative=>true
    grp_radio_one = RadioButton.new :x=>40, :y=>40, :w=>20, :h=>20, :relative=>true
    grp_radio_two = RadioButton.new :x=>90, :y=>40, :w=>20, :h=>20, :relative=>true
    grp_radio_three = RadioButton.new :x=>140, :y=>40, :w=>20, :h=>20, :relative=>true

    grp.add grp_label, grp_radio_one, grp_radio_two, grp_radio_three

    hide_button = Button.new "Hide the radios!", :x=>170, :y=>330, :padding_left=>10, :padding_top=>10
    hide_button.on :pressed do |*opts|
      if grp.visible?
        grp.hide
      else
        grp.show
      end
    end

    # implicit tab ordering based on order of addition, can
    # specify if you want on widget creation

    # can add many or one at a time
    app.add text_field, label, button, modal_button, grp, hide_button, icon_widget
    app.add check

    app
  end
end
