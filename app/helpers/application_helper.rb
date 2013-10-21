module ApplicationHelper

  def nationality_select_collection

    data = []
    Country.all do |country|
      nationality = country[1]['nationality']
      next if nationality.nil? or nationality.empty?
      data << [nationality, nationality]
    end

    data.sort_by {|elt| elt[0] }.uniq { |elt| elt[0]}

  end

end
