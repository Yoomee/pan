VenuesMap =
	init: (large) ->
    large ||= false
    mapOptions = {
      center: new google.maps.LatLng(58.031372,-4.086914),
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      streetViewControl: false
    }
    mapOptions.zoom = if large then 6 else 8
    
    VenuesMap.map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
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
window.VenuesMap = VenuesMap 