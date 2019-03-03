# frozen_string_literal: true

require "active_support/concern"

module Box
  module Office
    module Connection
      extend ActiveSupport::Concern

      def with_connection
        if defined?(ConnectionPool)
          if configured_instance.is_a?(ConnectionPool)
            configured_instance.with { |conn| yield conn }
          else
            connection_pool.with { |conn| yield conn }
          end
        else
          yield configured_instance
        end
      end

      private

      def configured_instance
        Box::Office.config.instance
      end

      def configured_pool_size
        Box::Office.config.pool_size
      end

      def connection_pool
        ConnectionPool.new(size: configured_pool_size) { configured_instance }
      end
    end
  end
end
