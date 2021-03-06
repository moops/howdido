//= require rails-ujs
//= require jquery3
//= require popper

//= require chart
//= require raphael
//= require justgage
//= require bootstrap
//= require bootstrap-datepicker
//= require_tree .

$(function() {
  // tooltips
  $("a.tip").tooltip();
  $('[data-toggle="tooltip"]').tooltip();

  $("input.calendar").datepicker();
});

// hide success messages after 3 seconds
window.setTimeout(function() {
  $('.alert-dismissible').fadeTo(500, 0).slideUp(500, function() {
      $(this).remove();
  });
}, 3000);

function seconds_to_time(s) {
  hours = parseInt(s / 3600);
  s = s - (hours * 3600);
  minutes = parseInt(s / 60);
  seconds = s - (minutes * 60);
  if (minutes < 10) minutes = '0' + minutes;
  if (seconds < 10) seconds = '0' + seconds;
  return hours + ':' + minutes + ':' + round(seconds,10);
}

function round(n,r) {
    return Math.round(n*r) / r;
}
