EBS.ProgramsSettingsShow = do ->
  init = ->
    initToggle()
    onChangeTelegramToggle()

  initToggle = ->
    $('#toggle-telegram').bootstrapToggle({
      on: 'On',
      off: 'Off',
      size: 'small'
    });

  onChangeTelegramToggle = ->
    $(document).on 'change', '#toggle-telegram', (event)->
      $.ajax({
        url: $('.edit_program').attr('action'),
        data: {
          authenticity_token: $('[name="authenticity_token"]').val(),
          program: { enable_telegram: $(this).prop('checked') }
        },
        type: 'PUT',
        success: (result) ->
          # console.log(result)
      });

  { init: init }
