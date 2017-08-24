#coding: utf-8

require "active_stripper/version"
require "active_stripper/helpers"

module ActiveStripper # Pun intended

  def self.included(base)
    base.extend(ClassMethods)
  end

  #
  # Iterate over `iterable_operators` and apply each of them on `val`
  #
  # @param [String] val String to manipulate
  # @param [Hash/Array] iterable_operators Methods details to use on `val`
  # @param [Object] base Instance including the current module
  #
  # @return [String] Modified String
  #
  def self.iterable_apply(val, iterable_operators, base)
    iterable_operators.each do | operator_name, operator_args |

      val = case
            when !operator_args
              ActiveStripper.method_apply(val, operator_name, base)
            when operator_args[:module]
              Module.const_get(operator_args[:module])
                    .send(operator_name, val)
            end
    end

    return val
  end

  #
  # Look up for method `operator` in ActiveStripper::Helpers and current
  # class and call it
  #
  # @param [String] val Value to modify
  # @param [String/Symbol] operator Method name to execute
  # @param [Object] base Instance including the current module
  #
  # @return [String] Modifies value
  #
  def self.method_apply(val, operator, base)
    case
    when operator.class.name === "Proc"
      operator.call(val)
    when ActiveStripper::Helpers.respond_to?(operator)
      ActiveStripper::Helpers.send(operator, val)
    when base.respond_to?(operator)
      base.send(operator, val)
    else
      val
    end
  end

  module ClassMethods

    #
    # Helper to use in your Class
    #
    # @param [Array<Any>] *args List of attributes to use for setter generation
    #                           Length must be > 2,
    #                           last argument is the preprocessor to run on value
    #
    def strip_value_from(*args)
      raise if args.count < 2
      operator = args.pop

      args = args.reject { | field | self.respond_to?(field) }

      # Dynamically generate an anonymous module to be prepended
      mod = Module.new do
        args.each do | field |

          define_method :"#{field}=" do | val |
            val = case operator.class.name
                  when "Proc"
                    operator.call(val)
                  when "Hash", "Array"
                    ActiveStripper.iterable_apply(val, operator, self)
                  when "String", "Symbol"
                    ActiveStripper.method_apply(val, operator, self)
                  end

            super(val)
          end
        end
      end

      prepend mod
    end
  end
end
