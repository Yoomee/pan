DEFAULT_LOCATION = [58.031372,-4.086914]

VenueBookingForm = 
  init: ->
    $('#availability_datepicker').datepicker({
      hideIfNoPrevNext: true,
      onSelect: VenueBookingForm.onSelect
      beforeShowDay: VenueBookingForm.beforeShowDay
      dateFormat: 'dd/mm/yy',
      numberOfMonths: 2
    })
    $('#popover_save').click (e) =>
      e.preventDefault()
      VenueBookingForm.savePopover()
    $('#popover_destroy').click (e) =>
      e.preventDefault()
      VenueBookingForm.destroyBookingPopover()
    $('#popover_unavailable').click (e) =>
      e.preventDefault()
      VenueBookingForm.makeUnavailable()
    $('#popover_close').click (e) =>
      e.preventDefault()
      VenueBookingForm.closePopover()
  dateToString: (date) ->
    "#{('0' + date.getDate()).slice(-2)}/#{('0' + (date.getMonth() + 1)).slice(-2)}/#{date.getFullYear()}"
  beforeShowDay: (date) ->
    dateString = VenueBookingForm.dateToString(date)
    tourDate= VenueBookingForm.dates[dateString]
    if tourDate?
      if tourDate.tour_id?
        dateClass= "ui-datepicker-booked"
      else
        dateClass= "ui-datepicker-unavailable"
    else
      dateClass= 'ui-datepicker-available'
    [true, dateClass]
  onSelect: (dateText, inst) ->
    VenueBookingForm.selectedDateText = dateText
    setTimeout("VenueBookingForm.showPopover('#{dateText}')",100)
  closePopover: ->
    VenueBookingForm.selectedDateText = null
    $('#availability_datepicker').datepicker('refresh')
    $('#availability_popover').hide() 
  makeUnavailable: ->
    dateText = VenueBookingForm.selectedDateText
    tourDate = VenueBookingForm.dates[dateText]
    VenueBookingForm.addDate(dateText)
    VenueBookingForm.closePopover()
  savePopover: ->
    dateText = VenueBookingForm.selectedDateText
    bookedDate = VenueBookingForm.dates[dateText]
    if bookedDate && !bookedDate.tour_id
      VenueBookingForm.removeDate(dateText)
      VenueBookingForm.closePopover()
    else
      tour_id = $('#popover_tour_id').val()
      if tour_id != ""
        dateText = VenueBookingForm.selectedDateText
        VenueBookingForm.addDate(dateText)
        dateFields = $("#availability .nested-fields:has('input[value=\"#{dateText}\"]')")
        dateFields.find('input[name$="[booked]"]').val(1)    
        VenueBookingForm.dates[dateText].booked = true
        dateFields.find('input[name$="[tour_id]"]').val(tour_id)
        VenueBookingForm.dates[dateText].tour_id = tour_id
        VenueBookingForm.closePopover()
  showPopover: (dateText) ->
    $('#availability_popover').hide()
    tourDate = VenueBookingForm.dates[dateText]
    if tourDate && tourDate.tour_id
      $('.popover-title h4').html('Edit booking')
      $('#popover_destroy').show()
      $('#popover_unavailable').hide()
      $('#tour_select_controls').show()
      $('#unavailable_controls').hide()
      $('#popover_save').html("Save booking")
      $('#popover_tour_id').val(tourDate.tour_id)
    else if tourDate
      $('.popover-title h4').html('Edit availability')
      $('#popover_destroy').hide()
      $('#popover_unavailable').hide()
      $('#tour_select_controls').hide()
      $('#unavailable_controls').show()
      $('#popover_save').html("Make available")
      $('#popover_tour_id').val(tourDate.tour_id)
    else
      $('.popover-title h4').html('Add a booking')
      $('#popover_tour_id').val(null)
      $('#popover_destroy').hide()
      $('#tour_select_controls').show()
      $('#unavailable_controls').hide()
      $('#popover_unavailable').show()
      $('#popover_save').html("Save booking")
    pos = $('#availability_datepicker td.ui-datepicker-current-day').position()    
    $('#availability_popover').css('top',pos.top - $('#availability_popover').outerHeight()/2 + 15)
    $('#availability_popover').css('left',pos.left + 35)
    $('#availability_popover').show()
  destroyBookingPopover: ->
    answer = confirm("Are you sure you want to delete this booking?")
    if answer
      dateText = VenueBookingForm.selectedDateText
      VenueBookingForm.removeDate(dateText)
      VenueBookingForm.closePopover()
  addDate: (dateText)->
    tourDate = VenueBookingForm.dates[dateText]
    unless tourDate?
      $('#availability #add_tour_date').click()
      tourDateInput = $('#availability .nested-fields input[value=""]').last()
      tourDateInput.val(dateText)
      tourDateInput.attr('value',dateText)
      VenueBookingForm.dates[dateText] = {booked:false}
  removeDate: (dateText) ->
    tourDate = VenueBookingForm.dates[dateText]
    if tourDate?
      delete VenueBookingForm.dates[dateText]
      $("#availability .nested-fields:has('input[value=\"#{dateText}\"]') a.remove_fields").click()      
window.VenueBookingForm = VenueBookingForm  


VenuesMap =
	init: (large) ->
    large ||= false
    mapOptions = {
      center: new google.maps.LatLng(DEFAULT_LOCATION[0],DEFAULT_LOCATION[1]),
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      streetViewControl: false
    }
    mapOptions.zoom = if large then 6 else 8
    
    VenuesMap.map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
    VenuesMap.infowindow = new google.maps.InfoWindow({maxWidth: 400})

    bounds = new google.maps.LatLngBounds
    for venue in VenuesMap.venues
      marker = new google.maps.Marker({
          position: new google.maps.LatLng(venue.lat, venue.lng),
          map: VenuesMap.map,
          title:venue.name
      });
      bounds.extend(marker.position)
      marker.venueId = venue.id
      if large
        marker.contentString = "<div class='venue-infowindow'><h3>#{venue.name}</h3><img src='#{venue.infowindow_image_url}'><p>#{venue.short_description}</p><a href='/venues/#{venue.id}'>Show venue &rarr;</a></div>"
        google.maps.event.addListener marker, 'click', ->
          VenuesMap.infowindow.close()
          VenuesMap.infowindow.setContent(this.contentString)
          VenuesMap.infowindow.open(VenuesMap.map,this);
      else if VenuesMap.venues.length > 1
        google.maps.event.addListener marker, 'click', ->
          window.location = "/venues/#{this.venueId}"
    
    if VenuesMap.venues.length  
      VenuesMap.map.setCenter(bounds.getCenter())

VenueLocationMap =  
  init: (lat, lng, notDefault) ->
    mapOptions = {
      center: new google.maps.LatLng(lat,lng),
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      streetViewControl: false,
      draggable: true,
      keyboardShortcuts:false
    }
    mapOptions.zoom = if notDefault then 12 else 8  
    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(lat, lng),
      map: map
    });
    
    google.maps.event.addListener map, 'center_changed', ->
      mapCenter = map.getCenter()
      marker.setPosition(mapCenter)
      VenueLocationMap.update(mapCenter)
    
  update: (latLng) ->
    $('#venue_lat').val(latLng.lat())
    $('#venue_lng').val(latLng.lng())
    
    
window.VenuesMap = VenuesMap 
window.VenueLocationMap = VenueLocationMap  
