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

//= require leaflet
//= require moment.min

//= require application/namespace
//= require application/util

//= require common/sidebar
//= require common/location

// All Pages
//= require milestones/new
//= require milestones/index
//= require event_milestones/new
//= require events/new
//= require events/show
//= require event_types/new
//= require users/index
//= require users/new
//= require client_apps/index
//= require client_apps/new
//= require telegrams/new
//= require programs/settings
//= require webhooks/new


document.addEventListener('turbolinks:load', function() {
  EBS.Common.Sidebar.init();
  $('[data-toggle="tooltip"]').tooltip();

  let currentPage = EBS.Util.getCurrentPage();
  !!EBS[currentPage] && EBS[currentPage].init();
})
