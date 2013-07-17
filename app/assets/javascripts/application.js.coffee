#  This is a manifest file that'll be compiled into including all the files listed below.
#  Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
#  be included in the compiled file accessible from http://example.com/assets/application.js
#  It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
#  the compiled file.
# 
#= require jquery
#= require jquery_ujs
#= require ym_core
#= require redactor
#= require ym_cms
#= require ym_tags
#= require ym_posts
#= require cocoon
#= require_tree .

Link = 
  init: ->
    $('#links .link_url input').live 'keyup', ->
      title = $(this).parents('fieldset').find('.link_title.title_blank input')
      if title
        url = this.value
        host = $.url(url).attr('host').replace(/^w*\./,'').split('.')[0]
        if url && host && !host.match(/^(w*|ht?t?p?)$/)
          host = host.toLowerCase().replace /^./, (letter) ->
            return letter.toUpperCase()
          title.val(host)
    $('#links .link_title.title_blank  input').live 'keyup', ->
      $(this).parents('.title_blank').removeClass('title_blank')

window.Link = Link

$(document).ready () ->
  $("select.chosen:not([multiple='multiple'])").chosen()
  $('#message_recipient_id').chosen(
    max_selected_options: 1
  )
  $("select[multiple='multiple']").chosen(
    persistent_create_option: false,
    create_option_text: "Add",
    create_option: (term) ->
      this.append_option(
        value: term,
        text: term
      )
    )
  $('#reveal-search').click ->
    $('#search-box').toggle()
  
  YmComments.Form.init({submitOnEnter: true})

  $('a[data-scroll]').live 'click', (event) ->
    event.preventDefault()
    $.scrollTo(`$(this)`.data('scroll'), {duration: 1000})
  
  $('textarea[maxlength]').live 'keyup blur', ->
    maxlength = $(this).attr('maxlength');
    val = $(this).val();
    $(this).val(val.slice(0, maxlength)) if val.length > maxlength

  $('show-sidebar-submit').click ->
    $('show-sidebar-search').submit()

  $('directory-sidebar-submit').click ->
    $('directory-sidebar-search').submit()