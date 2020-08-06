EBS.Event_typesNew = do ->
  init = ->
    setupColor()
    onRemoveGuideline()
    onChangeGuideline()

  setupColor = ->
    $('input.color').minicolors theme: 'bootstrap'

  onRemoveGuideline = ->
    $(document).on 'click', '.remove-guideline', () =>
      $('.guideline-input').removeClass('d-none')
      $('#event_type_remove_guideline').val(1)
      $('.remove-wrapper').hide();

  onChangeGuideline = ->
    $('.guideline-input input').on 'change', () =>
      !!$('#event_type_remove_guideline') && $('#event_type_remove_guideline').val(0)

  { init: init }

EBS.Event_typesCreate = EBS.Event_typesNew
EBS.Event_typesEdit = EBS.Event_typesNew
EBS.Event_typesUpdate = EBS.Event_typesNew
