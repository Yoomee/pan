window.Directory =
  init: ->
    $('a.collection').click (event) ->
      event.preventDefault()
      if $(this).parent().hasClass('active')
        Directory.clearAllCollections()
      else
        Directory.selectCollection($(this))
    $('a.region').click (event) ->
      event.preventDefault()
      if $(this).parent().hasClass('active')
        Directory.clearAllRegions()
      else
        Directory.selectRegion($(this))
    $('a.tag').click (event) ->
      event.preventDefault()
      if $(this).children('span').hasClass('label-success')
        Directory.clearTag($(this))
      else
        Directory.selectTag($(this))
    $('a.type').click (event) ->
      event.preventDefault()
      if $(this).parent().hasClass('active')
        Directory.clearAllTypes()
      else
        Directory.selectType($(this))

  clearAllCollections: ->
    $('.collection').parent('li').removeClass('active')
    $('select#collection option').prop('selected', false)

  selectCollection: (collection) ->
    Directory.clearAllCollections()
    collection.parent('li').addClass('active')
    collectionToSelect = collection.prop('id').replace('collection-', '')
    $("select#collection option[value=#{collectionToSelect}]").prop('selected', true)

  clearAllRegions: ->
    $('.region').parent().removeClass('active')
    $('select#region option').prop('selected', false)

  selectRegion: (region) ->
    Directory.clearAllRegions()
    region.parent('li').addClass('active')
    regionToSelect = region.prop('id').replace('region-', '')
    $("select#region option[value=#{regionToSelect}]").prop('selected', true)

  clearTag: (tag) ->
    tagClass = tag.prop('class').split(' ').pop()
    $(".#{tagClass}").children('span').removeClass('label-success')
    $("input.tags##{tagClass}").prop('checked', false)

  selectTag: (tag) ->
    tagClass = tag.prop('class').split(' ').pop()
    tag.children('span').addClass('label-success')
    $("input.tags##{tagClass}").prop('checked', true)

  clearAllTypes: ->
    $('.type').parent('li').removeClass('active')
    $('select#type option').prop('selected', false)

  selectType: (type) ->
    Directory.clearAllTypes()
    type.parent('li').addClass('active')
    typeToSelect = type.prop('id').replace('type-', '')
    $("select#type option[value=#{typeToSelect}]").prop('selected', true)
