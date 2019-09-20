EBS.MilestonesTelegramsNew = do ->
  init = ->
    onClickTemplateField()

  onClickTemplateField = ->
    $('.template-field').off('click')
    $('.template-field').on 'click', (e) ->
      value = '{{' + $(this).data('code') + '}}'
      EBS.Util.insertAtCaret('notifications_telegram_message', value)

      e.preventDefault()

  { init: init }

EBS.MilestonesTelegramsCreate = EBS.MilestonesTelegramsNew
EBS.MilestonesTelegramsEdit = EBS.MilestonesTelegramsNew
EBS.MilestonesTelegramsUpdate = EBS.MilestonesTelegramsNew
