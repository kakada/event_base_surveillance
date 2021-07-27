# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

EBS.Medisys_feedsIndex = do ->
  init = ->
    firebase.analytics().logEvent("page_view_medisys")

    onClickShowMore()
    onClickFeedLink()
    onChangeMedisySelect()
    EBS.DatepickerPopup.init()

  onChangeMedisySelect = ->
    $(document).off('change', '#medisy_id')
    $(document).on 'change', '#medisy_id', (event)->
      $('[type="submit"]').parents('form').submit()

  onClickFeedLink = ->
    $(document).off('click', '.headline_link')
    $(document).on 'click', '.headline_link', (event)->
      firebase.analytics().logEvent "click_feed_link",
        title: $(event.target).html()
        url: $(event.target).attr('href')

      true

  onClickShowMore = ->
    $(document).off('click', '.show-more')
    $(document).on 'click', '.show-more', (event)->
      $(this).parents('.articlebox_big').find('.alert_more').toggle()

  { init: init }
