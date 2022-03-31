require './src/main'

puts 'Init fetch candidates...'

Services::DownloadPdf.new

puts 'Downloaded all files'
