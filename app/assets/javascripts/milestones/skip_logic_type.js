EBS.SkipLogic = ( () => {
  return {
    template,
    build
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
        labelValue('match all of', 'match_all')
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
})();