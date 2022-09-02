EBS.FollowUp = (() => {
  return { init }

  function init() {
    onClickBtnResolve();
  }

  function onClickBtnResolve() {
    $(document).on('click', '.btn-resolve', function(e) {
      e.preventDefault();

      setResolve($(e.target));
    })
  }

  function setResolve(btnResolve) {
    let popOverWrapper = btnResolve.parents('.popover');
    let btnPopover = $(`[aria-describedby='${popOverWrapper.attr('id')}']`);
    let token = btnPopover.find(`[name='authenticity_token']`).val();

    showLoading(btnResolve);

    $.ajax({
      url: btnResolve.attr('href'),
      type: 'PUT',
      data: {authenticity_token: token},
      success: function(data) {
        showLabelResolved(btnResolve);
        hideBtnResolve(btnResolve);
        replaceOrginalPopupContent(btnPopover, popOverWrapper.find('.popover-body').html());
      }
    });
  }

  function showLoading(btnResolve) {
    btnResolve.addClass('disabled');
    btnResolve.html(`${btnResolve.html()}...`);
  }

  function hideBtnResolve(btnResolve) {
    btnResolve.addClass('d-none');
  }

  function showLabelResolved(btnResolve) {
    btnResolve.parents('.card').find('.flag').removeClass('d-none');
  }

  function replaceOrginalPopupContent(btnPopover, newHtmlContent) {
    btnPopover.attr('data-content', newHtmlContent);
  }

})();
