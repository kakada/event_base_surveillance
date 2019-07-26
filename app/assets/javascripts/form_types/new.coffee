EBS.Event_typesForm_typesNew = do ->
  init = ->
    handleToggleOptionsWrapper()
    onClickAddField()
    onClickRemoveField()
    onClickAddFieldOption()
    onChangeSelectFieldType()
    setupSortable()

  handleToggleOptionsWrapper = ->
    $('select[name*=field_type]').each (index, dom) ->
      if dom.value == 'select_one'
        disabledSelectFieldType(dom)
        $(dom).parents('.fieldset').find('.options-wrapper').show()

  onClickRemoveField = ->
    $(document).on 'click', 'form .remove_fields', (event) ->
      $(this).prev('input[type=hidden]').val('1')
      $(this).closest('fieldset').hide()
      event.preventDefault()

  onClickAddField = ->
    $('form .add_fields').off('click')
    $('form .add_fields').on 'click', (event) ->
      appendField(this);
      event.preventDefault()

  onClickAddFieldOption = ->
    $(document).off('click', 'form .add_field_options')
    $(document).on 'click', 'form .add_field_options', (event) ->
      appendField(this);
      event.preventDefault()

  onChangeSelectFieldType = ->
    $(document).off('change', 'select[name*=field_type]')
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

  setupSortable = ->
    $(document).find('ol.fields').sortable
      handle: '.move'
      onDrop: ($item, container, _super) ->
        $clonedItem = $('<li/>').css(height: 0)
        $item.before $clonedItem
        $clonedItem.animate 'height': $item.height()
        $item.animate $clonedItem.position(), ->
          $clonedItem.detach()
          _super $item, container
          return
        return

  { init: init }
