EBS.EventsFormsNew = do ->
  init = ->
    onChangeProvince()
    onChangeDistrict()
    onChangeCommune()
    onChangeVillage()
    console.log('hellow')

  onChangeProvince = ->
    $('#province .select-location').on 'change', (event)->
      setLocationValue(event)
      true

  onChangeDistrict = ->
    $('#district .select-location').on 'change', (event)->
      setLocationValue(event)
      true

  onChangeCommune = ->
    $('#commune .select-location').on 'change', (event)->
      setLocationValue(event)
      true

  onChangeVillage = ->
    $('#village .select-location').on 'change', (event)->
      setLocationValue(event)
      true

  setLocationValue = (event) ->
    $('.location').val(event.target.value)

  { init: init }
