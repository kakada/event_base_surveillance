EBS.Sortable = do ->
  initFieldSortable = ->
    $(document).find('ol.fields.sortable').sortable
      handle: '.move'
      itemSelector: 'li.field'
      onDrop: ($item, container, _super) ->
        animateListItems($item, container, _super)
        assignDisplayOrderToListItem()

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

  initFieldOptionSortable = ->
    $(document).find('ol.field_options').sortable
      handle: '.move-option'
      itemSelector: 'li.option'
      exclude: 'add_field_options'
      onDrop: ($item, container, _super) ->
        animateListItems($item, container, _super)
        assignDisplayOrderToOption()

  assignDisplayOrderToOption = ->
    $('ol.field_options').each (index, group) ->
      $(group).children('li.option').each (index) ->
        $(this).find('.option-display-order').val(index)

  {
    initFieldSortable: initFieldSortable,
    initFieldOptionSortable: initFieldOptionSortable
  }
