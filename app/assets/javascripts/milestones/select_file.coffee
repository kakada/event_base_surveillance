EBS.SelectFile = do ->
  init = ->
    onRemoveFile()
    onChangeFile()

  onRemoveFile = ->
    $(document).on 'click', '.remove-file', (e) =>
      wrapper = $(e.target).parents('.file-wrapper')

      wrapper.find('.file-input').parents('.form-group').removeClass('d-none')
      wrapper.find('.file-input-destroy').val(1)
      wrapper.find('.remove-file-wrapper').hide()

  onChangeFile = ->
    $(document).on 'change', '.file-input', (e) =>
      wrapper = $(e.target).parents('.file-wrapper')
      !!wrapper.find('.file-input-destroy') && wrapper.find('.file-input-destroy').val(0)

  { init: init }
