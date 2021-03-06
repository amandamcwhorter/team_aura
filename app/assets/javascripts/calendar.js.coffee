# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#datepicker").datepicker()
  #
  #				date store today date.
  #				d store today date.
  #				m store current month.
  #				y store current year.
  #
  date = new Date()
  d = date.getDate()
  m = date.getMonth()
  y = date.getFullYear()

  #				Initialize fullCalendar and store into variable.
  calendar = $("#calendar").fullCalendar(


  #	header option will define our calendar header.
  # what will be at right position in calendar
    header:
      left: "prev,next today"
      center: "title"
      right: "month,agendaWeek,agendaDay"


    defaultView: "agendaWeek"

  #
  #					selectable:true will enable user to select datetime slot
  #					selectHelper will add helpers for selectable.
  #
    selectable: true
    selectHelper: true

  #
  #					when user select timeslot this option code will execute.
  #					It has three arguments. Start,end and allDay.
  #					Start means starting time of event.
  #					End means ending time of event.
  #					allDay means if events is for entire day or not.
  #
    select: (start, end, allDay) ->

      #
      #						after selection user will be promted for enter title for event.
      #
      title = prompt("Event Title:")

      #
      #						if title is enterd calendar will add title and event into fullCalendar.
      #
      if title
        calendar.fullCalendar "renderEvent",
          title: title
          start: start
          end: end
          allDay: allDay
        , true # make the event "stick"
      calendar.fullCalendar "unselect"
      return


  #
  #	editable: true allow user to edit events.
  #
    editable: true

  #
  #					events is the main option for calendar.
  #					for demo we have added predefined events in json object.
  #
#    events: [
#      {
#        title: "All Day Event"
#        start: new Date(y, m, 1)
#      }
#      {
#        title: "Long Event"
#        start: new Date(y, m, d - 5)
#        end: new Date(y, m, d - 2)
#      }
#      {
#        id: 999
#        title: "Repeating Event"
#        start: new Date(y, m, d - 3, 16, 0)
#        allDay: false
#      }
#      {
#        id: 999
#        title: "Repeating Event"
#        start: new Date(y, m, d + 4, 16, 0)
#        allDay: false
#      }
#    ]
  )
  return