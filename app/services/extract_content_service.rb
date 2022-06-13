# frozen_string_literal: true

require "open-uri"
require "readability"

class ExtractContentService
  def fetch(url)
    content = url.match(/.pdf$/).present? ? read_from_pdf(url) : read_from_link(url)

    { status: :success, content: content }
  rescue Exception => e
    { status: :failure, content: e.message }
  end

  private
    def read_from_pdf(url)
      reader = PDF::Reader.new(open(url))
      reader.pages.first.text
    end

    def read_from_link(url)
      source = open(url).read
      Readability::Document.new(source).content
    end
end
