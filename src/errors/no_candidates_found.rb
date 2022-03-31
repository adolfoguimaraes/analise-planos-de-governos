class Errors::NoCandidatesFound < Errors::BaseError
  def initialize
    super('NoCandidatesFound', 'candidates_error')
  end
end
