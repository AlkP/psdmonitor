class CbRate < ApplicationRecord
  belongs_to :currency, foreign_key: :currency_id

  validates :currency_id, :date, :scale, :course, presence: true
end
