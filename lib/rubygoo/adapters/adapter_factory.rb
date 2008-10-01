module Rubygoo
  class AdapterFactory

    def app_for(platform,*args)
      require "#{platform}_app_adapter"
      Rubygoo.const_get("#{platform.to_s.capitalize}AppAdapter").new *args
#      ::ObjectSpace.const_get("#{platform.to_s.capitalize}AppAdapter").new *args
    end

    def renderer_for(platform,*args)
      require "#{platform}_render_adapter"
      Rubygoo.const_get("#{platform.to_s.capitalize}RenderAdapter").new *args
    end


  end
end
