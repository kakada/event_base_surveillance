EBS.ProgramsSettingsShow = do ->
  init = ->
    initToggle()
    initEmailToggle()
    onChangeToggle()
    onChangeEmailToggle()
    onChangeLanguage()
    onRemoveGuideline()
    onChangeGuideline()

    EBS.ProgramsNew.init()

  onChangeLanguage = ->
    $(document).off 'change', '#program_language_code'
    $(document).on 'change', '#program_language_code', (event)->
      _updateProgram({ language_code: this.value }, ->
        window.location.reload()
      )

  initToggle = ->
    $('.bt-toggle').bootstrapToggle({
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

  onChangeToggle = ->
    $(document).off 'change', '.bt-toggle'
    $(document).on 'change', '.bt-toggle', (event)->
      if $(this).prop('checked')
        $(this).parents('.modal-body').find('.collapse-section').removeClass('d-none')
      else
        $(this).parents('.modal-body').find('.collapse-section').addClass('d-none')

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

  onRemoveGuideline = ->
    $(document).on 'click', '.remove-guideline', (e) =>
      wrapper = $(e.target).parents('.guideline-wrapper')
      wrapper.find('.guideline-input').parent().removeClass('d-none')
      wrapper.find('.guideline-input-destroy').val(1)
      wrapper.find('.remove-guideline-wrapper').hide()

  onChangeGuideline = ->
    $(document).on 'change', '.guideline-input', (e) =>
      wrapper = $(e.target).parents('.guideline-wrapper')
      !!wrapper.find('.guideline-input-destroy') && wrapper.find('.guideline-input-destroy').val(0)

  {
    init,
    initToggle,
    onChangeToggle,
  }
