EBS.Common.Sidebar = do ->
  init = ->
    handleActiveSidebar();
    onClickSidebar();

  handleActiveSidebar = ->
    cssClass = if localStorage.getItem('miniSidebar') == 'true' then 'active' else ''
    $('#sidebar').addClass cssClass

  onClickSidebar = ->
    $('.sidebarCollapse').on 'click', ->
      $('#sidebar').toggleClass 'active'
      localStorage.setItem('miniSidebar', $('#sidebar').hasClass('active'));

  { init: init }
