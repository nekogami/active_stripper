require 'spec_helper'

describe ActiveStripper::Helpers do
  before { stub_const("TEST_STRING", "    Test  String  ") }

  describe "#white_space_stripper('    Test  String  ')" do
    it { expect(ActiveStripper::Helpers.white_space_stripper(TEST_STRING)).to eql TEST_STRING.strip }
  end

  describe "#multiple_space_stripper('    Test  String  ')" do
    it { expect(ActiveStripper::Helpers.multiple_space_stripper(TEST_STRING)).to eql TEST_STRING.gsub(/\s+/, " ") }
  end

  describe "#end_space_stripper('    Test  String  ')" do
    it { expect(ActiveStripper::Helpers.end_space_stripper(TEST_STRING)).to eql TEST_STRING.gsub(/\s+$/, "") }
  end

  describe "#start_space_stripper('    Test  String  ')" do
    it { expect(ActiveStripper::Helpers.start_space_stripper(TEST_STRING)).to eql TEST_STRING.gsub(/^\s+/, "") }
  end

  describe "#to_lower_stripper('    Test  String  ')" do
    it { expect(ActiveStripper::Helpers.to_lower_stripper(TEST_STRING)).to eql TEST_STRING.downcase }
  end

  describe "#empty_string_to_nil('')" do
    it { expect(ActiveStripper::Helpers.empty_string_to_nil('')).to be_nil }
  end

  describe "#empty_string_to_nil('    Test  String  ')" do
    it { expect(ActiveStripper::Helpers.empty_string_to_nil("    Test  String  ")).to eql "    Test  String  " }
  end

  describe "#cast_to_int('')" do
    it { expect(ActiveStripper::Helpers.cast_to_int('')).to eql 0 }
  end

  describe "#cast_to_int(nil)" do
    it { expect(ActiveStripper::Helpers.cast_to_int(nil)).to eql 0 }
  end

  describe "#cast_to_int('4242')" do
    it { expect(ActiveStripper::Helpers.cast_to_int('4242')).to eql 4242 }
  end

  describe "#cast_to_int('4242NOPE')" do
    it { expect { ActiveStripper::Helpers.cast_to_int('4242NOPE') }.to raise_error(ArgumentError) }
  end

  describe "#cast_to_float('')" do
    it { expect(ActiveStripper::Helpers.cast_to_float('')).to eql 0.0 }
  end

  describe "#cast_to_float(nil)" do
    it { expect(ActiveStripper::Helpers.cast_to_float(nil)).to eql 0.0 }
  end

  describe "#cast_to_float('42.42')" do
    it { expect(ActiveStripper::Helpers.cast_to_float('42.42')).to eql 42.42 }
  end

  describe "#cast_to_float('42,42')" do
    it { expect(ActiveStripper::Helpers.cast_to_float('42,42')).to eql 42.42 }
  end

  describe "#cast_to_float('42.42NOPE')" do
    it { expect { ActiveStripper::Helpers.cast_to_float('42.42NOPE') }.to raise_error(ArgumentError) }
  end

end
