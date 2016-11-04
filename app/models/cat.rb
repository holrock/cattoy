class Cat < ApplicationRecord
  belongs_to :user, inverse_of: :cats
  has_many :histories, dependent: :destroy, inverse_of: :cat
  validates :name, presence: true

  def to_uri
    RDF::URI.new("#{Const::RDF_HOST}/cats/#{id}")
  end


  def to_rdf
    graph = RDF::Graph.new
    graph << RDF::Statement.new(to_uri,
                                RDF::Vocab::SCHEMA.name,
                                name)
    histories.each do |history|
      graph << history.to_rdf
    end
    graph
  end
end
