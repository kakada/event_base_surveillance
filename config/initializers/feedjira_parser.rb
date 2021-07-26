class Feedjira::Parser::RSSEntry
  element "georss:point", as: :geo_point
  element "iso:language", as: :iso_language
end
