class Period < ApplicationRecord
  belongs_to :restaurant

  validate :weekday_value_validation
  validate :hour_start_should_be_smaller_than_end

  before_save :sort_weekdays

  private

  def sort_weekdays
    weekdays.sort!
  end

  def weekday_value_validation
    if v=weekdays.find{|x| x < 0 || x > 6}
      errors.add(:weekdays, "weekdays contain invalid value: #{v}")
    end
  end

  def hour_start_should_be_smaller_than_end
    if hour_start >= hour_end
      errors.add(:hour, "hour start(#{hour_start}) should be smaller than end(#{hour_end})")
    end
  end
end
