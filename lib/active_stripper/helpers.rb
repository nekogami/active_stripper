#coding: utf-8

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
      # Execute String#tr on `val`, find `pattern` and replace with `replacements`
      #
      # @param [String] val String to clean up
      # @param [String] pattern First parameters to method String#tr
      # @param [String] replacements Second parameters to method String#tr
      #
      # @return [String] Cleaned up string
      #
      def replace_stripper(val, pattern, replacements)
        return val.tr(pattern, replacements)
      end

      #
      # Execute String#gsub on `val`, find `pattern` and replace with `replacement`
      #
      # @param [String] val String to clean up
      # @param [String] pattern First parameters to method String#gsub
      # @param [String] replacement Second parameters to method String#gsub
      #
      # @return [String] Cleaned up string
      #
      def substitute_stripper(val, pattern, replacement)
        return val.gsub(pattern, replacement)
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

      #
      # Convert value to Integer value if format match.
      # nil and empty string returns 0 other value are converted with
      # Integer(val) command if value is not convertible raise an argument Error
      # Only to use if val is NOT a BigDecimal or should results in one
      #
      # @param [Any] val Value to cast into integer
      #
      # @return [Integer] Casted value
      #
      def cast_to_int(val)
        return 0 if !val || val == ""
        return Integer(val)
      end

      #
      # Convert value to Float value if format match.
      # nil and empty string returns 0.0 other value are converted with
      # Float(val) command if value is not convertible raise an argument Error
      # Only to use if val is NOT a BigDecimal or should results in one
      #
      # @param [Any] val Value to cast into float
      #
      # @return [Float] Casted value
      #
      def cast_to_float(val)
        return 0.0 if !val || val == ""
        return Float( (val.is_a?(String)) ? val.tr(",", ".") : val )
      end

    end
  end
end
