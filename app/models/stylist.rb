class Stylist < ApplicationRecord
  has_many :appointments
  has_many :customers, through: :appointments
  
  validates :name, presence: true
  
  # Business hours
  OPENING_HOUR = 9
  CLOSING_HOUR = 18
  
  # Check availability for a specific time
  def available_at?(start_time, duration=60)
    return false unless business_hours?(start_time, duration)
    
    end_time = start_time + duration.minutes
    !appointments.where("(time < ? AND time + INTERVAL duration MINUTE > ?) OR (time > ? AND time < ?)",
                      end_time, start_time, start_time, end_time).exists?
  end
  
  # Find available time slots for a specific day
  def available_slots_on(date, duration=60)
    slots = []
  
    current_time = DateTime.new(date.year, date.month, date.day, OPENING_HOUR, 0, 0)
    end_of_day = DateTime.new(date.year, date.month, date.day, CLOSING_HOUR, 0, 0)
    
    while current_time + duration.minutes <= end_of_day
      slots << current_time if available_at?(current_time, duration)
      current_time += 30.minutes
    end
    
    slots
  end
  
  private
  
  def business_hours?(start_time, duration)
    end_time = start_time + duration.minutes
    
    # Check if appointment is during business hours
    start_time.hour.between?(OPENING_HOUR, CLOSING_HOUR-1) && 
      (end_time.hour < CLOSING_HOUR || (end_time.hour == CLOSING_HOUR && end_time.min == 0))
  end
end

