module Rubygoo
  # all events in the system are converted to these for internal use by our
  # adapter
  class GooEvent
    attr_accessor :event_type, :data, :handled

    def initialize(event_type, event_data = nil)
      @event_type = event_type
      @data = event_data
    end

    def handled?()
      @handled
    end

  end
end
