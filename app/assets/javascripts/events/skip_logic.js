EBS.EventsSkipLogic = ( () => {
  let operatorMethods = {
    '=': 'equalValidator',
    'match_any': 'matchAnyValidator',
    'match_all': 'matchAllValidator'
  }

  return {
    init,
    equalValidator,
    matchAllValidator,
    matchAnyValidator
  }

  function init() {
    triggerReleventField();
  }

  function triggerReleventField() {
    $(document).on('change', '[data-relevant]', (event) => {
      let fieldCode = $(event.target).data('relevant');
      let triggerValue = $(event.target).val().toLowerCase();
      $(`[data-code=${fieldCode}]`).each( (_i, field) => {
        operator = $(field).data('operator');
        EBS.EventsSkipLogic[operatorMethods[operator]](field, triggerValue);
      });
    });
  }

  function matchAnyValidator(field, triggerValue) {
    let values = $(field).data('value').split(',');
    const isMatch = values.includes(triggerValue);
    toggleField(field, isMatch);
  }

  function equalValidator(field, triggerValue) {
    let values = $(field).data('value').split(',');
    const isMatch = values == triggerValue;
    toggleField(field, isMatch);
  }

  function matchAllValidator(field, triggerValue) {
    let values = $(field).data('value').split(',');
    const isMatch = triggerValue.every(val => values.includes(val));
    toggleField(field, isMatch);
  }

  function toggleField(field, condition) {
    if (condition) {
      $(field).show();
    } else {
      $(field).hide();
    }
  }
})();