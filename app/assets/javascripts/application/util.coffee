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

    console.log('pageName=', pageName)

    return pageName
