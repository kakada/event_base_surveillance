$(document).on 'click', 'form .remove_fields', (event) ->
  $(this).prev('input[type=hidden]').val('1')
  $(this).closest('fieldset').hide()
  event.preventDefault()

$(document).on 'click', 'form .add_fields', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $(this).before($(this).data('fields').replace(regexp, time))
  event.preventDefault()

$(document).on 'change', 'select[name*=field_type]', (event) ->
  dom = event.target
  if dom.value == 'select_one'
    $(dom).attr('disabled', true);
    optionsWrapper = $(dom).parents('.fieldset').find('.options-wrapper')
    optionsWrapper.show()
    optionsWrapper.find('.add_fields').click();

  return

document.addEventListener 'turbolinks:load', ->
  handleToggleOptionsWrapper = ->
    $('select[name*=field_type]').each (index, dom) ->
      if dom.value == 'select_one'
        $(dom).attr('disabled', true);
        $(dom).parents('.fieldset').find('.options-wrapper').show();


  handleToggleOptionsWrapper();
