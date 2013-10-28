module HomeHelper

  def arriving_date_options

    data = []
    date = Time.now
    12.times do
      data << [date.strftime("%Y%m01"), date.strftime('%B %Y')]
      date = date.next_month
    end

    data

  end


  def leaving_date_options

    data = []
    date = Time.now
    12.times do
      date = (Date.new(date.year, date.month) >> 1) - 1 # last day of the month
      data << [date.strftime("%Y%m%d"), date.strftime('%B %Y')]
      date = date.next_month
    end

    data

  end

end
