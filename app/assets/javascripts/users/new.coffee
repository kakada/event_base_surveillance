EBS.UsersNew = do ->
  init = ->
    handleDisplayProgram()
    onChangeRole()

  handleDisplayProgram = ->
    if $('.role').val() != 'system_admin'
      $('.program').show()

  onChangeRole = ->
    $('.role').off('change')
    $('.role').on 'change', (event) ->
      if event.target.value == 'system_admin'
        $('.program').hide()
        $('.program select').val('')
      else
        $('.program').show()

      if event.target.value == 'staff' || event.target.value == 'guest'
        $('.province-code').show()
      else
        $('.province-code').hide()
        $('.province-code select').val('')

  { init: init }

EBS.UsersCreate = EBS.UsersNew
EBS.UsersEdit = EBS.UsersNew
EBS.UsersUpdate = EBS.UsersNew
