class String
  def correct_filename_for_form_440?
    check = self.gsub(';', '').gsub(' ', '')
    ((/^\w{4}_\w{4}3510123_\w*.xml$/.match?(check.downcase) || /pb[12]_\w{4}3510123_\w*.xml$/.match?(check.downcase)) && check == self)
  end
end