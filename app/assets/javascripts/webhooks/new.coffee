EBS.WebhooksNew = do ->
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
      $('.api-key-view').html(key)
      $('.api-key').val(key)

  { init: init }

EBS.WebhooksCreate = EBS.WebhooksNew
EBS.WebhooksEdit = EBS.WebhooksNew
EBS.WebhooksUpdate = EBS.WebhooksNew
