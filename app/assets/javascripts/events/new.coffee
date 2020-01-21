EBS.EventsNew = do ->
  init = ->
    EBS.EventsEvent_milestonesNew.init()
    onClickLinkEvent()
    onKeyupSearch()
    onScrollEventList()
    onClickEventItem()
    onHideLinkEventModal()
    onClickBtnReset()

  onClickBtnReset = ->
    $('.btn-reset').off 'click'
    $('.btn-reset').on 'click', ->
      $('#event_link_uuid').val('')

  onClickLinkEvent = ->
    $('#event_link_uuid').off 'click'
    $('#event_link_uuid').on 'click', ->
      $('#link-event-modal').modal('show')
      $('.event-list').html('')

  onClickEventItem = ->
    $('.event-item').off 'click'
    $(document).on 'click', '.event-item', ->
      $('#link-event-modal').modal('hide')
      $('#event_link_uuid').val($(this).data('event-uuid'))

  onHideLinkEventModal = ->
    $('#link-event-modal').on 'hide.bs.modal', ->
      $('#search').val('')

  onKeyupSearch = ->
    $('#search').off 'keyup'
    $('#search').on 'keyup', ->
      form = $('#form_search')
      eventList = $(".event-list")

      if $(this).val().length == 0
        eventList.hide()
      else
        eventList.show()
        $.get( form.attr('action'), form.serialize() )

  onScrollEventList = ->
    $('.event-wrapper').off 'scroll'
    $('.event-wrapper').on 'scroll', ->
      loadNextPage()

  loadNextPage = ->
    if $('#next_link').data('loading')
      return

    reachBottom = $('.event-wrapper').scrollTop() == $('.event-list').height() - $('.event-wrapper').height()

    if reachBottom && $("#next_link").length > 0
      $('#next_link')[0].click()
      $('#next_link').data 'loading', true

  { init: init }


EBS.EventsCreate = EBS.EventsNew
EBS.EventsEdit = EBS.EventsNew
EBS.EventsUpdate = EBS.EventsNew
