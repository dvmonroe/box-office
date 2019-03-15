# frozen_string_literal: true

module Box
  module Office
    class Booth
      include Box::Office::Connection
      attr_reader :showing

      delegate :config, to: Box::Office

      def initialize(showing:)
        @showing = showing
      end

      def first_available_opening(conn)
        1.upto(showing.showings) do |idx|
          queue = find_queue(idx)

          # Redlock::Client.new([conn]).lock("#{queue.name}-locked", 3000) do |locked|
            if !Janitor.locked?(queue.name) && below_capacity?(queue)
              yield queue
              return
            end
          # end

          next if idx < showing.showings

          raise NoOpenings, "No available openings for #{showing.name}"
        end
      end

      private

      def below_capacity?(queue)
        queue.length < showing.capacity
      end

      def find_queue(idx)
        showing.send(config.reserved, idx)
      end
    end
  end
end
