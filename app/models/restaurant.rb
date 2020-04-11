class Restaurant < ApplicationRecord
  has_many :periods, dependent: :destroy

  scope :open_at, ->(t) do
    wday, hhmm = to_wday_time(t)

    joins(:periods)
      .where("?=ANY(periods.weekdays)", wday)
      .where("periods.hour_start <= ? and periods.hour_end >= ?", hhmm, hhmm)
      .distinct
  end

  scope :close_at, ->(t) do
    wday, hhmm = to_wday_time(t)

    join_clasue = ActiveRecord::Base.sanitize_sql([
      "left join periods on
        periods.restaurant_id = restaurants.id and
        ?=ANY(periods.weekdays) and
        periods.hour_start <= ? and periods.hour_end >= ?",
       wday, hhmm, hhmm
    ])

    joins(join_clasue)
      .where(periods: {id: nil})
      .distinct
  end

  private

  # A utility method to separate TimeWithZone to wday and hhmm
  # It also convert the time to UTC timezone
  def self.to_wday_time(t)
    t = t.in_time_zone('UTC')

    wday = t.wday
    hhmm = t.to_s(:hhmm)

    [wday, hhmm]
  end
end
