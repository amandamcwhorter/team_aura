class Appointment < ActiveRecord::Base
  belongs_to :host, class_name: "User"
  belongs_to :guest, class_name: "User"
  belongs_to :service
  belongs_to :location
  belongs_to :company

  validates :company_id, :presence => true
  validates :host_id, :presence => true
  validates :guest_id, :presence => true
  validates :service_id, :presence => true
  validates :location_id, :presence => true
  validates :datetime_begin, :presence => true

  def timestart
    if !datetime_begin.nil?
      return datetime_begin.strftime("%H:%M")
    end
  end

  def datestart
    if !datetime_begin.nil?
      return datetime_begin.strftime("%m/%d/%Y")
    end
  end

  # title, start, end = formatting for calendar feed
  def title
    if !service_id.nil? && !host_id.nil?
      return service.name + ' w/ ' + host.fullname
    end
  end
  def start
    if !datetime_begin.nil?
      return datetime_begin.strftime("%Y-%m-%d %H:%M:00")
    end
  end
  def end
    if !datetime_end.nil?
      return datetime_end.strftime("%Y-%m-%d %H:%M:00")
    end
  end
  def allDay
    if !datetime_end.nil?
      return false
    end
    return true
  end
  def color
    if !self.accepted
      return "#333"
    end
    return host.color
  end

  def self.scheduledByDate(company_id, unixstart, unixend, staff, showUnscheduled = false)
    # basic where clause
    @whereClause = 'company_id = ? AND cancelled is not true'
    if(!showUnscheduled)
      @whereClause += ' AND accepted is true'
    end

    #if passed, limit results by start and end times

    # if start param, convert to datetime
    if !unixstart.nil?
      @start = DateTime.strptime(unixstart.to_s,'%s')
      @whereClause += " AND datetime_begin >= '" + @start.strftime('%Y-%m-%d %H:%M') + "'"
    end
    puts "********** start/end " + @start.to_s
    if !unixend.nil?
      @end = DateTime.strptime(unixend.to_s,'%s')
      @whereClause += " AND datetime_begin <= '" + @end.strftime('%Y-%m-%d %H:%M') + "'"
    end

    if !staff.nil?

      @whereClause += " AND host_id IN (" + staff + ")"
    end
    puts "********** start/end " + @end.to_s


    @appointments = Appointment.where(@whereClause, company_id )
  end
end