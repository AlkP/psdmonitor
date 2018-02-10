class RegulationsController < ApplicationController
  def dashboards
    filter = params['day'].present? ? params['day']&.to_i : 7
    @dates = ((Time.now - filter.days).to_date..Time.now.to_date).to_a
    files = Tfile.per_days(filter)
    @f311_in_files  = @dates.collect { |x| files.form_311_in.count_by_date[x] }
    @f311_out_files = @dates.collect { |x| files.form_311_out.count_by_date[x] }
    @f440_in_files  = @dates.collect { |x| files.form_440_in.count_by_date[x] }
    @f440_out_files = @dates.collect { |x| files.form_440_out.count_by_date[x] }
  end
end
