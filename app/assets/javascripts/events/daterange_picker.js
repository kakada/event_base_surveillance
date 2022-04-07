EBS.DaterangPicker = (() => {
  var tr = {};

  function init() {
    setDefaultLocale();
    handleDisplayDate();
    initDateRangePicker();

    onApplyDateRange();
    onCancelDateRange();
  }

  function setDefaultLocale() {
    let locale = $('[data-language-code]').data('languageCode') || 'en';
    tr = EBS.DateLocale[locale];
    tr.locale = locale;

    moment.locale(tr.locale);
  }

  function handleDisplayDate() {
    let start = $('.start-date').val();
    let end = $('.end-date').val();

    if (!!start && !!end) {
      displayDate(moment(start), moment(end));
    }
  }

  function initDateRangePicker() {
    let options = {
      ranges: customRange(),
      locale: {
        cancelLabel: tr.clear,
        applyLabel: tr.apply,
        customRangeLabel: tr.customRange
      },
      alwaysShowCalendars: true,
    }

    let start = $('.start-date').val();
    let end = $('.end-date').val();

    if (!!start && !!end) {
      options.startDate = moment(start);
      options.endDate = moment(end);
    }

    $('#daterange').daterangepicker(options, displayDate);
  }

  function customRange() {
    let ranges = {};
    ranges[tr.today] = [moment(), moment()];
    ranges[tr.yesterday] = [moment().subtract(1, 'days'), moment().subtract(1, 'days')];
    ranges[tr.last_7_day] = [moment().subtract(6, 'days'), moment()];
    ranges[tr.last_30_day] = [moment().subtract(29, 'days'), moment()];
    ranges[tr.this_month] = [moment().startOf('month'), moment().endOf('month')];
    ranges[tr.last_month] = [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')];

    return ranges;
  }

  function onApplyDateRange() {
    $('#daterange').on('apply.daterangepicker', function(ev, picker) {
      $('.start-date').val(picker.startDate.locale('en').format('YYYY-MM-DD'));
      $('.end-date').val(picker.endDate.locale('en').format('YYYY-MM-DD'));

      displayDate(picker.startDate, picker.endDate);
    });
  }

  function onCancelDateRange() {
    $('#daterange').on('cancel.daterangepicker', function(ev, picker) {
      $('.start-date').val('');
      $('.end-date').val('');

      displayDate('', '');
    });
  }

  function displayDate(start, end) {
    let display = $('#daterange span').data('placeholder');

    if (!!start && !!end) {
      display = start.locale(tr.locale).format(tr.format) + ' - ' + end.locale(tr.locale).format(tr.format);
    }

    $('#daterange span').html(display);
  }

  return {
    init
  }
})();
