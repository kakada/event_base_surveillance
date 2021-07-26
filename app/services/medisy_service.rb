include ActionView::Helpers::SanitizeHelper

class MedisyService
  def initialize(medisy)
    @medisy = medisy
  end

  def process_feed
    xml = HTTParty.get(@medisy.url).body
    feed = Feedjira.parse(xml)

    feed.entries.each do |entry|
      medisys_feed = MedisysFeed.find_or_initialize_by(title: entry.title, medisy_id: @medisy.id)
      medisys_feed.update(feed_params(entry)) if medisys_feed.new_record?
    end
  end

  private
    # @Todo: extract content should validate request format: pdf
    def feed_params(entry)
      {
        title: entry.title,
        link: entry.url,
        description: strip_tags(ExtractContentService.new.fetch(entry.url))[0..254],
        keywords: entry.summary,
        pub_date: entry.published,
        guid: entry.entry_id,
        georss_point: entry.geo_point,
        iso_language: entry.iso_language,
        medisy_id: @medisy.id,
        medisys_categories_attributes: entry.categories.map {|category| { name: category } }
      }
    end
end
