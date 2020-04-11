seeds = <<-EOF
[{"hours":{"mon_1_open":"09:00","mon_1_close":"19:00","tue_1_open":"09:00","tue_1_close":"19:00","wed_1_open":"09:00","wed_1_close":"19:00","thu_1_open":"09:00","thu_1_close":"19:00","fri_1_open":"09:00","fri_1_close":"19:00","sat_1_open":"09:00","sat_1_close":"19:00","sun_1_open":"09:00","sun_1_close":"19:00"},"name":"The Original One  -T O O","id":"179922965524483"},{"hours":{"mon_1_open":"09:00","mon_1_close":"21:30","tue_1_open":"09:00","tue_1_close":"21:30","wed_1_open":"09:00","wed_1_close":"21:30","thu_1_open":"09:00","thu_1_close":"21:30","fri_1_open":"09:00","fri_1_close":"21:30","sat_1_open":"09:00","sat_1_close":"21:30","sun_1_open":"09:00","sun_1_close":"21:30"},"name":"Sarabeth's","id":"705010796303624"},{"hours":{"mon_1_open":"11:00","mon_1_close":"20:00","thu_1_open":"11:00","thu_1_close":"20:00","fri_1_open":"11:00","fri_1_close":"20:00","sat_1_open":"11:00","sat_1_close":"20:00","sun_1_open":"11:00","sun_1_close":"20:00"},"name":"Korea restaurant","id":"1410998442505941"},{"hours":{"mon_1_open":"06:00","mon_1_close":"13:30","tue_1_open":"06:00","tue_1_close":"13:30","wed_1_open":"06:00","wed_1_close":"13:30","thu_1_open":"06:00","thu_1_close":"13:30","fri_1_open":"06:00","fri_1_close":"13:30","sat_1_open":"06:00","sat_1_close":"13:30","sun_1_open":"06:00","sun_1_close":"13:30"},"name":"Breakfast","id":"763422743712620"},{"hours":{"mon_1_open":"14:30","mon_1_close":"22:00","tue_1_open":"14:30","tue_1_close":"22:00","wed_1_open":"14:30","wed_1_close":"22:00","thu_1_open":"14:30","thu_1_close":"22:00","fri_1_open":"14:30","fri_1_close":"22:00","sat_1_open":"13:30","sat_1_close":"22:00","sun_1_open":"13:30","sun_1_close":"21:00"},"name":"Fruit store","id":"174279569299857"},{"hours":{"mon_1_open":"17:30","mon_1_close":"11:30","tue_1_open":"17:30","tue_1_close":"11:30","wed_1_open":"17:30","wed_1_close":"11:30","thu_1_open":"17:30","thu_1_close":"11:30","fri_1_open":"17:30","fri_1_close":"11:30","sat_1_open":"15:30","sat_1_close":"12:00","sun_1_open":"15:30","sun_1_close":"12:00"},"name":"Toast","id":"937482469595802"}]
EOF

restaurants = JSON.parse(seeds)

restaurants.each do |data|
  r = Restaurant.new(name: data["name"])

  # The format is:
  #   {1 => {"open" => "0010", "close" => "1200"}, ...}
  weekday_hours = {}

  data["hours"].each do |key, value|
    wday, _, state = key.split('_')
    t = value.delete(":")

    wday = case wday
           when 'mon' then 0
           when 'tue' then 1
           when 'wed' then 2
           when 'thu' then 3
           when 'fri' then 4
           when 'sat' then 5
           when 'sun' then 6
           end

    weekday_hours[wday] ||= {}
    weekday_hours[wday][state] = t
  end

  # Now, we need to handle open > end case
  # The format is:
  #   {1 => [{"open" => "0000", "close" => "1200"}, {"open" => "1400", "close" => "1800"}], ...}
  tmp = {}
  weekday_hours.each do |wday, hours|
    tmp[wday] ||= []
    if hours["open"] > hours["close"]
      next_day = (wday + 1) % 7
      tmp[wday] << {"open" => hours["open"], "close" => "2400"}
      tmp[next_day] ||= []
      tmp[next_day] << {"open" => "0000", "close" => hours["close"]}
    else
      tmp[wday] << {"open" => hours["open"], "close" => hours["close"]}
    end
  end
  weekday_hours = tmp

  # TODO: We may need to those with the same open/close time pair
  weekday_hours.each do |wday, series|
    series.each do |hours|
      r.periods << Period.new(weekdays: [wday], hour_start: hours["open"], hour_end: hours["close"])
    end
  end

  r.save!
end
