//= require jquery
//= require jquery_ujs
//= require jquery.visualize
//= require excanvas
//= require raphael
//= require gauge
//= require highcharts
//= require gray
//= require bootstrap
//= require bootstrap-datepicker
//= require_tree .

$(function() {
	$("a.tip").tooltip();
	$("input.calendar").datepicker();
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
