require 'pdf/reader'
require 'open-uri'

# reader = PDF::Reader.new("assets/teste.pdf")
io = open('https://eppg.fgv.br/sites/default/files/teste.pdf')
reader = PDF::Reader.new(io)

puts reader.pdf_version
puts reader.info
puts reader.metadata
puts reader.page_count

reader.pages.each do |page|
  # puts page.fonts
  puts page.text
  # puts page.raw_content
end
