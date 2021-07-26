require 'open-uri'
require 'readability'

class ExtractContentService
  def fetch(url)
    source = open(url).read
    Readability::Document.new(source).content
  end
end
