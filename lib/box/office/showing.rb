# frozen_string_literal: true

module Box
  module Office
    class Showing
      include Connection

      attr_accessor :track_fulfilled, :showings, :capacity
      attr_reader :name, :booth

      delegate :config, to: Box::Office

      def initialize(name: config.default_name, track_fulfilled: config.track_fulfilled?,
                     showings: config.showings, capacity: config.capacity)
        @name              = name
        @track_fulfilled   = track_fulfilled
        @showings          = showings
        @capacity          = capacity

        @booth             = Booth.new(showing: self)

        setup_reserved_queues
      end

      Box::Office.config.single_queues.each do |que|
        define_method que do
          Queue.new send("#{que}_key")
        end
      end

      def fulfill(queue, msg)
        send(config.fulfilled) << msg if track_fulfilled
        queue >> msg
      end

      def push(*msg)
        with_connection { |conn| conn.lpush(send("#{config.standby}_key"), *msg) }
      end
      alias << push

      def reserve(capacity: self.capacity, block_unlock: true)
        with_connection do |conn|
          booth.first_available_opening(conn) do |opening|
            Janitor.lock(opening.name) if config.lock_reserved?
            conn.rpoplpush(send("#{config.standby}_key"), opening.name) while openings?(opening, capacity)

            if block_given?
              yield opening, opening.members(limit: capacity)
              Janitor.unlock(opening.name) if config.lock_reserved? && block_unlock
            end
          rescue
            Janitor.unlock(opening.name)
            raise
          end
        end
      end
      alias pop reserve

      private

      Box::Office.config.single_queues.each do |que|
        define_method "#{que}_key" do
          "box-office:#{name.parameterize}:#{que}"
        end
      end

      Box::Office.config.reserved.tap do |que|
        define_method "#{que}_key" do |idx|
          "box-office:#{name.parameterize}:#{que}-#{idx}"
        end
      end

      def openings?(queue, capacity)
        queue.length < capacity && !send(config.standby).empty?
      end

      def setup_reserved_queues
        Box::Office.config.reserved.tap do |que|
          define_singleton_method que do |idx = 1|
            raise OutOfRange, "#{idx} is out of range of available showings" unless (1..showings).to_a.include? idx

            Queue.new send("#{que}_key", idx)
          end
        end
      end
    end
  end
end
