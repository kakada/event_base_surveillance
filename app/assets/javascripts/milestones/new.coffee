EBS.MilestonesNew = do ->
  selectOne = 'Fields::SelectOneField'
  selectMultiple = 'Fields::SelectMultipleField'
  mappingField = 'Fields::MappingField'

  init = ->
    initView()
    initSortable()
    initMiniColorPicker()

    onClickAddField()
    onClickRemoveField()
    onClickAddFieldOption()
    onChooseFieldType()
    onChangeMappingField()
    onClickCollapseTrigger()
    onClickBtnAdd()

  initView = ->
    $('input.field-type').each (index, dom) ->
      return unless dom.value
      initBtnMove(dom)
      initFieldNameStyleAsTitle(dom)
      initCollapseContent(dom)

  initCollapseContent = (dom) ->
    parentDom = $(dom).parents('.fieldset')
    parentDom.find('.collapse-content').hide()

    if dom.value == selectOne || dom.value == selectMultiple
      parentDom.find('.collapse-trigger').show()
      parentDom.find('.options-wrapper').show()
    else if dom.value == mappingField
      parentDom.find('.collapse-trigger').show()
      parentDom.find('.mapping-field-wrapper').show()
      parentDom.find('.options-wrapper').show()
      visibleColorFieldOption(dom)
    return

  initFieldNameStyleAsTitle = (dom) ->
    parentDom = $(dom).parents('.fieldset')
    parentDom.find('.field-name').addClass('no-style as-title')
    parentDom.find('.btn-add-field').hide()

  initBtnMove = (dom)->
    parentDom = $(dom).parents('.fieldset')
    icon = parentDom.find("[data-field_type='" + dom.value + "'] .icon").clone()
    btnMove = parentDom.find('.move')
    btnMove.empty()
    btnMove.append(icon)
    btnMove.show()

  visibleColorFieldOption = (dom)->
    $(dom).parents('.fieldset').find('.options-wrapper').addClass('visible-color')
    initMiniColorPicker()

  onClickBtnAdd = ->
    $(document).off('click', '.btn-add-field')
    $(document).on 'click', '.btn-add-field', (event) ->
      $(this).hide()
      parent = $(event.currentTarget).parents('.fieldset')
      fieldTypeWrapper = parent.find('.field-type-wrapper')
      fieldTypeWrapper.show()

      fieldName = parent.find('.field-name')
      fieldName.addClass('no-style')

  onClickCollapseTrigger = ->
    $(document).off('click', '.collapse-trigger')
    $(document).on 'click', '.collapse-trigger', (event) ->
      dom = event.currentTarget
      content = $(dom).parents('.fieldset').find('.collapse-content')
      icon = $($(dom).find('i'))

      content.toggle()

      if $(content).is(":visible")
        icon.removeClass('fa-caret-right')
        icon.addClass('fa-caret-down')
      else
        icon.addClass('fa-caret-right')
        icon.removeClass('fa-caret-down')

  onClickRemoveField = ->
    $(document).on 'click', 'form .remove_fields', (event) ->
      $(this).prev('input[type=hidden]').val('1')
      $(this).closest('fieldset').hide()
      event.preventDefault()

  onClickAddField = ->
    $('form .add_fields').off('click')
    $('form .add_fields').on 'click', (event) ->
      appendField(this)
      event.preventDefault()

  onClickAddFieldOption = ->
    $(document).off('click', 'form .add_field_options')
    $(document).on 'click', 'form .add_field_options', (event) ->
      appendField(this)
      initMiniColorPicker()
      event.preventDefault()

  onChooseFieldType = ->
    $(document).off('click', '.field-type-list')
    $(document).on 'click', '.field-type-list', (event) ->
      dom = event.currentTarget
      field_type = $(dom).data('field_type')

      setFieldNameInputAsTitleStyle(dom)
      assignBtnMove(dom)
      assignFieldType(dom, field_type)
      handleCollapseContent(dom, field_type)

  setFieldNameInputAsTitleStyle = (dom) ->
    fieldName = $(dom).parents('.fieldset').find('.field-name')
    fieldName.addClass('as-title')

  handleCollapseContent = (dom, field_type) ->
    if field_type == selectOne || field_type == selectMultiple
      showBtnAddSelectOption(dom)
      showArrowDownIcon(dom)
    else if field_type == mappingField
      showMappingField(dom)
      showArrowDownIcon(dom)

    hideFieldTypeList(dom)

  showArrowDownIcon = (dom)->
    icon = $(dom).parents('.fieldset').find('.collapse-trigger i')
    icon.removeClass('fa-caret-right')
    icon.addClass('fa-caret-down')

    btnCollapseTrigger = $(dom).parents('.fieldset').find('.collapse-trigger')
    btnCollapseTrigger.show()

  hideFieldTypeList = (dom)->
    fieldTypeWrapper = $(dom).parents('.fieldset').find('.field-type-wrapper')
    fieldTypeWrapper.hide()

  showMappingField = (dom) ->
    mappingFieldWrapper = $(dom).parents('.fieldset').find('.mapping-field-wrapper')
    mappingFieldWrapper.show()

  assignBtnMove = (dom) ->
    btnMove = $(dom).parents('.fieldset').find('.move')
    btnMove.empty()
    btnMove.append($($(dom).find('.icon')).clone())
    btnMove.show()

  onChangeMappingField = ->
    $(document).off('change', 'select.mapping-field')
    $(document).on 'change', 'select.mapping-field', (event)->
      setMappingFieldType(event.target)
      visibleColorFieldOption(event.currentTarget)

  setMappingFieldType = (dom)->
    field_type = $(dom).find(':selected').data('field_type')
    $(dom).next().val(field_type)
    assignFieldType(dom, mappingField)

    if field_type == selectOne || field_type == selectMultiple
      showBtnAddSelectOption(dom)
      return

  assignFieldType = (dom, field_type)->
    fieldType = $(dom).parents('.fieldset').find('.field-type')
    fieldType.val(field_type)

  appendField = (dom) ->
    time = new Date().getTime()
    regexp = new RegExp($(dom).data('id'), 'g')
    $(dom).before($(dom).data('fields').replace(regexp, time))
    assignDisplayOrderToListItem()

  showBtnAddSelectOption = (dom)->
    optionsWrapper = $(dom).parents('.fieldset').find('.options-wrapper')
    optionsWrapper.show()
    optionsWrapper.find('.add_field_options').click()

  animateListItems = ($item, container, _super) ->
    $clonedItem = $('<li/>').css(height: 0)
    $item.before $clonedItem
    $clonedItem.animate 'height': $item.height()
    $item.animate $clonedItem.position(), ->
      $clonedItem.detach()
      _super $item, container
    return

  assignDisplayOrderToListItem = ->
    $('ol.fields li').each (index)->
      $(this).find('.display-order').val(index)

  initSortable = ->
    $(document).find('ol.fields.sortable').sortable
      handle: '.move'
      onDrop: ($item, container, _super) ->
        animateListItems($item, container, _super)
        assignDisplayOrderToListItem()

  initMiniColorPicker = ->
    $(document).find('input.field-option-color').minicolors()

  { init: init }

EBS.MilestonesCreate = EBS.MilestonesNew
EBS.MilestonesEdit   = EBS.MilestonesNew
EBS.MilestonesUpdate = EBS.MilestonesNew
