# frozen_string_literal: true

module Box
  module Office
    class Janitor
      class << self
        include Box::Office::Connection
        LOCKED_QUEUE_KEY = "box-office:locked:queues"

        def lock(queue_name)
          with_connection { |conn| conn.sadd(LOCKED_QUEUE_KEY, queue_name) }
        end

        def locked?(queue_name)
          with_connection { |conn| conn.sismember(LOCKED_QUEUE_KEY, queue_name) }
        end

        def locked_queues
          with_connection { |conn| conn.smembers LOCKED_QUEUE_KEY }
        end

        def unlock(queue_name)
          with_connection { |conn| conn.srem(LOCKED_QUEUE_KEY, queue_name) }
        end
      end
    end
  end
end
