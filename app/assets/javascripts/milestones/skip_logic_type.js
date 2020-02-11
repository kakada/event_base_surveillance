EBS.SkipLogic = ( () => {
  return {
    init,
    template,
    build
  }

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
    });
  }

  function onClickSkipLogic() {
    $(document).on('click', '.setting-wrapper .item.skip-logic', (event) => {
      let skipLogicForm = $(event.target).parents('.setting-wrapper')[0];
      if ($(skipLogicForm).find('#relevant-value').val()) {
        return;
      }
      let codeControl = build(skipLogicForm);
      setDefaultValue(skipLogicForm);
      buildOperator(codeControl);
      setDefaultValue(skipLogicForm);
    });
  }

  function onFormSubmit() {
    $('.milestone-form form').on('submit', () => {
      $('.skip-logic-content').each( (_i, skipLogic) => {
        let value = $(skipLogic).find('#relevant-value').val()
        if (!!value) {
          let code = $(skipLogic).find('#relevant-code').val();
          let operator = $(skipLogic).find('#relevant-operator').val();
          let skiLogicField = $(skipLogic).find('input.skip-logic-field').first();
          skiLogicField.val(`${code}||${operator}||${value}`);
        }
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
        labelValue('(=)', '='),
        labelValue('any of', 'in'),
        labelValue('not (!=)', '!=')
      ]
    }
  }

  function selectMultiple() {
    return {
      operators: [
        labelValue('(=)', '='),
        labelValue('any of', 'in'),
        labelValue('match all of', 'match_all'),
        labelValue('not (!=)', '!=')
      ]
    }
  }

  function build(skipLogicForm) {
    let fields = getCodeList();
    let options = buildOptions(fields);
    codeControl = $(skipLogicForm).find('#relevant-code');

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
    fields.forEach( (field) => {
      option = $(`<option value='${field.code}' type='${field.type}'>${field.name}</option>`);
      options.push(option);
    });

    return options;
  }

  function buildOperator(codeControl) {
    let options = [];
    type = $(codeControl).find('option:selected').attr('type');
    selectedTemplate = template();
    selectedTemplate[type].operators.forEach( (operator) => {
      options.push($(`<option value=${operator.value}>${operator.label}</option>`));
    });
    relevantOperator = $(codeControl).siblings('#relevant-operator');
    relevantOperator.html(options);
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
})();