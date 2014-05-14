class Location < ActiveRecord::Base
  require 'date'

  belongs_to :company
  has_many :location_hours
  accepts_nested_attributes_for :location_hours, :reject_if => :all_blank
  has_many :appointments

  # format city, state for convenience
  def citystate
    @cs = ''

    if !self.city.nil?
      @cs += self.city
    end

    if @cs.length && !self.state.nil?
      @cs += ', '
    end

    if !self.state.nil?
      @cs += self.state
    end
    return @cs
  end

  def hoursOpen(datestring)
    # determine day_of_week from date
    @dateRequested = DateTime.strptime(datestring,'%m/%d/%Y')
    # determine day_of_week_id from date
    @day_of_week_id = @dateRequested.to_time.wday
    # convert day of week integer [0..6] to string
    @day_of_week = LocationHour::DAYS[@day_of_week_id]
    # get open and close hours
    @location_hours = self.location_hours.where day_of_week: @day_of_week

    return @location_hours
  end

  def timesOpen(datestring)
    # get open hours in 30 minute timeslots
    @location_hours = self.hoursOpen(datestring)
    @open_string = datestring + ' ' + @location_hours[0].open
    @close_string = datestring + ' ' + @location_hours[0].close
    puts "************ LOCATION HOURS " + @open_string + " - " + @close_string
    @datetime_open = DateTime.strptime(@open_string,'%m/%d/%Y %H:%M%P')
    @datetime_close = DateTime.strptime(@close_string,'%m/%d/%Y %H:%M%P')

    # collector array
    @timeslots = []
    # set first time slot to open of business hours
    @beginHalfhour = @datetime_open
    # loop through and increment by 30 minutes until closing time
    while @beginHalfhour < @datetime_close do
      # find end of slot
      @endHalfhour = @beginHalfhour.advance(:minutes => +30)
      @timeslots << {'datetime_begin'=>@beginHalfhour, 'datetime_end'=>@endHalfhour, 'display_time'=>@beginHalfhour.strftime('%l:%M%P'), 'display_date'=>@beginHalfhour.strftime('%m/%d/%Y'), 'available'=>true} #.strftime('%l:%M%P')
      @beginHalfhour = @endHalfhour
    end

    return @timeslots

  end

  def timesAvailable(datestring)
    # determine day_of_week from date
    @dateRequested = DateTime.strptime(datestring,'%m/%d/%Y')

    #puts "***************** DATE REQUESTED " + @dateRequested.strftime('%m/%d/%Y')
    # determine day_of_week_id from date
    @day_of_week_id = @dateRequested.to_time.wday
    # puts "****************** dAY OF WEEK "+@day_of_week_id.to_s
    # get open and close hours
    @timeslots = self.timesOpen(datestring)


    # get all scheduled appointments for the given day to check
    # this will only return scheduled appointments which fal within the open timeslots
    @appointments_unixstart = @timeslots.first['datetime_begin'].to_time.to_i
    @appointments_unixend = @timeslots.last['datetime_begin'].to_time.to_i
    @appointments = Appointment.scheduledByDate(self.company_id, @appointments_unixstart, @appointments_unixend, nil, false)

    #puts "***************** APPT COUNT " + @appointments.length.to_s

    # loop through all appointments and invalidate any time slots which are taken
    @appointments.each do |appointment|
      puts appointment.datetime_begin.to_time.to_s
      #puts "************ TIMESLOTS " + @timeslots.length.to_s

      # for each appointment, check against all open timeslots remaining, since the appointment could stretch across multiple slots
      @timeslots.each do |timeslot|
        # only check avaialble timeslots
        # if a timeslot is already unavailable, it doens't need to be checked
        if timeslot['available']
          puts "************* TIMESLOT " + timeslot['display_time'].to_s

          if appointment.datetime_begin >= timeslot['datetime_begin'] && appointment.datetime_begin < timeslot['datetime_end']
            # appointment falls within timeslot
            # mark timeslot unavailable
            timeslot['available'] = false
          end
        end
        #timeslot['available'] = true
      end
    end

    return @timeslots
  end
end
