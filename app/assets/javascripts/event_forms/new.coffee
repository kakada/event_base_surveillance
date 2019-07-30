EBS.EventsFormsNew = do ->
  init = ->
    # onChangeProvince()
    # onChangeDistrict()
    # onChangeCommune()
    # onChangeVillage()
    onChangeImage()
    onClickRemoveImage()

  # onChangeProvince = ->
  #   $('#province .select-location').on 'change', (event)->
  #     setLocationValue(event)
  #     true

  # onChangeDistrict = ->
  #   $('#district .select-location').on 'change', (event)->
  #     setLocationValue(event)
  #     true

  # onChangeCommune = ->
  #   $('#commune .select-location').on 'change', (event)->
  #     $('event[properties][village_id]').val('')
  #     setLocationValue(event)
  #     true

  # onChangeVillage = ->
  #   $('#village .select-location').on 'change', (event)->
  #     setLocationValue(event)
  #     true

  # setLocationValue = (event) ->
  #   console.log('event===', event.target.value)
  #   $('.location').val(event.target.value)

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

      event.preventDefault();

  { init: init }
