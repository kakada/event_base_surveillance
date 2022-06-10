EBS.SkipLogic = (function () {
  return {
    init: init,
    template: template,
    build: build
  };

  function init() {
    buildAllRelevantFields();
    onClickSkipLogic();
    onFormSubmit();
    addEventToCodeField();
    addEventToOperatorField();
    onChangeSkipLogicFormControl();
  }

  function buildAllRelevantFields() {
    $('.setting-wrapper').each(function (_i, skipLogicForm) {
      var relevantValue = $(skipLogicForm).find('.skip-logic-field').val();
      if (!relevantValue) { return; }
      var relevantValues = relevantValue.split('||');
      var code = relevantValues[0];
      var operator = relevantValues[1];
      var value = relevantValues[2];

      var codeControl = build(skipLogicForm, code);
      buildOperator(codeControl, operator);
      $(skipLogicForm).find("#relevant-value").val(value);
      buildValue(skipLogicForm);
    });
  }

  function onClickSkipLogic() {
    $(document).on('click', '.setting-wrapper .item.skip-logic', function (event) {
      var skipLogicForm = $(event.target).parents('.setting-wrapper')[0];

      if ($(skipLogicForm).find('#relevant-operator option').length > 0) {
        return;
      }

      var codeControl = build(skipLogicForm);
      setDefaultValue(skipLogicForm);
      buildOperator(codeControl);
      setDefaultValue(skipLogicForm);
      var operator = $(skipLogicForm).find('.skip-logic-field').val().split('||')[1];
      buildValue(skipLogicForm, operator);
    });
  }

  function onFormSubmit() {
    $('.milestone-form form').on('submit', function () {
      $('.skip-logic-content').each(function (_i, skipLogic) {
        var submitValue = getSkipLogicContent(skipLogic);
        var skiLogicField = $(skipLogic).find('input.skip-logic-field').first();

        skiLogicField.val(submitValue);
      });
    });
  }

  function getSkipLogicContent(skipLogicContentWrapper) {
    var submitValue = '';
    var value = $(skipLogicContentWrapper).find('#relevant-value').val();
    var code = $(skipLogicContentWrapper).find('#relevant-code').val();
    var operator = $(skipLogicContentWrapper).find('#relevant-operator').val();

    if (value && code && operator) {
      var transformValue = JSON.parse(value).map(function (x) {
        return x.value;
      }).join(',');
      submitValue = "".concat(code, "||").concat(operator, "||").concat(transformValue);
    }

    return submitValue;
  }

  function addEventToCodeField() {
    $(document).on('change', '.skip-logic-content #relevant-code', function (event) {
      buildOperator(event.target);
    });
  }

  function addEventToOperatorField() {
    $(document).on('change', '.skip-logic-content #relevant-operator', function (event) {
      reBuildValue(event.target);
    });
  }

  function template() {
    var templateOject = {};
    templateOject[EBS.MilestoneFieldType.selectOne] = selectOne();
    templateOject[EBS.MilestoneFieldType.selectMultiple] = selectMultiple();
    return templateOject;
  }

  function labelValue(label, value) {
    return {
      value: value,
      label: label
    };
  }

  function selectOne() {
    return {
      operators: [labelValue(locale.please_select, ''), labelValue('(=)', EBS.SkipLogicConstant.EQUAL_OPERATOR), labelValue(locale.any_of, EBS.SkipLogicConstant.MATCH_ANY_OPERATOR), labelValue("".concat(locale.skip_logic_not, " (!=)"), EBS.SkipLogicConstant.NOT_OPERATOR)]
    };
  }

  function selectMultiple() {
    return {
      operators: [labelValue(locale.please_select, ''), labelValue('(=)', EBS.SkipLogicConstant.EQUAL_OPERATOR), labelValue(locale.any_of, EBS.SkipLogicConstant.MATCH_ANY_OPERATOR), labelValue(locale.match_all_of, EBS.SkipLogicConstant.MATCH_ALL_OPERATOR), labelValue("".concat(locale.skip_logic_not, " (!=)"), EBS.SkipLogicConstant.NOT_OPERATOR)]
    };
  }

  function build(skipLogicForm, code) {
    var fields = getCodeList();
    var options = buildOptions(fields);
    var codeControl = $(skipLogicForm).find('#relevant-code');
    codeControl.html(options);

    if (code) {
      codeControl.val(code);
    }

    return codeControl;
  }

  function getCodeList() {
    var data = [];
    var fields = $("input[value='".concat(EBS.MilestoneFieldType.selectOne, "'], input[value='").concat(EBS.MilestoneFieldType.selectMultiple, "']"));
    fields.each(function (_i, field) {
      if ($(field).data('field').code) {
        field_data = $(field).data('field');
        field_data.type = field.value;
        data.push(field_data);
      }
    });
    return data;
  }

  function buildOptions(fields) {
    var options = [];
    fields.unshift({
      code: '',
      type: '',
      name: locale.please_select
    });
    fields.forEach(function (field) {
      option = $("<option value='".concat(field.code, "' type='").concat(field.type, "'>").concat(field.name, "</option>"));
      options.push(option);
    });
    return options;
  }

  function buildOperator(codeControl, operator) {
    var type = $(codeControl).find('option:selected').attr('type');
    var selectedTemplate = template()[type];
    var skipLogicForm = getSkipLogicForm(codeControl);
    var relevantOperator = $(skipLogicForm).find('#relevant-operator');

    if (selectedTemplate) {
      var options = [];
      selectedTemplate.operators.forEach(function (operator) {
        options.push($("<option value=".concat(operator.value, ">").concat(operator.label, "</option>")));
      });
      relevantOperator.html(options);
      relevantOperator.val(operator);
      $(relevantOperator).change();
    }

    return relevantOperator;
  }

  function setDefaultValue(skipLogicForm) {
    var relevantValue = $(skipLogicForm).find('.skip-logic-field').val();

    if (relevantValue) {
      var relevantValues = relevantValue.split('||');
      var code = relevantValues[0];
      var operator = relevantValues[1];
      var value = relevantValues[2];
      $(skipLogicForm).find('#relevant-code').val(code);
      $(skipLogicForm).find('#relevant-operator').val(operator);
      $(skipLogicForm).find('#relevant-value').val(value);
    }
  }

  function buildValue(skipLogicForm, operator) {
    var operatorControl = $(skipLogicForm).find('#relevant-operator');

    if (!operator) {
      operator = $(operatorControl).find('option:selected').val();
    }

    var relevantValue = $(skipLogicForm).find('#relevant-value');
    var tagOption = {};

    if (operator == EBS.SkipLogicConstant.EQUAL_OPERATOR) {
      tagOption.maxTags = 1;
    }

    var tags = $(skipLogicForm).find('tags.relevant-value');
    tags.remove();
    var tagify = new Tagify(relevantValue[0], tagOption);

    tagify.on('remove', handleTagChange);
    tagify.on('add', handleTagChange);
  }

  function handleTagChange(e) {
    var skipLogicContentWrapper = $(e.detail.tagify.DOM.originalInput).parents('.skip-logic-content');

    toggleFieldRequired(skipLogicContentWrapper);
  }

  function toggleFieldRequired(skipLogicContentWrapper) {
    var isSkipLogic = !!getSkipLogicContent(skipLogicContentWrapper).length;
    var fieldRequied = $(skipLogicContentWrapper.parents('.setting-wrapper')).find('.field-required');

    fieldRequied.prop('disabled', isSkipLogic);
    fieldRequied.prop('checked', false);
    $(fieldRequied).parents('.fieldset').find('.abbr-required').addClass('hidden');
  }

  function onChangeSkipLogicFormControl() {
    $(document).off('change', '.skip-logic-content .form-control')
    $(document).on('change', '.skip-logic-content .form-control', function(e) {
      var skipLogicContentWrapper = $(e.target).parents('.skip-logic-content');

      toggleFieldRequired(skipLogicContentWrapper);
    });
  }

  function reBuildValue(operatorControl) {
    var skipLogicForm = getSkipLogicForm(operatorControl);
    var tags = $(skipLogicForm).find('tags.relevant-value');
    tags.remove();
    var relevantValue = $(skipLogicForm).find('#relevant-value');
    $(relevantValue).val('');
    buildValue(skipLogicForm);
  }

  function getSkipLogicForm(control) {
    return $(control).parents('.skip-logic-content');
  }
})();
