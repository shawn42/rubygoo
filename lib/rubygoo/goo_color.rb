require 'css_colors'
module Rubygoo
  # is an rbga color
  class GooColor
    attr_accessor :r,:g,:b,:a
    def initialize(r,g,b,a)
    @r,@g,@b,@a = r,g,b,a 
    end

    def self.css_color(sym, alpha=nil)
      color = CSS_COLORS[sym]
      a = alpha.nil? ? color[3] : alpha
      GooColor.new color[0], color[1], color[2], a 
    end
  end
end
