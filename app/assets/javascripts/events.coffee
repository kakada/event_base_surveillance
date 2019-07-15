# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready () =>
  init = ->
    onClickTriggerNav();

  onClickTriggerNav = ->
    $('.triggerNav').on 'click', ->
      openNav();

  openNav = ->
    $('body').toggleClass 'mini-navbar'

    if !$('body').hasClass('mini-navbar') or $('body').hasClass('body-small')
      # Hide menu in order to smoothly turn on when maximize menu
      $('#side-menu').hide()
      # For smoothly turn on menu
      setTimeout (->
        $('#side-menu').fadeIn 100
        return
      ), 100

    else
      $('#side-menu').removeAttr 'style'
    return

  init();
