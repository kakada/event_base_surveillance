EBS.EventsEvent_milestonesShow = do ->
  map = null

  init = ->
    EBS.EventsShow.initTruncate()
    EBS.EventsShow.onClickTracingTextModalTrigger()
    EBS.EventsSkipLogic.renderSkipLogicField()

  { init: init }
