EBS.MilestonesTelegram_notificationsNew = do ->
  init = ->
    initSelectPicker()

  initSelectPicker = ->
    $('.selectpicker').selectpicker();

  { init: init }

EBS.MilestonesTelegram_notificationsCreate = EBS.MilestonesTelegram_notificationsNew
EBS.MilestonesTelegram_notificationsEdit = EBS.MilestonesTelegram_notificationsNew
EBS.MilestonesTelegram_notificationsUpdate = EBS.MilestonesTelegram_notificationsNew
