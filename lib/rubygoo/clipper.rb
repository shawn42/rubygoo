module Rubygoo
  class Clipper < Rect
    attr_accessor :tx, :ty

    DEFAULT_PARAMS = {
      :x => 0,
      :y => 0,
      :w => 0,
      :h => 0,
      :tx => 0,
      :ty => 0
    }

    def initialize(opts={})
      merged_opts = DEFAULT_PARAMS.merge opts
      self.x = merged_opts[:x]
      self.y = merged_opts[:y]
      self.w = merged_opts[:w]
      self.h = merged_opts[:h]
      self.tx = merged_opts[:tx]
      self.ty = merged_opts[:ty]
      super self.x,self.y,self.w,self.h
    end

    def apply_clip(clip)
      # DO NOT UNDERSTAND the 2s and 4s here
      diff_x = (clip.x - clip.padding_left) - self.x + 2
      diff_y = (clip.y - clip.padding_top) - self.y + 2
      diff_w = (clip.w + clip.padding_left + clip.padding_right - 4) - self.w
      diff_h = (clip.h + clip.padding_top + clip.padding_bottom - 4) - self.h

      self.x += diff_x
      self.y += diff_y
      self.w += diff_w
      self.h += diff_h
      Rect.new [diff_x,diff_y,diff_w,diff_h]
    end

    def remove_clip(clip)
      self.x += clip.x
      self.y += clip.y
      self.w += clip.w
      self.h += clip.h
    end

    def apply_trans(trans)
#      p "apply trans: #{trans.tx},#{trans.ty}"
      diff_x = trans.tx - self.tx
      diff_y = trans.ty - self.ty
      self.tx += trans.tx
      self.ty += trans.ty
      [diff_x,diff_y]
    end

    def remove_trans(trans)
#      p "remove trans: #{trans.class}: #{trans}"
      self.tx -= trans[0]
      self.ty -= trans[1]
    end

    def inspect
      "#{self.class} [#{self.x},#{self.y},#{self.w},#{self.h},#{self.tx},#{self.ty}]"
    end

  end
end
