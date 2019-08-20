EBS.Api_keysNew = do ->
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

EBS.Api_keysCreate = EBS.Api_keysNew
EBS.Api_keysEdit = EBS.Api_keysNew
EBS.Api_keysUpdate = EBS.Api_keysNew
