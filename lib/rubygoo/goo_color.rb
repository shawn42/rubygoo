module Rubygoo
  COLORS = {} unless const_defined? 'COLORS'
  require 'css_colors'

  # is an rbga color
  class GooColor
    attr_accessor :r,:g,:b,:a
    def initialize(r,g,b,a)
    @r,@g,@b,@a = r,g,b,a 
    end
  end
end
