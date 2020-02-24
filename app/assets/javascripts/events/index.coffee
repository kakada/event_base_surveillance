EBS.EventsIndex = do ->
  init = ->
    EBS.DatepickerPopup.init()

    initFilterKeywordPopover()
    onClickKeywordItem()

  initFilterKeywordPopover = ->
    $('[data-toggle="popover"]').popover()
    $(document).off 'click', '[data-toggle="popover"]'
    $(document).on 'click', '[data-toggle="popover"]', (e)->
      e.preventDefault()

  onClickKeywordItem = ->
    $(document).off 'click', '.field-code'
    $(document).on 'click', '.field-code', (e)->
      value = $(this).html() + ' : '
      EBS.Util.insertToTextbox('keyword', value)
      $('#keyword').focus()

  { init: init }
