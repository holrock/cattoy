class History < ApplicationRecord
  belongs_to :toy, inverse_of: :histories
  belongs_to :cat, inverse_of: :histories

  validates :toy, presence: true
  validates :cat, presence: true, uniqueness: {scope: :toy, message: "already registered"}
  validates :rate, inclusion: { in: -1..1 }

  def self.votes
    result = connection.select_all(<<EOS)
select
  toy_id,
  sum(case rate when 1 then 1 else 0 end) as up,
  sum(case rate when -1 then 1 else 0 end) as down
from histories
group by toy_id
EOS

    {}.tap do |h|
      result.rows.each do |r|
        h[r[0]] = r
      end
    end
  end

  def to_uri
    RDF::URI.new("#{Const::RDF_HOST}/histories/#{id}")
  end

  def to_rdf
    graph = RDF::Graph.new
    graph << RDF::Statement.new(to_uri,
                                RDF::Vocab::SCHEMA.ratingValue,
                                rate)
    graph << RDF::Statement.new(to_uri,
                                RDF::Vocab::SCHEMA.reviewBody,
                                comment)
    graph << RDF::Statement.new(to_uri,
                                RDF::Vocab::SCHEMA.creator,
                                cat.to_uri)
    graph << RDF::Statement.new(to_uri,
                                RDF::Vocab::SCHEMA.itemReviewed,
                                toy.to_uri)
    graph
  end
end
