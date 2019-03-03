# frozen_string_literal: true

module Box
  module Office
    class Queue
      include Box::Office::Connection
      LIMIT = 100

      attr_reader :name

      def initialize(name)
        @name = name
      end

      def clear
        with_connection { |conn| conn.del(name) }
      end

      def members(limit: LIMIT)
        with_connection { |conn| conn.lrange(name, 0, limit - 1) }
      end

      def empty?
        length.zero?
      end

      def length
        with_connection { |conn| conn.llen(name) }
      end
      alias size length

      def push(*msg)
        with_connection { |conn| conn.lpush(name, *msg) }
      end
      alias << push

      def remove(msg)
        with_connection { |conn| conn.lrem(name, 0, msg) }
      end
      alias >> remove
    end
  end
end
