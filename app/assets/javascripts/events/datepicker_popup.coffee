EBS.DatepickerPopup = do ->
  init = ->
    initDisplayDate()
    initFilterDatePopover()

    onShownDatePopover()
    onChangeNumberInput()
    onChangeDateTypeInput()
    onClickBtnDone()
    onClickBtnReset()

  initFilterDatePopover = ->
    $('#filter-date').popover
      html : true
      title: ''
      sanitize: false
      placement: 'bottom'
      content: ->
        return $('.filter-date').data('html')

  onClickBtnReset = ->
    $(document).off 'click', '.btn-reset'
    $(document).on 'click', '.btn-reset', (e) ->
      resetBackupValue()
      resetPopoverValue()
      hideDatePopover()

  assignBackupValue = (num)->
    dateType = $('.date-type-input').val()
    startDate = $('.start-date-input').val()
    startDate = formatDate(startDate)

    $('.hidden-input').find('.number-input-backup').val(num)
    $('.hidden-input').find('.date-type-input-backup').val(dateType)
    $('.hidden-input').find('.start-date-input-backup').val(startDate)

  hideDatePopover = ->
    $('#filter-date').popover('hide')

  resetBackupValue = ->
    $('.hidden-input').find('.number-input-backup').val('')
    $('.hidden-input').find('.date-type-input-backup').val('')
    $('.hidden-input').find('.start-date-input-backup').val('')
    $('.display-date').val('')

  resetPopoverValue = ->
    $('.number-input').val('')
    $('.date-type-input').val('Day')
    $('.start-date-input').val('')

  onChangeNumberInput = ->
    $(document).off 'change', '.number-input'
    $(document).on 'change', '.number-input', (e)->
      if $(this).val() <= 0
        showError()
      else
        hideError()
        assignPopoverStartDate()

  showError = ->
    $('.number-input').addClass('is-invalid')
    $('.error-message').show()

  hideError = ->
    $('.number-input').removeClass('is-invalid')
    $('.error-message').hide()

  onChangeDateTypeInput = ->
    $(document).off 'change', '.date-type-input'
    $(document).on 'change', '.date-type-input', (e)->
      assignPopoverStartDate()

  onClickBtnDone = ->
    $(document).off 'click', '.btn-done'
    $(document).on 'click', '.btn-done', (e) ->
      num = $('.number-input').val()
      if num <= 0
        showError()
      else
        dateType = $('.date-type-input').val()
        assignBackupValue(num)
        assignDispalyDate(num, dateType)
        hideDatePopover()

  initDisplayDate = ->
    num = $('.hidden-input').find('.number-input-backup').val()
    startDate = $('.hidden-input').find('.start-date-input-backup').val()

    if num > 0
      dateType = $('.hidden-input').find('.date-type-input-backup').val()
      assignDispalyDate(num, dateType)
    else if !!startDate
      displayDate = new Date(startDate).toDateString() + '  =>  Now'
      $('.display-date').val(displayDate)

  assignDispalyDate = (num, dateType)->
    displayDate = 'Last ' + num + ' ' + dateType.toLowerCase()

    if num > 1
      displayDate += 's'

    $('.display-date').val(displayDate)

  onShownDatePopover = ->
    $('#filter-date').on 'shown.bs.popover', ->
      handlePopoverValue()
      initDateTimePicker()
      onChangeDatePicker()

  onChangeDatePicker = ->
    $('#datepicker').on 'changeDate', ->
      resetBackupValue()
      resetPopoverValue()

      startDate = $('#datepicker').datepicker('getFormattedDate')
      displayDate = new Date(startDate).toDateString() + '  =>  Now'

      $('.hidden-input').find('.start-date-input-backup').val(startDate)
      $('.display-date').val(displayDate)
      hideDatePopover()

  initDateTimePicker = ->
    startDate = $('.hidden-input').find('.start-date-input-backup').val() || new Date()
    $('#datepicker').datepicker('setDate', startDate)

  handlePopoverValue = ->
    num = $('.hidden-input').find('.number-input-backup').val()
    if num > 0
      dateType = $('.hidden-input').find('.date-type-input-backup').val()
      $('.number-input').val(num)
      $('.date-type-input').val(dateType)
      assignPopoverStartDate()

    handleActiveTab(num)

  handleActiveTab = (num) ->
    if num > 0
      $('#myTab a[href="#relative"]').tab('show')
    else
      $('#myTab a[href="#absolute"]').tab('show')

  assignPopoverStartDate = (num, dateType)->
    num = $('.number-input').val()
    dateType = $('.date-type-input').val()
    methodName = 'get' + dateType + '(new Date(), num)'
    # invoke getDate(new Date(), num)
    date = eval(methodName)
    $('.start-date-input').val(date.toDateString())

  formatDate = (date)->
    d = new Date(date)
    day = format2Digit(d.getDate())
    month = format2Digit(d.toLocaleDateString("en-US", { month: 'numeric' }))
    year = d.getFullYear()
    return year + '-' + month + '-' + day

  format2Digit = (num) ->
    ('0' + num).slice(-2)

  getDay = (date, num)->
    date.setDate(date.getDate() - num)
    return date

  getWeek = (date, num)->
    date.setDate(date.getDate() - num * 7)
    return date

  getMonth = (date, num)->
    date.setMonth(date.getMonth() - num)
    return date

  getYear = (date, num)->
    date.setFullYear(date.getFullYear() - num)
    return date


  { init: init }
