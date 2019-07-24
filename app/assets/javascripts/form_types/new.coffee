EBS.Event_typesForm_typesNew = do ->
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
      appendField(this);
      event.preventDefault()

  onClickAddFieldOption = ->
    $(document).on 'click', 'form .add_field_options', (event) ->
      appendField(this);
      event.preventDefault()

  onChangeSelectFieldType = ->
    $(document).on 'change', 'select[name*=field_type]', (event) ->
      dom = event.target
      if dom.value == 'select_one'
        disabledSelectFieldType(dom)
        showBtnAddSelectOption(dom)

  appendField = (dom) ->
    time = new Date().getTime()
    regexp = new RegExp($(dom).data('id'), 'g')
    $(dom).before($(dom).data('fields').replace(regexp, time))

  showBtnAddSelectOption = (dom)->
    optionsWrapper = $(dom).parents('.fieldset').find('.options-wrapper')
    optionsWrapper.show()
    optionsWrapper.find('.add_field_options').click()

  disabledSelectFieldType = (dom) ->
    $(dom).css('background-color', '#e9ecef')
    $(dom).next().show()

  { init: init }
