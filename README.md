# active_stripper

Small gem that allow preprocessing of field (remove emoji, strip...) by creating prepended custom setters.

This allows preprocessing of attributes before a custom accessor declared inside the class body is called

Only works on ruby 2.x since the prepend instruction is used.

Named active_stripper for search purposes (that and because I <3 pun) but doesn't have any dependencies (ActiveSupport or otherwise) and can be used any attr_accessor in any class.

It defines setter methods but you can still use your owns in the class definition, the one generated from the gem will be called last though.

## STATUS
[![Build Status](https://travis-ci.org/nekogami/active_stripper.svg?branch=master)](https://travis-ci.org/nekogami/active_stripper)

## Install
The gem is not pushed on rubygem.org since the tests are not written yet so for now

In your gemfile
```gem 'active_stripper', github: "nekogami/active_stripper"```

## Helpers listing

You can find basic available helpers [here](https://github.com/nekogami/active_stripper/blob/master/lib/active_stripper/helpers.rb)
If you want a new one added in the library, please, feel free to open an issue.


## Usage

### Syntax
After the call to include, you can use the gem in the following ways

```ruby
# will look up the method #processor_method in ActiveStripper::Helpers
# if inexistent, will look up in the current object for it
# then apply it on all listed fields
strip_value_from : field1, field2, field3, :processor_method
```

```ruby
# Will apply all processor method in the declaration order on all listed fields
# The processors are executed in the same order as defined in the array (left to right)
strip_value_from : field1, field2, field3, [:processor_method, :processor_method2]
```

```ruby
# Will lookup processor_method in the module ModuleName, for application on all fields
# processor_method2 is looked up in ActiveStripper::Helpers first and
# then in the current object if not found
strip_value_from : field1, field2, field3, { processor_method: { module: :ModuleName }, processor_method2: nil }
```

```ruby
# The processor here are executed in the inverse order of declaration (bottom to top)
strip_value_from : field1, :processor_method2
strip_value_from : field1, :processor_method
```

### Active record
```ruby
class Foo < ActiveRecord::Base
  # contain field named text_field

  include ActiveStripper

  strip_value_from :text_field, [:to_lower_stripper, :white_space_stripper]


  def text_field=(val)
    super(val + " in class definition custom overwrite")
  end
end

foo = Foo.new(text_field: "   HeLLo WhitespacEEEs          \t")
foo.text_field => "hello whitespaceees in class definition custom overwrite"

foo = Foo.new
foo.text_field = "   HeLLo WhitespacEEEs          \t"
foo.text_field => "hello whitespaceees in class definition custom overwrite"

# Advantage here is that the processed value is visible without executing a hook like before_validation etc etc
```
