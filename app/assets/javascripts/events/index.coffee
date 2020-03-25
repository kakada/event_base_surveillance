EBS.EventsIndex = do ->
  init = ->
    EBS.DatepickerPopup.init()

    initFilterKeywordPopover()
    onClickKeywordItem()
    onClickBtnDownload()

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

  onClickBtnDownload = ->
    $(document).off 'click', '.btn-download'
    $(document).on 'click', '.btn-download', (e)->
      e.preventDefault()

      $('#template-model').modal('hide')
      downloadEvent(this)

  downloadEvent = (dom)->
    url = $(dom).attr('href') + '?start_date=' + params.start_date + '&keyword=' + params.keyword + '&template_id=' + $("[name='template_id']").val()
    window.open(url, '_blank')

  { init: init }
