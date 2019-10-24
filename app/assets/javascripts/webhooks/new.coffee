EBS.WebhooksNew = do ->
  init = ->
    handleDisplayType()
    onChangeWebhookType()

  handleDisplayType = ->
    value = $('.type').val()
    if !!value
      $('.types[data-type=\'' + value + '\']').show()

  onChangeWebhookType = ->
    $(document).off('change', '.type')
    $(document).on 'change', '.type', (event)->
      $('.types').hide()
      $('.types input').val('')
      $('.types[data-type=\'' + this.value + '\']').show()

  { init: init }

EBS.WebhooksCreate = EBS.WebhooksNew
EBS.WebhooksEdit = EBS.WebhooksNew
EBS.WebhooksUpdate = EBS.WebhooksNew
