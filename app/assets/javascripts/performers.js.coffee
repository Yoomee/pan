window.Performers =
  init: ->
    Performers.showHideForm() if document.getElementById('performer_create_user_from_performer') is not null
    if $('#performer_description').val()? then Performers.descriptionUpdate($('#performer_description').val()) else Performers.descriptionUpdate($('#tour_description').val())

    $('#performer_create_user_from_performer').change ->
      Performers.showHideForm()    
    
     elem = if $('#performer_description').val()? then $('#performer_description') else $('#tour_description')  
     elem.data('oldVal', elem.val())     
     elem.bind "propertychange keyup input paste", ->        
       if (elem.data('oldVal') != elem.val())         
         elem.data('oldVal', elem.val())
         Performers.descriptionUpdate(elem.val())  

  showHideForm: ->
    if document.getElementById('performer_create_user_from_performer').checked == true
      $('#create-user').removeClass('hide')
    else
      $('#create-user').addClass('hide')   

  descriptionUpdate: (description) ->    
    used = if description != "" then description.replace(/(\n|\r)/, "").length else 0
    remaining = 1000 - used    
    $('#countdown').text("You have " + remaining + " characters remaining")
    $('#countdown').data('remaining', remaining)
