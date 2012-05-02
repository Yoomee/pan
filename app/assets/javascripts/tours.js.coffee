TourForm = 
  bookingMode:true
  init: ->
    $('#availability_datepicker').datepicker({
      hideIfNoPrevNext: true,
      onSelect: TourForm.onSelect
      beforeShowDay: TourForm.beforeShowDay
      dateFormat: 'dd/mm/yy'
    })
    $('a[href="#availability"]').on 'shown', (e)=>
      TourForm.bookingMode = true
      TourForm.toggleMode()
    $('a[href="#bookings"]').click (e)=>
      $('a[href="#availability"]').click()
      TourForm.bookingMode = false
      TourForm.toggleMode()
      
    if TourForm.startDate() && TourForm.endDate()
      TourForm.updateAvailability()
    $('#tour_start_on_s,#tour_end_on_s').change =>
      setTimeout "TourForm.updateAvailability(true)", 10
    $('#popover_external_venue_name').keydown =>
      $('#popover_venue_id').val(null)
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
  toggleMode: ->
    if TourForm.bookingMode
      TourForm.bookingMode = false
      $('#availability_start_end').show()
    else
      TourForm.bookingMode = true
      $('ul.nav-tabs li.active').removeClass('active')
      $('ul.nav-tabs li:has("a[href=\'#bookings\']")').addClass('active')
      $('#availability_start_end').hide()
  startDate: ->
    $.datepicker.parseDate('dd/mm/yy', $('#tour_start_on_s').val());
  endDate: ->
    $.datepicker.parseDate('dd/mm/yy', $('#tour_end_on_s').val());
  availableMonths: ->
    startMonth = (TourForm.startDate().getYear() * 12) + TourForm.startDate().getMonth()
    endMonth = (TourForm.endDate().getYear() * 12) + TourForm.endDate().getMonth()
    months = endMonth - startMonth + 1
    if months > 3
      [months / 3, 3]
    else
      months
  dateToString: (date) ->
    "#{('0' + date.getDate()).slice(-2)}/#{('0' + (date.getMonth() + 1)).slice(-2)}/#{date.getFullYear()}"
  beforeShowDay: (date) ->
    selectable = date >= TourForm.startDate() && date <= TourForm.endDate()
    dateString = TourForm.dateToString(date)
    tourDate= TourForm.dates[dateString]
    if tourDate?
      if tourDate.booked
        dateClass= "ui-datepicker-booked"
      else
        dateClass= "ui-datepicker-available"
    else
      dateClass= ''#'ui-datepicker-unavailable'
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
    dateFields.find('input[name$="[booked]"]').attr('checked',true)    
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
    console.log dateText
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
        dateFields.find('input[name$="[booked]"]').attr('checked',false)
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
    if addDates?
      `for (var date in TourForm.dates)TourForm.removeDate(date,false);`
      date = TourForm.startDate()
      endDate = TourForm.endDate()
      while date <= endDate
        TourForm.addDate(TourForm.dateToString(date))
        date = new Date(date.getTime() + 86400000)
    $('#availability_datepicker').datepicker( "option", "minDate", TourForm.startDate());
    $('#availability_datepicker').datepicker( "option", "maxDate", TourForm.endDate());
    $('#availability_datepicker').datepicker( "option", "numberOfMonths", TourForm.availableMonths());
window.TourForm = TourForm  