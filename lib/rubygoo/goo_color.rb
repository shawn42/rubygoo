module Rubygoo
  COLORS = {} unless const_defined? 'COLORS'
  require 'css_colors'

  # is an rbga color
  class GooColor
    attr_accessor :r,:g,:b,:a
    def initialize(r,g,b,a)
    @r,@g,@b,@a = r,g,b,a 
    end

    def self.color(color, alpha=nil)
      c = COLORS[color]
      c ||= [0,0,0,255]
      c[3] = alpha if alpha
      GooColor.new *c
    end
  end
end
