// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require foundation-datepicker

function datepicker() {

  var nowTemp = new Date();
  var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);

  var checkin = $('#arriving').fdatepicker({

    format: 'dd/mm/yyyy',
    weekStart: 1,
    onRender: function (date) {
      return date.valueOf() < now.valueOf() ? 'disabled' : '';
    }

  }).on('changeDate', function (ev) {

    if (ev.date.valueOf() > checkout.date.valueOf()) {
      var newDate = new Date(ev.date);
      newDate.setDate(newDate.getDate() + 1);
      checkout.setDate(newDate);
    }
    checkin.hide();
    $('#leaving')[0].focus();

  }).data('datepicker');
  var checkout = $('#leaving').fdatepicker({
    format: 'dd/mm/yyyy',
    weekStart: 1,
    onRender: function (date) {
      return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
    }
  }).on('changeDate', function (ev) {
    checkout.hide();
  }).data('datepicker');

}

$(function(){

  datepicker();

});
