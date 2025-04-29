class Appointment < ApplicationRecord
  belongs_to :customer
  belongs_to :stylist

  attribute :duration, :integer, default: 60
  attribute :status, :string, default: "scheduled"

  # basic
  validates :time, presence: true
  validates :duration, presence: true
  validates :status, inclusion: { in: ["scheduled", "completed", "cancelled"] }

  # custom 
  validate :appointment_time_in_future
  validate :during_business_hours
  validate :stylist_availability

  def appointment_time_in_future
    if time.present? && time < DateTime.now
      errors.add(:time, "must be in the future")
    end
  end

  def during_business_hours
    if time.present?
      chst_time = time.in_time_zone('Pacific/Guam')
      opening_hour = 9
      closing_hour = 18

      unless chst_time.hour.between?(opening_hour, closing_hour - 1)
        errors.add(:time, "must be during business hours (#{opening_hour}AM - #{closing_hour - 12}PM ChST)")
      end 
      
      # Check if the appointment would extend beyond business hours
      end_time = chst_time + duration.minutes
      if end_time.hour >= closing_hour || (end_time.hour == closing_hour && end_time.min > 0)
        errors.add(:time, "appointment would end after business hours")
      end
    end
  end
  
  def stylist_availability
    if stylist.present? && time.present?
      # Check for overlapping appointments
      end_time = time + duration.minutes
      overlapping_appointments = stylist.appointments
                                     .where.not(id: id) # Exclude this appointment when updating
                                     .where("status != 'cancelled'") # Ignore cancelled appointments
                                     .where("(time < ? AND time + (duration * interval '1 minute') > ?) OR (time > ? AND time < ?)",
                                            end_time, time, time, end_time)
      
      if overlapping_appointments.exists?
        errors.add(:time, "conflicts with an existing appointment for this stylist")
      end
    end
  end
  
  # Calculate end time
  def end_time
    time + duration.minutes
  end
  
  # For handling cancellations
  def cancel!
    update(status: 'cancelled')
  end
  
  # rescheduling
  def reschedule!(new_time)
    old_time = time
    if update(time: new_time)
      true
    else
      update(time: old_time) if errors.present?
      false
    end
  end
end

  

