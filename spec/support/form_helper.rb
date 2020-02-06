module FormHelper

  def fill_in_form(inputs_hash)
    inputs_hash.each do |input, value|
      fill_in input, with: value
    end
  end

end