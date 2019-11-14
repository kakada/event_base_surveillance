EBS.EventsEvent_milestonesNew = do ->
  init = ->
    initSelectPicker()
    onChangeImage()
    onClickRemoveImage()
    onChangeFile()
    onClickRemoveFile()
    onClickAddFieldValueFile()
    initFirstFieldValueFile()
    initDatePicker()

  initDatePicker = ->
    $.fn.datepicker.defaults.format = "yyyy-mm-dd"
    $('.datepicker').datepicker()

  initFirstFieldValueFile = ->
    if !!$('form .add_field_values').length
      $('form .add_field_values').click()

  onClickAddFieldValueFile = ->
    $('form .add_field_values').off('click')
    $('form .add_field_values').on 'click', (event) ->
      appendField(this)
      event.preventDefault()

  appendField = (dom) ->
    time = new Date().getTime()
    regexp = new RegExp($(dom).data('id'), 'g')
    $(dom).before($(dom).data('fields').replace(regexp, time))

  onClickRemoveFile = ->
    $('.remove-file').off('click')
    $('.remove-file').on 'click', (event)->
      removeFile(event)
      event.preventDefault()

  removeFile = (event)->
    dom = event.currentTarget
    $(dom).hide()
    $(dom).next().hide()
    $(dom).prev().val(1)

  onChangeFile = ->
    $('.file-input').off('change')
    $('.file-input').change ->
      parent = $(this).parent()
      parent.find('input.destroy[type=hidden]').val(0)
      return

  initSelectPicker = ->
    $('.selectpicker').selectpicker();

  readURL = (input) ->
    if input.files and input.files[0]
      reader = new FileReader

      reader.onload = (e) ->
        parent = $(input).parent()
        img = parent.find('img')
        btnRemoveImage = parent.find('.remove-image')
        hiddenField = parent.find('input[type=hidden]')

        $(img).attr 'src', e.target.result
        $(btnRemoveImage).show()
        $(hiddenField).val('0')
        return

      reader.readAsDataURL input.files[0]
    return

  hideBtnRemove = (input)->
    $(input).prev('input[type=hidden]').val('1')
    $(input).hide()

  clearValueAndShowDefaultImage = (input)->
    parent = $(input).parent()
    img = parent.find('img')
    imgInput = parent.find('.image-input')

    $(img).attr 'src', $(img).data('default-image')
    $(imgInput).val('')

  onChangeImage = ->
    $('.image-input').off('change')
    $('.image-input').change ->
      readURL this
      return

  onClickRemoveImage = ->
    $('.remove-image').off('click')
    $('.remove-image').on 'click', (event)->
      clearValueAndShowDefaultImage(this)
      hideBtnRemove(this)

      event.preventDefault()

  { init: init }

EBS.EventsEvent_milestonesEdit = EBS.EventsEvent_milestonesNew
EBS.EventsEvent_milestonesUpdate = EBS.EventsEvent_milestonesNew
EBS.EventsEvent_milestonesCreate = EBS.EventsEvent_milestonesNew
