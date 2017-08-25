require 'spec_helper'

describe ActiveStripper do

  before do
    stub_const("TEST_STRING", "    Test  String  ")
    stub_const("Bar", Class.new)
    Bar.class_eval do
      include ActiveStripper

      attr_accessor :test_accessor
    end
  end

  describe "#strip_value_from" do
    let(:foo) do
      foo = Bar.new
      foo.test_accessor = TEST_STRING
      foo
    end

    context "#strip_value_from(:test_accessor, :to_lower_stripper) execution make it so that" do
      before do
        Bar.class_eval do
          strip_value_from(:test_accessor, :to_lower_stripper)
        end
      end

      context "#test_accessor" do
        it { expect(foo.test_accessor).to eql foo.test_accessor.downcase }
      end
    end

    context "#strip_value_from(:test_accessor, [:to_lower_stripper, :white_space_stripper]) execution make it so that" do
      before do
        Bar.class_eval do
          strip_value_from(:test_accessor, [:to_lower_stripper, :white_space_stripper])
        end
      end

      context "#test_accessor" do
        it { expect(foo.test_accessor).to eql foo.test_accessor.downcase.strip }
      end
    end

    context "#strip_value_from(:test_accessor, processor: { module: :TestModule }) execution make it so that" do
      before do
        stub_const("CustomModule", Module.new)
        CustomModule.module_eval do
          def self.processor(val)
            return val.to_s + " curstom processor executed"
          end
        end

        Bar.class_eval do
          strip_value_from(:test_accessor, processor: { module: :CustomModule } )
        end
      end

      context "#test_accessor" do
        it { expect(foo.test_accessor).to eql CustomModule.processor(TEST_STRING) }
      end
    end

    context "#strip_value_from(:test_accessor, -> (val) { val + ' lambda processor' }) execution make it so that" do
      let(:lambda_method) { -> (val) { val + ' lambda processor' } }

      before do
        Bar.class_eval do
          strip_value_from(:test_accessor, -> (val) { val + ' lambda processor' })
        end
      end

      context "#test_accessor" do
        it { expect(foo.test_accessor).to eql lambda_method.call(TEST_STRING) }
      end
    end

    context "with custom setter defined in the class" do
      context "#strip_value_from(:test_accessor, :to_lower_stripper) execution make it so that" do
        before do
          Bar.class_eval do
            strip_value_from(:test_accessor, :to_lower_stripper)

            def test_accessor=(val)
              @test_accessor = val + " custom setter"
            end
          end
        end

        context "#test_accessor" do
          it { expect(foo.test_accessor).to eql TEST_STRING.downcase + " custom setter" }
        end
      end
    end
  end
end
