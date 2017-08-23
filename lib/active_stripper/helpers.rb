# Any helper processor in this module need to have their first argument set to contain
# to value to be processed
module ActiveStripper
  module Helpers
    class << self

      #
      # Apply String#strip to value
      #
      # @param [String] val String to strip
      #
      # @return [String] Stripped value
      #
      def white_space_stripper(val)
        return if !val
        return val.strip
      end

      #
      # Replace double spaces with single space
      #
      # @param [String] val String to clean up
      #
      # @return [String] Cleaned up string
      #
      def multiple_space_stripper(val)
        return if !val
        return val.gsub(/\s+/, " ")
      end

      #
      # Remove all trailing spaces at the end of the string
      #
      # @param [String] val String to clean up
      #
      # @return [String] Cleaned up string
      #
      def end_space_stripper(val)
        return if !val
        return val.gsub(/\s+$/, "")
      end

      #
      # Remove all trailong spaces at the beginning of the string
      #
      # @param [String] val String to clean up
      #
      # @return [String] Cleaned up string
      #
      def start_space_stripper(val)
        return if !val
        return val.gsub(/^\s+/, "")
      end

      #
      # Lower case the entire string through String#downcase
      #
      # @param [String] val String to lower
      #
      # @return [String] Lowered case string
      #
      def to_lower_stripper(val)
        return if !val
        return val.downcase
      end

      #
      # Set value to nil if val is an empty string
      #
      # @param [String] val String to evaluate
      #
      # @return [String/Nil] Return @val if not empty otherwise return nil
      #
      def empty_string_to_nil(val)
        return if !val || val == ""
        return val
      end
    end
  end
end
