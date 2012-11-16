InterestedModal = 
  init: ->
    InterestedModal.selected_dates = new Array
    $("#interest-form-submit").click ->
      if $("input[id=not_sure_yet]").is(":checked")
        $("#enquiry_dates_interested_in").val "Not sure yet"
      else
        $("#enquiry_dates_interested_in").val InterestedModal.selected_dates.join()
      $("#interested").modal "hide"

    $("#availability_datepicker").datepicker
      hideIfNoPrevNext: true
      dateFormat: "dd/mm/yy"
      minDate: InterestedModal.start_on
      maxDate: InterestedModal.end_on
      beforeShowDay: InterestedModal.beforeShowDay
      onSelect: InterestedModal.onSelect
    
  beforeShowDay: (date) ->
    if $.inArray(TourForm.dateToString(date), InterestedModal.available) > -1
      dateAvailable = 1
    else
      dateAvailable = 0
    if $.inArray(TourForm.dateToString(date), InterestedModal.selected_dates) > -1
      dateClass = "ui-datepicker-booked"
    else
      dateClass = "ui-datepicker-available"
    [dateAvailable, dateClass, ""]
  
  onSelect: (dateText, inst) ->
    if $.inArray(dateText, InterestedModal.selected_dates) > -1
      InterestedModal.selected_dates.splice $.inArray(dateText, InterestedModal.selected_dates), 1
    else
      InterestedModal.selected_dates.push dateText
    $("#availability_datepicker").datepicker "refresh"
    
window.InterestedModal = InterestedModal