EBS.TelegramNotificationReceiver = (() => {
  return { init }

  function init() {
    var inputElm = document.querySelector('input.users-list-tags');
    var tagify = new Tagify(inputElm, {
        tagTextProp: 'name', // very important since a custom template is used with this property as text
        enforceWhitelist: true,
        skipInvalid: true, // do not remporarily add invalid tags
        dropdown: {
            closeOnSelect: false,
            enabled: 0,
            classname: 'users-list',
            searchKeys: ['value', 'name', 'email']  // very important to set by which keys to search for suggesttions when typing
        },
        templates: {
            tag: tagTemplate,
            dropdownItem: suggestionItemTemplate
        },
        whitelist: JSON.parse(inputElm.dataset.users)
    })

    tagify.on('change', assignDataToInputTarget)
  }

  function assignDataToInputTarget(e) {
    var data = $('input.users-list-tags').val();

    if (!!data) {
      data = JSON.parse(data).map(x => x.value);
    }

    $("select#program_telegram_notification_receiver_ids").val(data);
  }

  function tagTemplate(tagData) {
    return `
      <tag title="${tagData.email}"
          contenteditable='false'
          spellcheck='false'
          tabIndex="-1"
          class="tagify__tag ${tagData.class ? tagData.class : ""}"
          ${this.getAttributes(tagData)}>
        <x title='' class='tagify__tag__removeBtn' role='button' aria-label='remove tag'></x>
        <div>
            <span class='tagify__tag-text'>${tagData.name}</span>
            <span>(${tagData.email})</span>
        </div>
      </tag>
    `
  }

  function suggestionItemTemplate(tagData){
    return `
      <div ${this.getAttributes(tagData)}
          class='tagify__dropdown__item ${tagData.class ? tagData.class : ""}'
          tabindex="0"
          role="option">
        <strong>${tagData.name}</strong>
        <span>${tagData.email} (${tagData.province})</span>
      </div>
    `
  }

 })();
