EBS.SkipLogic = (() => {
  return {
    init,
    template,
    build
  };

  function init() {
    buildAllRelevantFields();
    onClickSkipLogic();
    onFormSubmit();
  }

  function buildAllRelevantFields() {
    $('.setting-wrapper').each( (_i, skipLogicForm) => {
      let codeControl = build(skipLogicForm);
      setDefaultValue(skipLogicForm);
      buildOperator(codeControl);
      setDefaultValue(skipLogicForm);
      buildValue(skipLogicForm);
    });
  }

  function onClickSkipLogic() {
    $(document).on('click', '.setting-wrapper .item.skip-logic', (event) => {
      let skipLogicForm = $(event.target).parents('.setting-wrapper')[0];
      if ($(skipLogicForm).find('#relevant-operator option').length > 0) {
        return;
      }
      let codeControl = build(skipLogicForm);
      setDefaultValue(skipLogicForm);
      buildOperator(codeControl);
      setDefaultValue(skipLogicForm);
      let operator = $(skipLogicForm).find('.skip-logic-field').val().split('||')[1];
      buildValue(skipLogicForm, operator);
    });
  }

  function onFormSubmit() {
    $('.milestone-form form').on('submit', () => {
      $('.skip-logic-content').each( (_i, skipLogic) => {
        let value = $(skipLogic).find('#relevant-value').val();
        let submitValue = '';
        if (value) {
          let transformValue = JSON.parse(value).map(x => x.value).join(',')
          let code = $(skipLogic).find('#relevant-code').val();
          let operator = $(skipLogic).find('#relevant-operator').val();
          submitValue = `${code}||${operator}||${transformValue}`;
        }

        let skiLogicField = $(skipLogic).find('input.skip-logic-field').first();
        skiLogicField.val(submitValue);
      });
    });
  }

  function template() {
    let templateOject = {};
    templateOject[EBS.MilestoneFieldType.selectOne] = selectOne();
    templateOject[EBS.MilestoneFieldType.selectMultiple] = selectMultiple();

    return templateOject;
  }

  function labelValue(label, value) {
    return {
      value: value,
      label: label
    }
  }

  function selectOne() {
    return {
      operators: [
        labelValue('please select', ''),
        labelValue('(=)', EBS.SkipLogicConstant.EQUAL_OPERATOR),
        labelValue('any of', EBS.SkipLogicConstant.MATCH_ANY_OPERATOR),
        labelValue('not (!=)', EBS.SkipLogicConstant.NOT_OPERATOR)
      ]
    }
  }

  function selectMultiple() {
    return {
      operators: [
        labelValue('please select', ''),
        labelValue('(=)', EBS.SkipLogicConstant.EQUAL_OPERATOR),
        labelValue('any of', EBS.SkipLogicConstant.MATCH_ANY_OPERATOR),
        labelValue('match all of', EBS.SkipLogicConstant.MATCH_ALL_OPERATOR),
        labelValue('not (!=)', EBS.SkipLogicConstant.NOT_OPERATOR)
      ]
    }
  }

  function build(skipLogicForm) {
    let fields = getCodeList();
    let options = buildOptions(fields);
    let codeControl = $(skipLogicForm).find('#relevant-code');

    codeControl.change((event) => {
      operators = buildOperator(event.target);
    });

    codeControl.html(options);
    return codeControl;
  }

  function getCodeList() {
    let data = [];
    let fields = $(`input[value='${EBS.MilestoneFieldType.selectOne}'], input[value='${EBS.MilestoneFieldType.selectMultiple}']`);
    fields.each( (_i, field) => {
      if ($(field).data('field').code) {
        field_data = $(field).data('field');
        field_data.type = field.value;
        data.push(field_data);
      }
    });

    return data;
  }

  function buildOptions(fields) {
    let options = [];
    fields.unshift({code: '', type: '', name: 'Please select'});

    fields.forEach( (field) => {
      option = $(`<option value='${field.code}' type='${field.type}'>${field.name}</option>`);
      options.push(option);
    });

    return options;
  }

  function buildOperator(codeControl) {
    let options = [];
    let type = $(codeControl).find('option:selected').attr('type');
    let selectedTemplate = template()[type];

    if (selectedTemplate) {
      selectedTemplate.operators.forEach( (operator) => {
        options.push($(`<option value=${operator.value}>${operator.label}</option>`));
      });
    }

    let skipLogicForm = getSkipLogicForm(codeControl);
    let relevantOperator = $(skipLogicForm).find('#relevant-operator');
    relevantOperator.html(options);
    $(relevantOperator).change();

    relevantOperator.change( (event) => {
      reBuildValue(event.target);
    });

    return relevantOperator;
  }

  function setDefaultValue(skipLogicForm) {
    let relevantValue = $(skipLogicForm).find('.skip-logic-field').val();
    if (relevantValue) {
      let [code, operator, value] = relevantValue.split('||');
      $(skipLogicForm).find('#relevant-code').val(code);
      $(skipLogicForm).find('#relevant-operator').val(operator);
      $(skipLogicForm).find('#relevant-value').val(value);
    }
  }

  function buildValue(skipLogicForm, operator) {
    let operatorControl = $(skipLogicForm).find('#relevant-operator');
    if (!operator) {
      operator = $(operatorControl).find('option:selected').val();
    }

    let relevantValue = $(skipLogicForm).find('#relevant-value');
    let tagOption = {};
    if (operator == EBS.SkipLogicConstant.EQUAL_OPERATOR) {
      tagOption.maxTags = 1;
    }
    new Tagify(relevantValue[0], tagOption);
  }

  function reBuildValue(operatorControl) {
    let skipLogicForm = getSkipLogicForm(operatorControl);
    let tags = $(skipLogicForm).find('tags.relevant-value');
    tags.remove();
    let relevantValue = $(skipLogicForm).find('#relevant-value');
    $(relevantValue).val('');
    buildValue(skipLogicForm);
  }

  function getSkipLogicForm(control) {
    return $(control).parents('.skip-logic-content');
  }
})();