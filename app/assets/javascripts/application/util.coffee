EBS.Util =
  capitalize: (value) ->
    value.replace /(^|\s)([a-z])/g, (m, p1, p2) ->
      p1 + p2.toUpperCase()

  getCurrentPage: ->
    return "" if(!$("body").attr("id"))
    bodyId = $("body").attr("id").split("-")
    action = @capitalize(bodyId.pop())
    controller = bodyId
    i = 0
    while i < controller.length
      controller[i] = @capitalize(controller[i])
      i++
    pageName = controller.join("") + action

    return pageName

  insertToTextbox: (areaId, text) ->
    txtarea = document.getElementById(areaId)
    if !txtarea
      return
    scrollPos = txtarea.scrollTop
    strPos = 0
    br = if txtarea.selectionStart or txtarea.selectionStart == '0' then 'ff' else if document.selection then 'ie' else false
    if br == 'ie'
      txtarea.focus()
      range = document.selection.createRange()
      range.moveStart 'character', -txtarea.value.length
      strPos = range.text.length
    else if br == 'ff'
      strPos = txtarea.selectionStart
    front = txtarea.value.substring(0, strPos)
    back = txtarea.value.substring(strPos, txtarea.value.length)
    txtarea.value = front + text + back
    strPos = strPos + text.length
    if br == 'ie'
      txtarea.focus()
      ieRange = document.selection.createRange()
      ieRange.moveStart 'character', -txtarea.value.length
      ieRange.moveStart 'character', strPos
      ieRange.moveEnd 'character', 0
      ieRange.select()
    else if br == 'ff'
      txtarea.selectionStart = strPos
      txtarea.selectionEnd = strPos
      txtarea.focus()
    txtarea.scrollTop = scrollPos
    return
