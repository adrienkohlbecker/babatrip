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

  def class_from_mood(mood)

    case mood
    when 'C' then :chic
    when 'N' then :normal
    when 'H' then :hippie
    end

  end

  def class_from_time(time)

    case time
    when 'A' then :allday
    when 'N' then :night
    when 'D' then :day
    end

  end

  def class_from_relationship(relationship)

    case relationship
    when 'S' then :single
    when 'R' then :couple
    end

  end

end
