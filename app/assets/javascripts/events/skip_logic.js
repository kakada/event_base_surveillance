EBS.EventsSkipLogic = ( () => {
  let operatorMethods = {
    '=': 'equalValidator',
    '!=': 'notValidator',
    'in': 'matchAnyValidator',
    'match_all': 'matchAllValidator'
  }

  return {
    init,
    equalValidator,
    matchAllValidator,
    matchAnyValidator,
    notValidator
  }

  function init() {
    renderSkipLogicField();
    addEventToRelevantField();
    onFormSubmit();
  }

  function onFormSubmit() {
    $('.event-form-wrapper form').submit( () => {
      $('[data-code].hidden').each( (_i, field) => {
        $(field).find('.skip-logic-field').val('');
      })
    });
  }

  function renderSkipLogicField() {
    $('[data-relevant]').each( (_i, field) => {
      togglerFields(field);
    });
  }

  function togglerFields(field) {
    let fieldCode = $(field).data('relevant');
    let triggerValue;

    if (typeof $(field).val() == 'string') {
      triggerValue = $(field).val().toLowerCase();
    }  else {
      triggerValue = $(field).val().join(',').toLowerCase();
    }

    $(`[data-code=${fieldCode}]`).each( (_i, field) => {
      operator = $(field).data('operator');
      EBS.EventsSkipLogic[operatorMethods[operator]](field, triggerValue);
    });
  }

  function addEventToRelevantField() {
    $(document).on('change', '[data-relevant]', (event) => {
      togglerFields(event.target);
    });
  }

  function matchAnyValidator(field, triggerValue) {
    let values = $(field).data('value').split(',');
    let isMatch = false;
    const triggerValues = triggerValue.split(',');
    for(let i = 0; i < triggerValues.length; i++) {
      if (values.includes(triggerValues[i])) {
        isMatch = true;
        break;
      }
    }

    toggleField(field, isMatch);
  }

  function equalValidator(field, triggerValue) {
    let values = $(field).data('value').split(',');
    const isMatch = values == triggerValue;
    toggleField(field, isMatch);
  }

  function notValidator(field, triggerValue) {
    let values = $(field).data('value').split(',');
    let isMatch = true;
    let triggerValues = triggerValue.split(',');
    for(let i = 0; i < triggerValues.length; i++) {
      if (values.includes(triggerValues[i])) {
        isMatch = false;
        break;
      }
    }

    toggleField(field, isMatch);
  }

  function matchAllValidator(field, triggerValue) {
    let values = $(field).data('value').split(',');
    let triggerValues = triggerValue.split(',');
    let isMatch = true;
    for(let i = 0; i < values.length; i++) {
      if (!triggerValues.includes(values[i])) {
        isMatch = false;
        break;
      }
    }

    toggleField(field, isMatch);
  }

  function toggleField(field, condition) {
    if (condition) {
      $(field).removeClass('hidden');
    } else {
      $(field).addClass('hidden');
    }
  }
})();