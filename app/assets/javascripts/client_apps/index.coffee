EBS.Client_appsIndex = do ->
  init = ->
    initTooltip()
    onClickBtnCopyToken()

  initTooltip = ->
    $('[data-toggle="tooltip"]').tooltip()

  onClickBtnCopyToken = ->
    $(document).off('click', '.btn-copy')
    $(document).on 'click', '.btn-copy', (event)->
      input = $(this).prev('input.access-token')
      input.select()
      document.execCommand("copy")

  { init: init }
