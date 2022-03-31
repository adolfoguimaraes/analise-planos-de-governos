class Services::DownloadPdf
  FILE_ID_TYPE_SEARCH_PLAN_GOV = '5'

  BASE_URL = 'https://divulgacandcontas.tse.jus.br'
  BASE_URL_API = "#{BASE_URL}/divulga/rest/v1"
  CANDIDATES_PATH = '/candidatura/listar/2020/31054/2030402020/11/candidatos'
  CANDIDATE_PATH = '/candidatura/buscar/2020/31054/2030402020/candidato/'

  def initialize
    get_candidate
    process_candidates
  end

  private

  def get_candidate
    response = Net::HTTP.get(URI("#{BASE_URL_API}#{CANDIDATES_PATH}"))
    @cadidates_data = JSON.parse(response)

    raise Errors::NoCandidatesFound.new unless @cadidates_data['candidatos']
  end

  def process_candidates
    @cadidates_data['candidatos'].each do |candidate|
      download_candidate_document(candidate)
    end
  end

  def download_candidate_document(candidate)
    candidate_id = candidate['id']
    candidate_name = candidate['nomeUrna']

    puts "Get file for candidate: #{candidate_name}"

    response = Net::HTTP.get(URI("#{BASE_URL_API}#{CANDIDATE_PATH}#{candidate_id}"))
    candidate_data = JSON.parse(response)

    if candidate_data['arquivos']
      government_plan = candidate_data['arquivos'].select { |file| file['codTipo'] == FILE_ID_TYPE_SEARCH_PLAN_GOV }
      government_plan = government_plan.first
      government_plan_name = URI.encode_www_form_component(government_plan['nome']).gsub '+', '%20'

      file_url = "#{BASE_URL}/#{government_plan['url']}#{government_plan_name}"

      puts "Downloading governement plan for candidate: #{candidate_name}..."
      puts "URL: #{file_url}"

      File.open("assets/#{candidate_name}_#{candidate_id}.pdf", 'wb') do |file|
        file.write URI.open(file_url).read
      end

      puts "Finished downloading candidate's governement plan..."
    end
  end
end
