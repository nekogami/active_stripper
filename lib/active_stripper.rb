require "active_stripper/version"
require "active_stripper/helpers"

module ActiveStripper # Pun intended

  def self.included(base)
    base.extend(ClassMethods)
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

      # Dynamically generate an anonymous module to be prepended
      mod = Module.new do
        args.each do | field |
          return if !respond_to?(:"#{field}=")

          define_method :"#{field}=" do | val |

            return  case operator.class
                    when Proc
                      operator.call(super(val))
                    when Hash, Array
                      iterable_apply(super(val), operator)
                    when String, Symbol
                      method_apply(super(val), operator)
                    end

          end
        end
      end

      prepend mod
    end

    def iterable_apply(val, iterable_operators)
      iterable_operators.each do | operator_name, operator_args |

        val = case
              when !operator_args
                method_apply(val, operator_name)
              when operator_args[:module]
                operator_args[:module].send(operator_name, val)
              end
      end

      return val
    end

    def method_apply(val, operator)
      case
      when ActiveStripper::Helpers.respond_to?(operator)
        ActiveStripper::Helpers.send(operator, val)
      when respond_to?(operator)
        send(operator, val)
      else
        val
      end
    end

  end
end
