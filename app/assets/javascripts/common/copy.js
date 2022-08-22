EBS.Common.Copy = (() => {
  return {
    init
  }

  function init() {
    onClickBtnCopy();
  }

  function onClickBtnCopy() {
    $(document).off('click', '.btn-copy');
    $(document).on('click', '.btn-copy', function(event) {
      event.preventDefault();

      copyCode(this);
      handleNotifyMessage(this);
    })
  }

  function copyCode(dom) {
    $(dom).prev('input.input-for-copy').select();
    document.execCommand("copy");
  }

  function handleNotifyMessage(dom) {
    $(dom).hide();
    showBtnCheck(dom);

    setTimeout(function() {
      hideBtnCheck(dom);
      $(dom).show();
    }, 500);
  }

  function showBtnCheck(dom) {
    $(dom).next('.btn-check').removeClass('d-none');
    $(dom).next('.btn-check').tooltip('show');
  }

  function hideBtnCheck(dom) {
    $(dom).next('.btn-check').tooltip('hide');
    $(dom).next('.btn-check').addClass('d-none');
  }

})();
