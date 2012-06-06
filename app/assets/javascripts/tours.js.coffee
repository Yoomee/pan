TourForm = 
  bookingMode:false
  init: ->
    $('#availability_datepicker').datepicker({
      hideIfNoPrevNext: true,
      onSelect: TourForm.onSelect
      beforeShowDay: TourForm.beforeShowDay
      dateFormat: 'dd/mm/yy'
    })
    TourForm.startDate = TourForm.getStartDate()
    TourForm.endDate = TourForm.getEndDate()
    if TourForm.startDate && TourForm.endDate
      TourForm.updateAvailability()
    $('#tour_start_on_s,#tour_end_on_s').change =>
      setTimeout "TourForm.updateAvailability(true)", 200
    $('#popover_external_venue_name').keydown (e) =>
      $('#popover_venue_id').val(null)
      if e.keyCode == 13
        e.preventDefault()
        TourForm.savePopover()
    $('#popover_venue_id').change =>
      $('#popover_external_venue_name').val(null)
    $('#popover_save').click (e) =>
      e.preventDefault()
      TourForm.savePopover()
    $('#popover_destroy').click (e) =>
      e.preventDefault()
      TourForm.destroyBookingPopover()
    $('#popover_close').click (e) =>
      e.preventDefault()
      TourForm.closePopover()
  getStartDate: ->
    $.datepicker.parseDate('dd/mm/yy', $('#tour_start_on_s').val());
  getEndDate: ->
    $.datepicker.parseDate('dd/mm/yy', $('#tour_end_on_s').val());
  setStartDate: (date)->
    $('#tour_start_on_s').val($.datepicker.formatDate('dd/mm/yy', date));
  setEndDate: (date)->
    $('#tour_end_on_s').val($.datepicker.formatDate('dd/mm/yy', date));
  availableMonths: ->
    startMonth = (TourForm.startDate.getYear() * 12) + TourForm.startDate.getMonth()
    endMonth = (TourForm.endDate.getYear() * 12) + TourForm.endDate.getMonth()
    months = endMonth - startMonth + 1
    months = 2 if months < 2
    if months > 2
      [months / 2, 2]
    else
      months
  dateToString: (date) ->
    "#{('0' + date.getDate()).slice(-2)}/#{('0' + (date.getMonth() + 1)).slice(-2)}/#{date.getFullYear()}"
  beforeShowDay: (date) ->
    selectable = date >= TourForm.startDate && date <= TourForm.endDate
    dateString = TourForm.dateToString(date)
    tourDate= TourForm.dates[dateString]
    if tourDate?
      if tourDate.booked
        dateClass= "ui-datepicker-booked"
      else
        dateClass= "ui-datepicker-available"
    else
      dateClass= 'ui-datepicker-unavailable'
    [selectable, dateClass]
  onSelect: (dateText, inst) ->
    TourForm.selectedDateText = dateText
    if TourForm.bookingMode
      tourDate = TourForm.dates[dateText]
      if tourDate?
        setTimeout("TourForm.showPopover('#{dateText}')",100)
    else
      tourDate = TourForm.dates[dateText]
      if tourDate?
        TourForm.removeDate(dateText)
      else
        TourForm.addDate(dateText)
  closePopover: ->
    TourForm.selectedDateText = null
    $('#availability_datepicker').datepicker('refresh')
    $('#availability_popover').hide() 
  savePopover: ->
    dateText= TourForm.selectedDateText
    dateFields = $("#availability .nested-fields:has('input[value=\"#{dateText}\"]')")
    dateFields.find('input[name$="[booked]"]').val(1)    
    TourForm.dates[dateText].booked = true
    if $('#popover_venue_id').val()? && $('#popover_venue_id').val() != ""
      dateFields.find('input[name$="[venue_id]"]').val($('#popover_venue_id').val())
      dateFields.find('input[name$="[external_venue_name]"]').val(null)
      TourForm.dates[dateText].venue_id = $('#popover_venue_id').val()
      TourForm.dates[dateText].external_venue_name = null
    else
      dateFields.find('input[name$="[venue_id]"]').val($('#popover_venue_id').val(null))
      dateFields.find('input[name$="[external_venue_name]"]').val($('#popover_external_venue_name').val())
      TourForm.dates[dateText].venue_id = null
      TourForm.dates[dateText].external_venue_name = $('#popover_external_venue_name').val()
    $('#availability_popover').hide()
    $('#availability_datepicker').datepicker('refresh');
  showPopover: (dateText) ->
    $('#availability_popover').hide()
    tourDate = TourForm.dates[dateText]
    if tourDate.booked
      $('.popover-title h4').html('Edit booking')
      $('#popover_destroy').show()
      $('#popover_venue_id').val(tourDate.venue_id)
      $('#popover_external_venue_name').val(tourDate.external_venue_name)
    else
      $('.popover-title h4').html('Add a booking')
      $('#popover_venue_id').val(null)
      $('#popover_external_venue_name').val(null)
      $('#popover_destroy').hide()
    pos = $('#availability_datepicker td.ui-datepicker-current-day').position()    
    $('#availability_popover').css('top',pos.top - $('#availability_popover').outerHeight()/2 + 15)
    $('#availability_popover').css('left',pos.left + 35)
    $('#availability_popover').show()
  destroyBookingPopover: ->
    answer = confirm("Are you sure you want to delete this booking?")
    if answer
      dateText = TourForm.selectedDateText
      if dateText?
        dateFields = $("#availability .nested-fields:has('input[value=\"#{dateText}\"]')")
        dateFields.find('input[name$="[booked]"]').val(0)
        dateFields.find('input[name$="[venue_id]"]').val(null)
        dateFields.find('input[name$="[external_venue_name]"]').val(null)
        TourForm.dates[dateText].booked = false
        TourForm.dates[dateText].venue_id = null
        TourForm.dates[dateText].external_venue_name = null
        TourForm.closePopover()
  addDate: (dateText)->
    tourDate = TourForm.dates[dateText]
    unless tourDate?
      $('#availability #add_tour_date').click()
      tourDateInput = $('#availability .nested-fields input[value=""]').last()
      tourDateInput.val(dateText)
      tourDateInput.attr('value',dateText)
      TourForm.dates[dateText] = {booked:false}
  removeDate: (dateText) ->
    tourDate = TourForm.dates[dateText]
    if tourDate? && !tourDate.booked
      delete TourForm.dates[dateText]
      $("#availability .nested-fields:has('input[value=\"#{dateText}\"]') a.remove_fields").click()      
  updateAvailability: (addDates)->
    newStartDate = TourForm.getStartDate()
    newEndDate   = TourForm.getEndDate()
    
    oldStartDate = TourForm.startDate
    oldEndDate   = TourForm.endDate
    
    TourForm.startDate ||= newStartDate
    TourForm.endDate ||= newEndDate
    
    return unless TourForm.startDate? && TourForm.endDate?

    if newStartDate > newEndDate
      alert "ERROR\nThe start date must be before the end date"
      TourForm.setStartDate(TourForm.startDate)
      TourForm.setEndDate(TourForm.endDate)
      return  
    datesToAdd = []
    datesToRemove = []

    if newStartDate - TourForm.startDate != 0
      if newStartDate > TourForm.startDate
        date = TourForm.startDate
        while date < newStartDate
          datesToRemove.push(date)
          date = new Date(date.getTime() + 86400000)
      else
        date = TourForm.startDate
        while date > newStartDate
          date = new Date(date.getTime() - 86400000)
          datesToAdd.push(date)
    else if newEndDate - TourForm.endDate != 0
      if newEndDate > TourForm.endDate
        date = TourForm.endDate
        while date < newEndDate
          date = new Date(date.getTime() + 86400000)
          datesToAdd.push(date)
      else
        date = TourForm.endDate
        while date > newEndDate
          datesToRemove.push(date)
          date = new Date(date.getTime() - 86400000)
    else if !oldStartDate? || !oldEndDate?
      #First time
      date = TourForm.startDate
      while date <= TourForm.endDate
        datesToAdd.push(date)
        date = new Date(date.getTime() + 86400000)
    
    error = false
    $.each datesToRemove, (index, value) =>
      tourDate = TourForm.dates[TourForm.dateToString(value)]
      error = true if tourDate? && tourDate.booked
    
    if error  
      alert "ERROR\nThere are existing tour bookings outside this date range."
      TourForm.setStartDate(TourForm.startDate)
      TourForm.setEndDate(TourForm.endDate)
    else
      $.each datesToAdd, (index,value) =>
        TourForm.addDate(TourForm.dateToString(value))
      $.each datesToRemove, (index,value) =>
        TourForm.removeDate(TourForm.dateToString(value))
      TourForm.startDate = newStartDate
      TourForm.endDate = newEndDate
      $('#availability_datepicker').datepicker( "option", "minDate", TourForm.startDate);
      $('#availability_datepicker').datepicker( "option", "maxDate", TourForm.endDate);
      $('#availability_datepicker').datepicker( "option", "numberOfMonths", TourForm.availableMonths());
window.TourForm = TourForm  