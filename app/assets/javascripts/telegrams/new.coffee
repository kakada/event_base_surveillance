EBS.MilestonesTelegramsNew = do ->
  init = ->
    showDefaultTemplateFields()
    onClickTemplateField()
    onClickSteper()

  onClickTemplateField = ->
    $(document).off 'click', '.template-field'
    $(document).on 'click', '.template-field', (e) ->
      value = '{{' + $(this).data('code') + '}}'
      EBS.Util.insertToTextbox('notifications_telegram_message', value)

      e.preventDefault()

  onClickSteper = ->
    $('ol > li:not(.inactive)').off 'click', 'span.number'
    $('ol > li:not(.inactive)').on 'click', 'span.number', (e) ->
      $('ol > li').removeClass('active')
      $(this).parent('li').addClass('active')

  showDefaultTemplateFields = ->
    $('ol li:first').addClass('active')

  { init: init }

EBS.MilestonesTelegramsCreate = EBS.MilestonesTelegramsNew
EBS.MilestonesTelegramsEdit = EBS.MilestonesTelegramsNew
EBS.MilestonesTelegramsUpdate = EBS.MilestonesTelegramsNew
