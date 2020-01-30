EBS.MilestonesMessagesNew = (() => {
  const init = () => {
    showDefaultTemplateFields();
    onClickTemplateField();
    onClickSteper();
    onFormSubmit();
    initEmailEditor();
  };

  let onClickTemplateField = () => {
    $(document).off('click', '.template-field');
    $(document).on('click', '.template-field', function(e) {
      const value = '{{' + $(this).data('code') + '}}';
      EBS.Util.insertToTextbox('message_message', value);

      e.preventDefault();
    });
  };

  let onClickSteper = () => {
    $('ol > li:not(.inactive)').off('click', 'span.number');
    $('ol > li:not(.inactive)').on('click', 'span.number', () => {
      $('ol > li').removeClass('active');
      $(this).parent('li').addClass('active');
    });
  };

  let showDefaultTemplateFields = () => {
    $('ol li:first').addClass('active');
  }

  let onFormSubmit = () => {
    $('#message-form').submit(() => {
      if ($('.message_telegram_notification_chat_groups input:checked').length == 0) {
        $('#message_telegram_attributes_milestone_id').attr("disabled", "disabled")
      }

      const emails = $('#notification-emails').val();
      if (emails.length) {
        const transformValue = JSON.parse(emails).map(x => x.value);
        $('#notification-emails').val(`{${transformValue.join(',')}}`);
      }
    });
  }

  let initEmailEditor = () => {
    const input = document.querySelector('textarea[name="message[email_notification_attributes][emails]"]');
    new Tagify(input, {
      delimiters: ',| ',
      pattern: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    });
  }

  return { init };
})();

EBS.MilestonesMessagesCreate = EBS.MilestonesMessagesNew;
EBS.MilestonesMessagesEdit = EBS.MilestonesMessagesNew;
EBS.MilestonesMessagesUpdate = EBS.MilestonesMessagesNew;
