# frozen_string_literal: true

require 'nokogiri'
include ActionView::Helpers::SanitizeHelper

class MedisyService
  def initialize(medisy)
    @medisy = medisy
  end

  def process_feed
    xml = HTTParty.get(@medisy.url).body
    doc = Nokogiri::XML(xml)
    doc.search('item').each do |item|
      medisys_feed = @medisy.medisys_feeds.find_or_initialize_by(title: item.at('title').text, medisy_id: @medisy.id)
      medisys_feed.update(feed_params(item)) if medisys_feed.new_record?
    end
  end

  private
    def feed_params(item)
      param = {
        title: item.at('title').text,
        link: item.at('link').text,
        keywords: item.at('description').text,
        pub_date: item.at('pubDate').text,
        guid: item.at('guid').text,
        medisy_id: @medisy.id,
        medisys_categories_attributes: item.search('category').map { |category| { name: category.text } },
        source_name: item.at('source').text,
        source_url: item.at('source').attributes['url'].value,
        medisys_country_id: get_country_id(item),
        program_id: @medisy.program_id
      }

      param = assign_description_content(item, param)
      param = assign_category_trigger(item, param)
      param
    end

    def assign_description_content(item, param)
      res = ExtractContentService.new.fetch(item.at('link').text)
      if res[:status] == :success
        param[:description] = strip_tags(res[:content])[0..300]
      else
        param[:fail_reason] = res[:content]
      end

      param
    end

    def assign_category_trigger(item, param)
      cate = item.search('category').select { |c| c.attributes['trigger'].present? }.first
      param[:category_trigger] = "[#{cate.text}]#{cate.attributes['trigger'].text}" if cate.present?
      param
    end

    def get_country_id(item)
      code = item.at('source').attributes['country'].value
      country = MedisysCountry.find_or_initialize_by(code: code)
      country.update(remote_image_url: "https://medisys.newsbrief.eu/medisys/web/flags/small/#{code}.gif") if country.new_record?
      country.id
    end
end
