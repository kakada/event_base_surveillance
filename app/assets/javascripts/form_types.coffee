document.addEventListener 'turbolinks:load', ->
  init = ->
    handleToggleOptionsWrapper()
    onClickAddField()
    onClickRemoveField()
    onClickAddFieldOption()
    onChangeSelectFieldType()

  handleToggleOptionsWrapper = ->
    $('select[name*=field_type]').each (index, dom) ->
      if dom.value == 'select_one'
        disabledSelectFieldType(dom)
        $(dom).parents('.fieldset').find('.options-wrapper').show();

  onClickRemoveField = ->
    $(document).on 'click', 'form .remove_fields', (event) ->
      $(this).prev('input[type=hidden]').val('1')
      $(this).closest('fieldset').hide()
      event.preventDefault()

  onClickAddField = ->
    $(document).on 'click', 'form .add_fields', (event) ->
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      $(this).before($(this).data('fields').replace(regexp, time))
      event.preventDefault()

  onClickAddFieldOption = ->
    $(document).on 'click', 'form .add_field_options', (event) ->
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      $(this).before($(this).data('fields').replace(regexp, time))
      event.preventDefault()

  onChangeSelectFieldType = ->
    $(document).on 'change', 'select[name*=field_type]', (event) ->
      dom = event.target
      if dom.value == 'select_one'
        disabledSelectFieldType(dom)
        showBtnAddSelectOption(dom)

  showBtnAddSelectOption = (dom)->
    optionsWrapper = $(dom).parents('.fieldset').find('.options-wrapper')
    optionsWrapper.show()
    optionsWrapper.find('.add_field_options').click()

  disabledSelectFieldType = (dom) ->
    $(dom).css('background-color', '#e9ecef')
    $(dom).next().show()

  init();
