require 'open-uri'
require 'net/http'
require 'json'
require 'cgi'
require 'escape_utils'

FILE_ID_TYPE_SEARCH_PLAN_GOV = "5"

base_url = 'https://divulgacandcontas.tse.jus.br'
base_url_api = "#{base_url}/divulga/rest/v1"
candidates_path = '/candidatura/listar/2020/31054/2030402020/11/candidatos'
candidate_path = '/candidatura/buscar/2020/31054/2030402020/candidato/'

puts "Init fetch candidates..."

response = Net::HTTP.get(URI("#{base_url_api}#{candidates_path}"))
data = JSON.parse(response)

unless data["candidatos"]
  puts "Candidates not found"
  return;
end

puts "Candidates founded. Init search for download files..."

data["candidatos"].each do |candidate|
  candidate_id = candidate["id"]
  candidate_name = candidate["nomeUrna"]

  puts "Get file for candidate: #{candidate_name}"

  response = Net::HTTP.get(URI("#{base_url_api}#{candidate_path}#{candidate_id}"))
  candidate_data = JSON.parse(response)

  if candidate_data["arquivos"]
    government_plan = candidate_data["arquivos"].select {|file| file["codTipo"] == FILE_ID_TYPE_SEARCH_PLAN_GOV}
    government_plan = government_plan.first
    government_plan_name = URI.encode_www_form_component(government_plan["nome"]).gsub "+", "%20"

    file_url = "#{base_url}/#{government_plan["url"]}#{government_plan_name}"
    
    puts "Downloading governement plan for candidate: #{candidate_name}..."
    puts "URL: #{file_url}"

    File.open("assets/#{candidate_name}_#{candidate_id}.pdf", "wb") do |file|
      file.write URI.open(file_url).read
    end

    puts "Finished downloading candidate's governement plan..."
  end
end

puts "Downloaded all files"
