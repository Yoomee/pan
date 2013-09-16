window.Performers =
  init: ->
    Performers.showHideForm() if document.getElementById('performer_create_user_from_performer') is not null

    $('#performer_create_user_from_performer').change ->
      Performers.showHideForm()

  showHideForm: ->
    if document.getElementById('performer_create_user_from_performer').checked == true
      $('#create-user').removeClass('hide')
    else
      $('#create-user').addClass('hide')
#     performerDescription = $('#performer_description').val()
#     tourDescription = $('#tour_description').val()

#     $('#performer_description').keypress ->
#       performerDescription = $('#performer_description').val()
#       Performers.descriptionUpdate(performerDescription)

#     $('#tour_description').keypress ->
#       tourDescription = $('#tour_description').val()
#       Performers.descriptionUpdate(tourDescription)

#     if performerDescription?  
#       setInterval(Performers.descriptionUpdate(performerDescription), 500)
#     else    
#       setInterval(Performers.descriptionUpdate(tourDescription), 500)  

#    descriptionUpdate: (description) ->
#       used = if description then description.replace(/(\n|\r)/, "").length else 0

#       remaining = 1000 - used
#       $('#countdown').text("You have " + remaining + " characters remaining")
#       $('#countdown').data('remaining', remaining)
