class Stylist < ApplicationRecord
  has_many :appointments
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def available_slots(date, duration)
    start_time = date.in_time_zone('Pacific/Guam').change(hour: 9, min: 0)
    end_time = date.in_time_zone('Pacific/Guam').change(hour: 18, min: 0)

    slots = []
    current_time = start_time
    while current_time + duration.minutes <= end_time
      slots << current_time
      current_time += 30.minutes
    end

    booked_slots = appointments
      .where(time: date.beginning_of_day..date.end_of_day, status: ['scheduled', 'completed'])
      .pluck(:time, :duration)
      .map { |time, dur| [time.in_time_zone('Pacific/Guam'), dur] }

    slots.reject do |slot|
      booked_slots.any? do |booked_time, booked_duration|
        booked_end = booked_time + booked_duration.minutes
        slot_end = slot + duration.minutes
        (slot >= booked_time && slot < booked_end) || 
        (slot_end > booked_time && slot_end <= booked_end) ||
        (slot <= booked_time && slot_end >= booked_end)
      end
    end.map { |slot| slot.iso8601 }
  end
end

