EBS.FollowUpForm = (() => {
  return { init }

  function init() {
    handleDisplayChannel();
    onChangeCheckboxChannel();
    initTooltip();
  }

  function handleDisplayChannel() {
    for(let i=0; i<$('.channel').length; i++) {
      toggleActiveChannel($('.channel')[i]);
    }
  }

  function onChangeCheckboxChannel() {
    $('.channel').change(function(e) {
      toggleActiveChannel(this);
    })
  }

  function toggleActiveChannel(channelDom) {
    $(channelDom).toggleClass('active', $(channelDom).find('[type="checkbox"]').is(":checked"))
  }

  function initTooltip() {
    $('[data-toggle="tooltip"]').tooltip();
  }
})();
