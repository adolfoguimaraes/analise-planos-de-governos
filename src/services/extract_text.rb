class Services::ExtractText
  def initialize
    search_files
  end

  private

  def search_files
    Dir[File.expand_path("../../assets/*.pdf", File.dirname(__FILE__))].each do |file|
      file_name = file.split('/').last.split('.').first
      reader = PDF::Reader.new(file)
      extract_text(file_name, reader)
    end
  end

  def extract_text(file_name, file_reader)
    data_save = {
      content: []
    }

    file_reader.pages.each do |page|
      data_save[:content].append({ page: page.number, text: page.text })
    end

    File.open("./files_parseds/#{file_name}.json", 'w') { |fo| fo.puts data_save.to_json }
  end
end
