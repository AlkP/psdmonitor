class Tfile < ApplicationRecord
  # default_scope { order(date: :asc, time: :asc) }
  scope :per_days, -> (day) { where('date >= ? ', Time.now - day.days) }
  scope :form_311_in, -> { where('name like ?', 'S[FB][FPRE]__3510123%xml') }
  scope :form_311_out, -> { where('name like ?', 'S[FB]C__3510123%xml') }
  scope :form_440_in, -> { where('name like ? or name like ?',
                                  'KWTFCB[_]PB_[_]____3510123%',
                                  '____3510123%[_]____________[_]______.vrb') }
  scope :form_440_out, -> { where('name like ? or name like ? or name like ?',
                                  'PB1[_]____3510123%',
                                  'PB2[_]____3510123%',
                                  '____[_]____3510123%') }
  scope :count_by_date, -> { group(:date).count }
end
