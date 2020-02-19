EBS.ProgramsSettingsShow = do ->
  init = ->
    initToggle()
    initEmailToggle()
    onChangeTelegramToggle()
    onChangeEmailToggle()
    onChangeLanguage()

  onChangeLanguage = ->
    $(document).off 'change', '#program_language_code'
    $(document).on 'change', '#program_language_code', (event)->
      _updateProgram({ language_code: this.value }, ->
        window.location.reload()
      )

  initToggle = ->
    $('#toggle-telegram').bootstrapToggle({
      on: 'On',
      off: 'Off',
      size: 'small'
    })

  initEmailToggle = ->
    $('#program_enable_email_notification').bootstrapToggle();

  onChangeEmailToggle = ->
    $(document).off 'change', '#program_enable_email_notification'
    $(document).on 'change', '#program_enable_email_notification', (event)->
      _updateProgram({ enable_email_notification: $(event.target).prop('checked') })

  onChangeTelegramToggle = ->
    $(document).off 'change', '#toggle-telegram'
    $(document).on 'change', '#toggle-telegram', (event)->
      if $(this).prop('checked')
        $('.tokens').removeClass('hidden')
      else
        $('.tokens').addClass('hidden')

  _updateProgram = (params={}, callback)->
    $.ajax({
      url: $('.edit_program').attr('action'),
      data: {
        authenticity_token: $('[name="authenticity_token"]').val(),
        program: params
      },
      type: 'PUT',
      success: (result) ->
        !!callback && callback()
    });

  { init: init }
