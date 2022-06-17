EBS.SchedulesNew = do ->
  init = ->
    initTagify()
    updateDisplayDateIndex()
    updateDisplayTooltip()

    EBS.ChannelsForm.init()
    onClickTemplateField()
    onChangeIntervalType()
    onChangeScheduleNotify()
    onSubmitScheduleForm()

  initTagify = ->
    inputEmail = document.getElementById('schedule_emails')

    return unless !!inputEmail

    new Tagify inputEmail,
      pattern: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
      whitelist: $(inputEmail).data('emails'),
      dropdown: { maxItems: 20, classname: "tags-look", enabled: 0, closeOnSelect: false }

  onSubmitScheduleForm = ->
    $('.form-wrapper form').on 'submit', (e)->
      assignEmails()

  assignEmails = ->
    inputEmail = $('#schedule_emails')

    if inputEmail.val().length
      transformValue = JSON.parse(inputEmail.val()).map((x) => x.value)
      inputEmail.val('{' + transformValue.join(',') + '}')

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

  onChangeIntervalType = ->
    $(document).on 'change', '#schedule_interval_type', (e) ->
      updateDisplayDateIndex()

  updateDisplayTooltip = ->
    str = $('.info').attr('data-info')
    keys = ['interval_value', 'interval_type', 'follow_up_hour']
    i = 0
    while i < keys.length
      dom = $('#schedule_' + keys[i])
      value = dom.find('option:selected').text() or dom.val()
      str = str.replace('%{' + keys[i] + '}', value)
      i++

    # replace date_index
    str = replaceDateIndex(str)

    $('.info').attr('data-original-title', str)

  replaceDateIndex = (str)->
    interval_type = $('#schedule_interval_type').val()
    dateIndex = $('#schedule_date_index').val()
    dateString = ""

    if parseInt(dateIndex) > -1
      dateString = calendar()[interval_type][dateIndex]

    str = str.replace('%{date_index}', dateString)
    str

  updateDisplayDateIndex = ->
    interval_type = $('#schedule_interval_type').val()
    dateIndexSelect = $('.date-index select')

    if interval_type == 'day'
      $('.date-index').hide()
      dateIndexSelect.html('')
    else
      $('.date-index').show()
      dateIndexSelect.html(buildOptions(interval_type))
      dateIndexSelect.val(dateIndexSelect.data('value'))
      dateIndexSelect.data('value', 1)

  buildOptions = (interval_type) ->
    options = []

    for value,label of calendar()[interval_type]
      options.push("<option value='"+ value + "'>" + label + "</option>")

    return options

  calendar = ->
    obj = { week: {}, month: {} }
    week_days = $('.date-index').data('week') || []
    i = 0
    while i < 7
      obj.week[i] = week_days[i]
      i++

    i = 1
    while i < 32
      obj.month[i] = i
      i++

    return obj

  { init }

EBS.SchedulesCreate = EBS.SchedulesNew
EBS.SchedulesEdit = EBS.SchedulesNew
EBS.SchedulesUpdate = EBS.SchedulesNew
