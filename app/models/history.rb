class History < ApplicationRecord
  belongs_to :toy, inverse_of: :histories
  belongs_to :cat, inverse_of: :histories

  validates :toy, presence: true
  validates :cat, presence: true
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
end
