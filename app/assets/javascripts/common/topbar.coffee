EBS.Common.Topbar = do ->
  init = ->
    switchLanguage()
    onSubmitLanguage()

  switchLanguage = ->
    $('.switch-locale').on 'click', (e)->
      $('#user_locale').val($(e.currentTarget).data('locale'))
      Rails.fire($('#switch-locale')[0], 'submit')

  onSubmitLanguage = ->
    $('#switch-locale').on 'ajax:success', ->
      window.location.reload()

  { init: init }
