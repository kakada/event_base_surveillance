# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

EBS.Medisys_feedsIndex = do ->
  init = ->
    onClickShowMore()
    EBS.DatepickerPopup.init();

  onClickShowMore = ->
    $(document).off('click', '.show-more')
    $(document).on 'click', '.show-more', (event)->
      $(this).parents('.articlebox_big').find('.alert_more').toggle()

  { init: init }
