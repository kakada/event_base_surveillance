EBS.EventsIndex = do ->
  init = ->
    initPopover()
    onClickItem()

  initPopover = ->
    $('[data-toggle="popover"]').popover()

  onClickItem = ->
    $(document).off 'click', '.field-code'
    $(document).on 'click', '.field-code', (e)->
      value = $(this).html() + ' : '
      EBS.Util.insertAtCaret('search', value)
      $('#search').focus()


  { init: init }
