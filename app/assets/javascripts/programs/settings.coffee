EBS.ProgramsSettingsShow = do ->
  init = ->
    initToggle()
    onChangeTelegramToggle()
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
    });

  onChangeTelegramToggle = ->
    $(document).off 'change', '#toggle-telegram'
    $(document).on 'change', '#toggle-telegram', (event)->
      _updateProgram({ enable_telegram: $(this).prop('checked') })

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
