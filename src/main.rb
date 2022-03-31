require 'open-uri'
require 'net/http'
require 'json'

dir_imports = ['errors', 'services']

dir_imports.each do |dir_import|
  require "./src/#{dir_import}/#{dir_import}.module"

  Dir[File.expand_path("./#{dir_import}/*.rb", File.dirname(__FILE__))].each do |file|
    require file
  end
end
