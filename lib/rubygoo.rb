$: << File.dirname(__FILE__)
$: << File.join(File.dirname(__FILE__),"rubygoo")
$: << File.join(File.dirname(__FILE__),"rubygoo","adapters")
# TODO move this into RubygameAppAdapter
require 'rubygame'
include Rubygame

require 'goo_event'
require 'goo_color'
require 'adapter_factory'
require 'yaml'
require 'widget'
require 'container'
require 'app'
require 'label'
require 'button'
require 'check_box'
require 'text_field'
require 'dialog'
