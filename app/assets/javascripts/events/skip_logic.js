EBS.EventsSkipLogic = function () {
  var operatorMethods = {
    '=': 'equalValidator',
    '!=': 'notValidator',
    'in': 'matchAnyValidator',
    'match_all': 'matchAllValidator'
  };

  return {
    init: init,
    equalValidator: equalValidator,
    matchAllValidator: matchAllValidator,
    matchAnyValidator: matchAnyValidator,
    notValidator: notValidator,
    renderSkipLogicField: renderSkipLogicField
  };

  function init() {
    renderSkipLogicField();
    addEventToRelevantField();
    onFormSubmit();
  }

  function onFormSubmit() {
    $('.event-form-wrapper form').submit(function () {
      $('[data-code].hidden').each(function (_i, field) {
        $(field).find('.skip-logic-field').val('');
      });
    });
  }

  function renderSkipLogicField() {
    $('[data-relevant]').each(function (_i, field) {
      togglerFields(field);
    });
  }

  function togglerFields(field) {
    var fieldCode = $(field).data('relevant');
    var triggerValue;
    var fieldValue = $(field).val() || $(field).attr('value');

    if (!!fieldValue) {
      triggerValue = typeof fieldValue == 'string' ? fieldValue.toLowerCase() : fieldValue.join(',').toLowerCase();
    }

    $("[data-code=".concat(fieldCode, "]")).each(function (_i, field) {
      operator = $(field).data('operator');
      EBS.EventsSkipLogic[operatorMethods[operator]](field, triggerValue);
    });
  }

  function addEventToRelevantField() {
    $(document).on('change', '[data-relevant]', function (event) {
      togglerFields(event.target);
    });
  }

  function matchAnyValidator(field, triggerValue) {
    var values = $(field).data('value').split(',');
    var isMatch = false;
    var triggerValues = triggerValue.split(',');

    for (var i = 0; i < triggerValues.length; i++) {
      if (values.includes(triggerValues[i])) {
        isMatch = true;
        break;
      }
    }

    toggleField(field, isMatch);
  }

  function equalValidator(field, triggerValue) {
    var values = $(field).data('value').split(',');
    var isMatch = values == triggerValue;
    toggleField(field, isMatch);
  }

  function notValidator(field, triggerValue) {
    var values = $(field).data('value').split(',');
    var isMatch = true;
    var triggerValues = triggerValue.split(',');

    for (var i = 0; i < triggerValues.length; i++) {
      if (values.includes(triggerValues[i])) {
        isMatch = false;
        break;
      }
    }

    toggleField(field, isMatch);
  }

  function matchAllValidator(field, triggerValue) {
    var values = $(field).data('value').split(',');
    var triggerValues = triggerValue.split(',');
    var isMatch = true;

    for (var i = 0; i < values.length; i++) {
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
}();
