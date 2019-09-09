EBS.Event_typesNew = do ->
  init = ->
    setupColor()

  setupColor = ->
    $('input.color').minicolors theme: 'bootstrap'

  { init: init }

EBS.Event_typesCreate = EBS.Event_typesNew
EBS.Event_typesEdit = EBS.Event_typesNew
EBS.Event_typesUpdate = EBS.Event_typesNew
