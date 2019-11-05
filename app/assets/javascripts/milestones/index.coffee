EBS.MilestonesIndex = do ->
  init = ->
    initSortable()

  initSortable = ->
    $(document).find('ol.fields').sortable
      handle: '.move'
      onDrop: ($item, container, _super) ->
        animateListItems($item, container, _super)
        updateMilestoneOrder()

  animateListItems = ($item, container, _super) ->
    $clonedItem = $('<li/>').css(height: 0)
    $item.before $clonedItem
    $clonedItem.animate 'height': $item.height()
    $item.animate $clonedItem.position(), ->
      $clonedItem.detach()
      _super $item, container
    return

  updateMilestoneOrder = ->
    ids = $('ol.fields li').map((i, v) => v.dataset.id).toArray()

    $.ajax({
      url: $('#form').attr('action'),
      data: {
        authenticity_token: $('[name="authenticity_token"]').val(),
        ids: ids
      },
      type: 'PUT',
      success: (result) ->
    });

  { init: init }
