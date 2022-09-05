// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require rails-ujs
//= require activestorage
//= require turbolinks

//= require jquery3
//= require popper
//= require bootstrap

//= require pumi
//= require jquery-sortable
//= require jquery.minicolors
//= require bootstrap-select.min
//= require bootstrap-toggle.min
//= require bootstrap-datepicker.min

//= require leaflet
//= require moment
//= require moment-with-locales
//= require daterangepicker
//= require tagify.min
//= require tagify.polyfills.min.js

// **DateTime picker: Usage: https://tempusdominus.github.io/bootstrap-4/Usage/
//= require tempusdominus-bootstrap-4.js

// **Bar Chart
//= require chart

// ** Main js
//= require application/namespace
//= require application/util

//= require common/sidebar
//= require common/location
//= require common/select_picker
//= require common/topbar
//= require common/copy

// All Pages
//= require milestones/sortable
//= require milestones/select_file
//= require milestones/new
//= require milestones/index
//= require milestones/field_type
//= require milestones/skip_logic_constant
//= require milestones/skip_logic

//= require event_milestones/new
//= require events/skip_logic
//= require events/locale
//= require events/daterange_picker
//= require events/new
//= require events/show
//= require event_milestones/show
//= require events/index
//= require event_types/new
//= require events/channels_form
//= require events/follow_up

//= require users/index
//= require users/new

//= require client_apps/index
//= require client_apps/new
//= require telegrams/new
//= require messages/message
//= require telegram_bots/new
//= require programs/telegram_notification_receiver
//= require programs/index
//= require programs/settings
//= require webhooks/new
//= require maps/index
//= require medisys_feeds
//= require schedules/new

document.addEventListener('turbolinks:load', function() {
  EBS.Common.Sidebar.init();
  EBS.Common.SelectPicker.init();
  EBS.Common.Topbar.init();
  EBS.Common.Copy.init();

  // Default Setup
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();

  $.fn.datepicker.defaults.format = "yyyy-mm-dd"
  $('.datetimepicker').datetimepicker({format: 'YYYY-MM-DD HH:mm'})

  let currentPage = EBS.Util.getCurrentPage();
  !!EBS[currentPage] && EBS[currentPage].init();
})
