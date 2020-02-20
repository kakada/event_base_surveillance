EBS.Telegram_botsNew = do ->
  init = ->
    initToggle()

  initToggle = ->
    $('#toggle-telegram').bootstrapToggle({
      on: 'On',
      off: 'Off',
      size: 'small'
    })

  { init: init }

EBS.Telegram_botsEdit = EBS.Telegram_botsNew
EBS.Telegram_botsCreate = EBS.Telegram_botsNew
EBS.Telegram_botsUpdate = EBS.Telegram_botsNew
