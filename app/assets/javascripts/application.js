//js in gems
//= require jquery
//= require jquery_ujs

//js in lib/assets
//= require jquery-ui
//= require jquery.easing
//= require jquery.tooltip
//= require jquery.validate
//= require jquery.visualize
//= require excanvas
//= require raphael
//= require gauge
//= require highcharts
//= require gray
//= require bootstrap

//js in app/assets
//= require_self
//= require_tree .

//build a form dialog
function buildFormDialog(name) {
  var f = jQuery('#' + name + '_form').dialog({ autoOpen: false, width: 600, title: name + ' form', modal: true, show: 'fade' });
  jQuery('.show_' + name + '_form').click(function() {
    f.dialog('open');
    return false;
  });
}

//validate a form
function validate(form_id, rules) {
  jQuery('form.' + form_id).validate({
        errorPlacement: function(error, element) {
          jQuery(element).attr('title', jQuery(error).html());
          jQuery(element).tooltip();
        },
        rules: rules
  });
}

jQuery(document).ready(function() {    
  jQuery("input.calendar").datepicker();
  jQuery("input.calendar").datepicker("option", "dateFormat", "yy-mm-dd");
  jQuery("input.today").datepicker('setDate', new Date());
});

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
