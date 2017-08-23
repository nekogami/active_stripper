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
    it { expect(ActiveStripper::Helpers.empty_string_to_nil('')).to be_nil }
  end

end
