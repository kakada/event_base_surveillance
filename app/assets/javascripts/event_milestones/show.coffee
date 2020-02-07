EBS.EventsEvent_milestonesShow = do ->
  map = null

  init = ->
    EBS.EventsShow.initTruncate()
    EBS.EventsShow.onClickTracingTextModalTrigger()

  { init: init }
