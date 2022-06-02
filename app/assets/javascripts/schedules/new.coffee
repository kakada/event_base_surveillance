EBS.SchedulesNew = do ->
  init = ->
    updateDisplayTooltip();

    EBS.ChannelsForm.init()
    onClickTemplateField()
    onChangeScheduleNotify()

  onClickTemplateField = ->
    $(document).off 'click', '.template-field'
    $(document).on 'click', '.template-field', (e) ->
      value = '{{' + $(this).data('code') + '}}'
      EBS.Util.insertToTextbox('schedule_message', value)

      e.preventDefault()

  onChangeScheduleNotify = ->
    $(document).off 'change', '.schedule-notify .input'
    $(document).on 'change', '.schedule-notify .input', (e) ->
      updateDisplayTooltip()

  updateDisplayTooltip = ->
    str = $('.info').attr('data-info')
    keys = ['interval_value', 'interval_type', 'follow_up_hour']
    i = 0
    while i < keys.length
      dom = $('#schedule_' + keys[i])
      value = dom.find('option:selected').text() or dom.val()
      str = str.replace('%{' + keys[i] + '}', value)
      i++

    $('.info').attr('data-original-title', str)

  { init }

EBS.SchedulesCreate = EBS.SchedulesNew
EBS.SchedulesEdit = EBS.SchedulesNew
EBS.SchedulesUpdate = EBS.SchedulesNew
