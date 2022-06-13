# frozen_string_literal: true

require "rails_helper"

RSpec.describe MedisysFeed, type: :model do
  it { is_expected.to belong_to(:medisy) }
  it { is_expected.to belong_to(:medisys_country) }
  it { is_expected.to have_many(:medisys_feeds_categories) }
  it { is_expected.to have_many(:medisys_categories).through(:medisys_feeds_categories) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:link) }

  describe "#medisys_categories_attributes" do
    context "exist category" do
      let!(:medisys_category) { create(:medisys_category, name: "ABC") }
      let!(:medisys_feed) { create(:medisys_feed, title: "example", link: "http://example.com", medisys_categories_attributes: [{ name: "ABC" }]) }

      it { expect(medisys_feed.medisys_categories).to include(medisys_category) }
      it { expect(medisys_feed.medisys_categories.length).to eq(1) }
      it { expect(MedisysCategory.count).to eq(1) }
    end

    context "new category and duplicate" do
      let!(:medisys_category) { create(:medisys_category, name: "ABC") }
      let!(:medisys_feed) { create(:medisys_feed, title: "example", link: "http://example.com", medisys_categories_attributes: [{ name: "DEF" }, { name: "DEF" }]) }

      it { expect(medisys_feed.medisys_categories.length).to eq(1) }
      it { expect(medisys_feed.medisys_categories.last.name).to eq("DEF") }
      it { expect(MedisysCategory.count).to eq(2) }
    end
  end
end
