require 'open-uri'
require 'readability'

class ExtractContentService
  def fetch(url)
    return read_from_pdf(url) if url.match(/.pdf$/).present?

    source = open(url).read
    Readability::Document.new(source).content
  end

  private
    def read_from_pdf(url)
      io = open(url)
      reader = PDF::Reader.new(io)
      reader.pages.first.text
    end
end
