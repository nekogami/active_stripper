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

  context "When included in an subclass" do
    context "For String manipulation" do
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

    context "For Integer/Float represented in string manipulation" do
      context "#strip_value_from(:test_accessor, :cast_to_int) execution make it so that" do
        before { stub_const("TEST_STRING_INT", "1241421") }

        let(:foo) do
          Bar.class_eval do
            strip_value_from(:test_accessor, :cast_to_int)
          end

          foo = Bar.new
          foo.test_accessor = TEST_STRING_INT
          foo
        end

        context "#test_accessor" do
          it { expect(foo.test_accessor).to eql Integer(TEST_STRING_INT) }
        end

        context "Setting test_accessor to an empty string" do
          before { foo.test_accessor = "" }
          it { expect(foo.test_accessor).to eql 0 }
        end

        context "Setting test_accessor to nil" do
          before { foo.test_accessor = nil }
          it { expect(foo.test_accessor).to eql 0 }
        end

        context "Setting a string not representing an valid Integer like `4242NOPE`" do
          it { expect { foo.test_accessor = "4242NOPE" }.to raise_error(ArgumentError) }
        end
      end

      context "#strip_value_from(:test_accessor, :cast_to_float) execution make it so that" do
        before { stub_const("TEST_STRING_FLOAT", "1241.421") }

        let(:foo) do
          Bar.class_eval do
            strip_value_from(:test_accessor, :cast_to_float)
          end

          foo = Bar.new
          foo.test_accessor = TEST_STRING_FLOAT
          foo
        end

        context "#test_accessor" do
          it { expect(foo.test_accessor).to eql Float(TEST_STRING_FLOAT) }
        end

        context "Setting test_accessor to an empty string" do
          before { foo.test_accessor = "" }
          it { expect(foo.test_accessor).to eql 0.0 }
        end

        context "Setting test_accessor to nil" do
          before { foo.test_accessor = nil }
          it { expect(foo.test_accessor).to eql 0.0 }
        end

        context "Setting a string not representing an valid Float like `42.42NOPE`" do
          it { expect { foo.test_accessor = "42.42NOPE" }.to raise_error(ArgumentError) }
        end
      end
    end
  end
end
