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

      additionnal_args = nil
      lookup_module_name = "ActiveStripper::Helpers"

      if operator_args
        additionnal_args = operator_args[:additionnal_args]
        lookup_module_name = operator_args[:module] if operator_args[:module]
      end

      val = ActiveStripper.method_apply(val,
                                        operator_name,
                                        base,
                                        lookup_module_name,
                                        additionnal_args)
    end

    return val
  end

  #
  # Look up for method `operator` in ActiveStripper::Helpers THEN in current
  # class if not found and call it
  #
  # @param [String] val         Value to modify
  # @param [Symbol] operator    Method name to execute
  # @param [Object] base        Instance including the current module
  # @param [String] module_name Name of the module where we are going to lookup
  #                             a method which name is contained in `operator`
  #                             if equal to EMPTY STRING the lookup context will
  #                             be the object passed through `base`
  # @param [Array]  args        (Optional)
  #                             Additionnal args to pass to the processor method
  #
  # @return [String] Processed val if possible otherwise return val is it was
  #
  def self.method_apply(val, operator, base, module_name, args = nil)
    lookup_module = (module_name == "") ? base : Module.const_get(module_name)

    case
    when operator.class.name === "Proc"
      operator.call(val, *args)
    when lookup_module.respond_to?(operator)
      lookup_module.send(operator, val, *args)
    when lookup_module != base && base.respond_to?(operator)
      base.send(operator, val, *args)
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
      # self is equal to the object where the current method is called
      mod = Module.new do
        args.each do | field |
          define_method :"#{field}=" do | val |
            val = case operator.class.name
                  when "Proc"
                    operator.call(val)
                  when "Hash", "Array"
                    ActiveStripper.iterable_apply(val, operator, self)
                  when "String", "Symbol"
                    ActiveStripper.method_apply(val,
                                                operator,
                                                self,
                                                "ActiveStripper::Helpers")
                  end

            super(val)
          end
        end
      end

      prepend mod
    end
  end
end
