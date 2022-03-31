require './src/main'

puts 'Init fetch files...'

Services::ExtractText.new

puts 'Extracted text of all files'
