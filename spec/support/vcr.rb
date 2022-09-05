# frozen_string_literal: true

require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join("spec/fixtures/vcr")
  config.hook_into :webmock

  config.filter_sensitive_data("<MBDS_BASE_URI>") { ENV["MBDS_BASE_URI"] }
  config.filter_sensitive_data("<MBDS_USERNAME>") { ENV["MBDS_USERNAME"] }
  config.filter_sensitive_data("<MBDS_PASSWORD>") { ENV["MBDS_PASSWORD"] }
end

RSpec.configure do |config|
  # Add VCR to all tests
  config.around(:each) do |example|
    vcr_tag = example.metadata[:vcr]

    if vcr_tag == false
      VCR.turned_off(&example)
    else
      options = vcr_tag.is_a?(Hash) ? vcr_tag : {}
      path_data = [example.metadata[:description]]
      parent = example.example_group
      while parent != RSpec::ExampleGroups
        path_data << parent.metadata[:description]
        # Newer versions of rspec may require you to use module_parent instead
        # parent = parent.module_parent
        parent = parent.parent
      end

      name = path_data.map { |str| str.underscore.gsub(/\./, "").gsub(/[^\w\/]+/, "_").gsub(/\/$/, "") }.reverse.join("/")

      VCR.use_cassette(name, options, &example)
    end
  end
end
