VenuesMap =
	init: ->
    mapOptions = {
      center: new google.maps.LatLng(58.031372,-4.086914),
      zoom: 6,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      streetViewControl: false
    }
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
      marker.contentString = "<div class='venue-infowindow'><h3>#{venue.name}</h3><img src='#{venue.infowindow_image_url}'><p>#{venue.short_description}</p><a href='/venues/#{venue.id}'>Show venue &rarr;</a></div>"
      google.maps.event.addListener marker, 'click', ->
        VenuesMap.infowindow.close()
        VenuesMap.infowindow.setContent(this.contentString)
        VenuesMap.infowindow.open(VenuesMap.map,this);
    VenuesMap.map.setCenter(bounds.getCenter())
window.VenuesMap = VenuesMap 