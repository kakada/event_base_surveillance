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

// **DateTime picker: Usage: https://tempusdominus.github.io/bootstrap-4/Usage/
//= require moment
//= require tempusdominus-bootstrap-4.js

//= require leaflet
//= require moment.min

// **Bar Chart
//= require chart

// ** Main js
//= require tagify.min

//= require application/namespace
//= require application/util

//= require common/sidebar
//= require common/location

// All Pages
//= require milestones/new
//= require milestones/index
//= require milestones/field_type
//= require milestones/skip_logic_type
//= require event_milestones/new
//= require events/new
//= require events/show
//= require event_milestones/show
//= require events/index
//= require event_types/new
//= require users/index
//= require users/new
//= require client_apps/index
//= require client_apps/new
//= require telegrams/new
//= require messages/message
//= require programs/settings
//= require webhooks/new


document.addEventListener('turbolinks:load', function() {
  EBS.Common.Sidebar.init();

  // Default Setup
  $('[data-toggle="tooltip"]').tooltip();
  $.fn.datepicker.defaults.format = "yyyy-mm-dd"
  $('.datetimepicker').datetimepicker({format: 'YYYY-MM-DD HH:mm'})

  let currentPage = EBS.Util.getCurrentPage();
  !!EBS[currentPage] && EBS[currentPage].init();
})
