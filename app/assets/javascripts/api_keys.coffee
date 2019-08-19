# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


document.addEventListener 'turbolinks:load', ->
  init = ->
    onClickBtnRegenerateToken()

  hex = (n) ->
    n = n or 16
    result = ''
    while n--
      result += Math.floor(Math.random() * 16).toString(16)
    result

  onClickBtnRegenerateToken = ->
    $(document).off('click', '.btn-regenerate-token')
    $(document).on 'click', '.btn-regenerate-token', (event)->
      key = hex(32)
      $('.access-token-view').html(key)
      $('.access-token').val(key)

  init()
