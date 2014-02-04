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
    when 'Chic' then :chic
    when 'Cool' then :cool
    when 'Hippie' then :hippie
    end

  end

  def class_from_time(time)

    case time
    when 'All day' then :allday
    when 'Night' then :night
    when 'Day' then :day
    end

  end

  def class_from_relationship(relationship)

    case relationship
    when 'Single' then :single
    when 'In a relationship' then :couple
    end

  end

  def class_from_relationship_and_sex(user, current_user)

    if user.is_a_friend_of?(current_user) or user.is_a_friend_of_friend_of?(current_user)
      return :blue
    else
      if user.male?
        return :green
      else
        return :red
      end
    end

  end

end
