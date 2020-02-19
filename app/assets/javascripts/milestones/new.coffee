EBS.MilestonesNew = do ->
  selectOne = 'Fields::SelectOneField'
  selectMultiple = 'Fields::SelectMultipleField'
  mappingField = 'Fields::MappingField'
  dateField = 'Fields::DateField'
  dateTimeField = 'Fields::DateTimeField'
  integerField = 'Fields::IntegerField'

  init = ->
    initView()
    initSortable()
    initMiniColorPicker()
    initSetting()

    onClickAddSection()
    onClickAddField()
    onClickRemoveField()
    onClickAddFieldOption()
    onChooseFieldType()
    onChangeMappingField()
    onClickCollapseTrigger()
    onClickBtnAdd()
    onClickRequireCheckbox()
    onClickSettingItem()
    onClickBtnSetting()
    EBS.SkipLogic.init()

  onClickBtnSetting = ->
    $(document).off 'click', '.btn-setting'
    $(document).on 'click', '.btn-setting', ->
      toggleSettingContent(this)
      hideCollapseContent(this)

  toggleSettingContent = (dom)->
    $(dom).parents('.fieldset').find('.btn-setting').toggleClass('active')
    $(dom).parents('.fieldset').find('.setting-wrapper').toggle()

  hideSettingContent = (dom)->
    $(dom).parents('.fieldset').find('.btn-setting').removeClass('active')
    $(dom).parents('.fieldset').find('.setting-wrapper').hide()

  initSetting = ->
    $('.item-setting').addClass('active')
    $('.setting-content').show()

  onClickSettingItem = ->
    $(document).off 'click', '.setting-wrapper .item'
    $(document).on 'click', '.setting-wrapper .item', (event) ->
      $(this).parents('.setting-wrapper').find('.content').hide()
      $(this).parents('.setting-wrapper').find('.item').removeClass('active')
      $(this).parents('.setting-wrapper').find($(this).data('target')).show()
      $(this).addClass('active')

  onClickRequireCheckbox = ->
    $(document).off 'click', '.field-required'
    $(document).on 'click', '.field-required', (e)->
      $(this).parents('.fieldset').find('.abbr-required').toggleClass('hidden')

  initView = ->
    $('input.field-type').each (index, dom) ->
      return unless dom.value
      initBtnMove(dom)
      initFieldNameStyleAsTitle(dom)
      initCollapseContent(dom)
      initValidationView(dom)

  # Validation-----------start
  initValidationView = (dom)->
    if isValidationFieldType(dom.value)
      removeNoneUseValidator(dom)
    else
      hideValidationTrigger(dom)
      removeValidationContent(dom)

  isValidationFieldType = (value)->
    return [dateField, dateTimeField, integerField].includes(value)

  hideValidationTrigger = (dom) ->
    $(dom).parents('.fieldset').find('.validation-trigger').hide()

  removeNoneUseValidator = (dom)->
    parent = $(dom).parents('.fieldset')
    fieldType = $(parent).find('input.field-type').val()
    noneUseValidators = $(parent).find('.type-validation:not([data-validation_type="' + fieldType + '"])')
    noneUseValidators.remove()

  removeValidationContent = (dom) ->
    parent = $(dom).parents('.fieldset')
    $(parent).find('.field-validation-wrapper').remove()

    #handle it when choose fieldType
  handleValidation = (dom, field_type) ->
    if isValidationFieldType(field_type)
      removeNoneUseValidator(dom)
    else
      hideValidationTrigger(dom)
      removeValidationContent(dom)

  # Validation-----------end

  initCollapseContent = (dom) ->
    hideCollapseContent(dom)

    if dom.value == selectOne || dom.value == selectMultiple
      showCollapseTrigger(dom)
      showOption(dom)
    else if dom.value == mappingField
      showMappingField(dom)
      showCollapseTrigger(dom)
    return

  hideCollapseContent = (dom)->
    $(dom).parents('.fieldset').find('.collapse-content').hide()

  showCollapseTrigger = (dom)->
    $(dom).parents('.fieldset').find('.collapse-trigger').show()

  handleDisplayOptionColor = (dom)->
    data = $(dom).data('field')

    if !data
      return

    if data.color_required
      visibleColorFieldOption(dom)

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

  hideColorFieldOption = (dom)->
    $(dom).parents('.fieldset').find('.options-wrapper').removeClass('visible-color')

  onClickBtnAdd = ->
    $(document).off('click', '.btn-add-field')
    $(document).on 'click', '.btn-add-field', (event) ->
      $(this).hide()
      parent = $(event.currentTarget).parents('.fieldset')
      parent.find('.field-type-wrapper').show()
      parent.find('.field-name').addClass('no-style')

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
        hideSettingContent(this)
      else
        icon.addClass('fa-caret-right')
        icon.removeClass('fa-caret-down')

  hideCollapseContent = (dom)->
    icon = $(dom).parents('.fieldset').find('.collapse-trigger i')
    icon.addClass('fa-caret-right')
    icon.removeClass('fa-caret-down')
    $(dom).parents('.fieldset').find('.collapse-content').hide()

  # for both remove field and remove option
  onClickRemoveField = ->
    $(document).on 'click', 'form .remove_fields', (event) ->
      $(this).parent().find('input[type=hidden]').val('1')
      $(this).closest('fieldset').hide()
      event.preventDefault()

  onClickAddSection = ->
    $('form .add_sections').off('click')
    $('form .add_sections').on 'click', (event) ->
      appendField(this)
      event.preventDefault()

  onClickAddField = ->
    $(document).off('click', 'form .add_fields')
    $(document).on 'click', 'form .add_fields', (event) ->
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
      handleValidation(dom, field_type)
      showBtnSetting(dom)

  showBtnSetting = (dom)->
    $(dom).parents('.fieldset').find('.btn-setting').removeClass('hidden')
    $(dom).parents('.fieldset').find('.item-setting').click()

  setFieldNameInputAsTitleStyle = (dom) ->
    fieldName = $(dom).parents('.fieldset').find('.field-name')
    fieldName.addClass('as-title')

  handleCollapseContent = (dom, field_type) ->
    if field_type == selectOne || field_type == selectMultiple
      showOption(dom)
      initOneOption(dom)
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
    $(dom).parents('.fieldset').find('.mapping-field-wrapper').show()

  assignBtnMove = (dom) ->
    btnMove = $(dom).parents('.fieldset').find('.move')
    btnMove.empty()
    btnMove.append($($(dom).find('.icon')).clone())
    btnMove.show()

  onChangeMappingField = ->
    $(document).off('change', 'select.mapping-field')
    $(document).on 'change', 'select.mapping-field', (event)->
      assignMappingFieldType(event.target)
      # handleToggleOption(event.target)

  handleToggleOption = (dom)->
    data = $(dom).find(':selected').data('obj')

    if data.field_type == selectOne || data.field_type == selectMultiple
      showOption(dom)
      initOneOption(dom)

      if data.color_required
        visibleColorFieldOption(dom)
    else
      hideOption(dom)
      hideColorFieldOption(dom)

  showOption = (dom)->
    $(dom).parents('.fieldset').find('.options-wrapper').show()
    handleDisplayOptionColor(dom)

  hideOption = (dom)->
    $(dom).parents('.fieldset').find('.options-wrapper').hide()
    clearAllOptions(dom)

  clearAllOptions = (dom)->
    $(dom).parents('.fieldset').find('.options-wrapper .remove_fields').click()

  assignMappingFieldType = (dom)->
    data = $(dom).find(':selected').data('obj').field_type
    $(dom).parent('.wrapper').find('.mapping-field-type').html(data)

  assignFieldType = (dom, field_type)->
    fieldType = $(dom).parents('.fieldset').find('.field-type')
    fieldType.val(field_type)

  appendField = (dom) ->
    time = new Date().getTime()
    regexp = new RegExp($(dom).data('id'), 'g')
    field = $($(dom).data('fields').replace(regexp, time))
    field.find('.btn-setting').addClass('hidden')

    $(dom).before(field)
    assignDisplayOrderToListItem()

  initOneOption = (dom)->
    $(dom).parents('.fieldset').find('.add_field_options').click()

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
