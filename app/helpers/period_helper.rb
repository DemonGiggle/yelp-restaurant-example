module PeriodHelper
  def periods_in_human_readable_form(restaurant, limit: nil)
    if restaurant.periods.blank?
      "No periods found"
    else
      formated=restaurant.periods.map do |p|
        wdays = p.weekdays.map do |w|
          weekday_to_human_readable_form(w)
        end.join(" ")

        "Weekday: #{wdays}<br>(UTC) Open: #{p.hour_start} Close: #{p.hour_end}"
      end

      str= if limit.present?
             formated.take(limit) << "... more"
           else
             formated
           end.join("<br>")

      sanitize str
    end
  end

  def weekday_to_human_readable_form(wday)
    mapping = {
      0 => "Sun",
      1 => "Mon",
      2 => "Tue",
      3 => "Wed",
      4 => "Thu",
      5 => "Fri",
      6 => "Sat",
    }
    mapping[wday]
  end
end
