# frozen_string_literal: true

module Box
  module Office
    class Configuration
      # Redis instance
      # @return [Object]
      attr_accessor :instance

      attr_accessor :pool_size

      attr_accessor :standby

      attr_accessor :reserved

      attr_accessor :fulfilled

      attr_accessor :showings

      attr_accessor :default_name

      attr_accessor :track_fulfilled

      attr_accessor :capacity

      attr_accessor :lock_reserved

      def initialize
        @instance         = Redis.current
        @pool_size        = 5

        @standby          = :standby
        @reserved         = :reserved
        @fulfilled        = :fulfilled
        @showings         = 1
        @track_fulfilled  = true
        @capacity         = 100
        @default_name     = "Box Office Hit"
        @lock_reserved    = true
      end

      instance_methods.each do |meth|
        define_method("#{meth}?") do
          return send(meth) == true if !!send(meth) == send(meth) # rubocop:disable Style/DoubleNegation

          raise NotBoolean, "Configuration##{meth} does not return a Boolean and therefore, has no predicate method."
        end
      end

      def single_queues
        queues - [reserved]
      end

      def queues
        [standby, reserved, fulfilled]
      end
    end

    # @return [Box::Office::Configuration] Box::Office's current configuration
    def self.configuration
      @configuration ||= Configuration.new
    end

    class << self
      alias config configuration
    end

    # Set Box::Office's configuration
    # @param config [Box::Office::Configuration]
    def self.configuration=(config)
      @configuration = config
    end

    # Modify Box::Office's current configuration
    # @yieldparam [Box::Office] config current Box::Office config
    # ```
    # Box::Office.configure do |config|
    #   config.routes = false
    # end
    # ```
    def self.configure
      yield configuration
    end
  end
end
