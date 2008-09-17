= rubygoo

http://rubygoo.googlecode.com

== DESCRIPTION:

Rubygoo is a theme-able gui framework for use with rubygame and soon gosu. It has a strong focus on nice syntax and ease of use.

== FEATURES:

* theme-able gui widgets
* named css colors
* works with rubygame, gosu support on its way
* containers, labels, buttons, checkboxes
* tabbing focus of widgets
* modal dialogs

== SYNOPSIS:

def build_gui(renderer)
  app = App.new :renderer => renderer

  label = Label.new "click the button to set the time", :x=>20, :y=>30

  button = Button.new "Click Me!", :x=>70, :y=>80, :x_pad=>20, :y_pad=>20
  button.on :pressed do |*opts|
    label.set_text(Time.now.to_s)
  end

  check = CheckBox.new :x=>370, :y=>70, :w=>20, :h=>20
  check.on :checked do
    label.set_text("CHECKED [#{check.checked?}]")
  end

  text_field = TextField.new "initial text", :x => 70, :y => 170

  text_field.on_key K_RETURN, K_KP_ENTER do |evt|
    puts "BOO-YAH"
  end
  
  # implicit tab ordering based on order of addition, can
  # specify if you want on widget creation

  # can add many or one at a time
  app.add text_field, label, button
  app.add check
end

screen = Screen.new [600,480]

factory = AdapterFactory.new
render_adapter = factory.renderer_for :rubygame, screen
app = create_gui(render_adapter)
app_adapter = factory.app_for :rubygame, app

# <standard rubygame setup stuff here>

# rubygame loop do ..

  # each event in our queue do ..
    # pass on our events to the GUI
    app_adapter.on_event event
  end

  app_adapter.update clock.tick
  app_adapter.draw render_adapter
end

== REQUIREMENTS:

* publisher gem
* constructor gem
* rubygame gem (for now)

== INSTALL:

* sudo gem install rubygoo

== LICENSE:

  GPLv2
