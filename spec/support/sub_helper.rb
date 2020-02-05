module SubHelper

  def create_sub(sub_hash)
    sub_hash.each do |input, value|
      fill_in input, with: value
    end
    click_button "CREATE"
  end

end