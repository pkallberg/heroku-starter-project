require "spec_helper"

describe Poi do
  describe "longitude and latitude" do
    before(:each) do
      @big_ben = FactoryGirl.create :poi
    end
    it "correctly returns longitude" do
      expect(@big_ben.lon).to eq(FactoryGirl.attributes_for(:poi)[:lon])
    end
    it "correctly returns latitude" do
      expect(@big_ben.lat).to eq(FactoryGirl.attributes_for(:poi)[:lat])
    end
  end

  describe "#nearest" do
    before(:each) do
      @big_ben = FactoryGirl.create :poi
      @tower_bridge = FactoryGirl.create :tower_bridge
      @eiffel_tower = FactoryGirl.create :eiffel_tower
      @pantheon = FactoryGirl.create :pantheon
    end
    it "returns its nearest neighbour" do
      expect(@tower_bridge.nearest).to eq([@big_ben])
      expect(@pantheon.nearest).to eq([@eiffel_tower])
    end
    it "returns its x nearest neighbours" do
      expect(@tower_bridge.nearest 2).to eq([@big_ben, @eiffel_tower])
    end
  end
end
