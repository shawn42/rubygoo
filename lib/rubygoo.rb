$: << File.dirname(__FILE__)
$: << File.join(File.dirname(__FILE__),"rubygoo")
$: << File.join(File.dirname(__FILE__),"rubygoo","adapters")
require 'rubygems'
require 'rubygoo/goo_event'
require 'rubygoo/goo_color'
require 'rubygoo/adapters/adapter_factory'
require 'yaml'
require 'rubygoo/widget'
require 'rubygoo/container'
require 'rubygoo/mouse_cursor'
require 'rubygoo/app'
require 'rubygoo/label'
require 'rubygoo/button'
require 'rubygoo/check_box'
require 'rubygoo/text_field'
require 'rubygoo/dialog'
