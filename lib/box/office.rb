# frozen_string_literal: true

require "active_support/inflector"
require "redis"
require "redlock"

require "box/office/version"
require "box/office/configuration"

require "box/office/connection"

require "box/office/janitor"
require "box/office/booth"
require "box/office/queue"
require "box/office/showing"

module Box
  module Office
    class NoOpenings < StandardError; end
    class QueueInUse < StandardError; end
    class NotBoolean < StandardError; end
    class OutOfRange < StandardError; end

    class << self
      def showing(name: config.default_name, track_fulfilled: config.track_fulfilled,
                  showings: config.showings, capacity: config.capacity)
        Showing.new(name: name, track_fulfilled: track_fulfilled, showings: showings, capacity: capacity)
      end
    end
  end
end
