EBS.Client_appsNew = do ->
  init = ->
    initSelectPicker()
    onClickBtnRegenerateToken()

  initSelectPicker = ->
    $('.selectpicker').selectpicker();

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

  { init: init }

EBS.Client_appsCreate = EBS.Client_appsNew
EBS.Client_appsEdit = EBS.Client_appsNew
EBS.Client_appsUpdate = EBS.Client_appsNew
