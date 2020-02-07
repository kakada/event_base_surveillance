EBS.SkipLogic = ( () => {
  return {
    template,
    build
  }

  function template() {
    return {
      selectOne: selectOne,
      selectMultiple: selectMultiple
    }
  }

  function labelValue(label, value) {
    return {
      value: value,
      label: label
    }
  }

  function selectOne() {
    return {
      type: EBS.MilestoneFieldType.selectOne,
      operators: [
        labelValue('(=)', '='),
        labelValue('any of', 'in'),
        labelValue('not (!=)', '!=')
      ]
    }
  }

  function selectMultiple() {
    return {
      type: EBS.MilestoneFieldType.selectMultiple,
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
})();