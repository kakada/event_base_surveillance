window.EBS = {}
EBS.EventsSkipLogic = ( function() {
  var operatorMethods = {
    '=': 'equalValidator',
    '!=': 'notValidator',
    'in': 'matchAnyValidator',
    'match_all': 'matchAllValidator'
  }

  return {
    init: init,
    equalValidator: equalValidator,
    matchAllValidator: matchAllValidator,
    matchAnyValidator: matchAnyValidator,
    notValidator: notValidator
  }

  function init() {
    renderSkipLogicField();
    handleSectionSkipLogic();
    initTracingView();
  }

  function initTracingView() {
    $('.timeline').each( function() {
      var data = $(this).data('tracings');

      if (!data) {
        return;
      }

      var dom = '';

      for(var i=0; i < data.length; i++) {
        dom += '<li class="li complete">';
        dom += '<div class="status"><span>'+ data[i].field_value + '</span></div>';
        dom += '<div class="timestamp"><div class="date">' + data[i].created_date + '</div></div>';
        dom += '</li>';
      }

      $(this).html(dom);
    });
  }

  function handleSectionSkipLogic() {
    $('.section').each (function() {
      if ($(this).find('li.hidden').length == $(this).find('li').length) {
        $(this).addClass('hidden');
      } else {
        $(this).removeClass('hidden');
      }
    });
  }

  function renderSkipLogicField() {
    $('[data-relevant]').each(function(_i, field) {
      togglerFields(field);
    });
  }

  function togglerFields(field) {
    var fieldCode = $(field).data('relevant');
    var triggerValue;
    var fieldValue = $(field).val() || $(field).attr('value');

    if (!!fieldValue) {
      triggerValue = (typeof fieldValue == 'string') ? fieldValue.toLowerCase() : fieldValue.join(',').toLowerCase();
    }

    var dataCodes = $("[data-code='" + fieldCode + "']");

    dataCodes.each( function(_i, field) {
      if (!triggerValue) {
        return toggleField(field, false);
      }

      var operator = $(field).data('operator');
      EBS.EventsSkipLogic[operatorMethods[operator]](field, triggerValue);
    });
  }

  function matchAnyValidator(field, triggerValue) {
    var values = $(field).data('value').split(',');
    var isMatch = false;
    var triggerValues = triggerValue.split(',');

    for(var i = 0; i < triggerValues.length; i++) {
      if (values.indexOf(triggerValues[i]) > -1) {
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
    for(var i = 0; i < triggerValues.length; i++) {
      if (values.indexOf(triggerValues[i]) > -1) {
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
    for(var i = 0; i < values.length; i++) {
      if (!(triggerValues.indexOf(values[i]) > -1)) {
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
