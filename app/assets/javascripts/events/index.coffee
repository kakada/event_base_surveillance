EBS.EventsIndex = do ->
  init = ->
    EBS.DateRangePicker.init()
    EBS.FollowUp.init()

    initFilterKeywordPopover()
    onClickKeywordItem()
    onClickBtnDownload()

    handleDisplayCollapseContent()
    onShowCollapse()
    onHideCollapse()

  handleDisplayCollapseContent = ->
    if window.localStorage.getItem('show_collapse') == "true"
      $('#collapseFilter').addClass('show')
      hideArrowDown()

  onShowCollapse = ->
    $('.collapse').on 'show.bs.collapse', ()->
      window.localStorage.setItem('show_collapse', true)
      hideArrowDown()

  onHideCollapse = ->
    $('.collapse').on 'hide.bs.collapse', ->
      window.localStorage.setItem('show_collapse', false)
      showArrowDown()

  showArrowDown = ->
    $('.advance-search i').removeClass('fa-angle-up')
    $('.advance-search i').addClass('fa-angle-down')

  hideArrowDown = ->
    $('.advance-search i').removeClass('fa-angle-down')
    $('.advance-search i').addClass('fa-angle-up')

  initFilterKeywordPopover = ->
    $('[data-toggle="popover"]').popover()
    $(document).off 'click', '[data-toggle="popover"]'
    $(document).on 'click', '[data-toggle="popover"]', (e)->
      e.preventDefault()

  onClickKeywordItem = ->
    $(document).off 'click', '.field-code'
    $(document).on 'click', '.field-code', (e)->
      value = $(this).html() + ' : '
      EBS.Util.insertToTextbox('keyword', value)
      $('#keyword').focus()

  onClickBtnDownload = ->
    $(document).off 'click', '.btn-download'
    $(document).on 'click', '.btn-download', (e)->
      e.preventDefault()

      $('#template-model').modal('hide')
      downloadEvent(this)

  downloadEvent = (dom)->
    url = $(dom).attr('href') + '?' + $('.filter-form').serialize()

    window.open(url, '_blank')

  { init: init }
