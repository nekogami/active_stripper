module ActiveStripper
  module Helpers
    class << self

      def white_space_stripper(val)
        return if !val

        return val.strip
      end

      def multiple_space_stripper(val)
        return if !val

        return val.gsub(/\s+/, " ")
      end

      def end_space_stripper(val)
        return val.gsub(/\s+$/, "")
      end

      def start_space_stripper(val)
        return val.gsub(/^\s+/, "")
      end

      def to_lower_stipper(val)
        return val.downcase
      end

    end
  end
end
