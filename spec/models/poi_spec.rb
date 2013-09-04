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
      expect(@big_ben.nearest).to eq(@tower_bridge)
    end
  end
end
