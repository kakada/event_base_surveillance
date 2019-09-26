EBS.UsersIndex = do ->
  init = ->

    onClickBtnCopyConfirmLink()

  onClickBtnCopyConfirmLink = ->
    $(document).off('click', '.btn-copy')
    $(document).on 'click', '.btn-copy', (event)->
      input = $(this).prev('input.confirm-link')
      input.select()
      document.execCommand("copy")

      event.preventDefault()
      $('.toast').toast('show')


  { init: init }
