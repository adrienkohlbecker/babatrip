// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$('#add-modal').on('submit', 'form', function(e) {

  $.ajax({
    type: "POST",
    url: e.target.getAttribute('action'),
    data: $(e.target).serialize(),
    success: function() {
      e.target.reset();
      $('#contact-modal').foundation('reveal', 'close');
      alertBox('Successfully added trip!', 'success');
    },
    error: function() {
      alertBox('Unexpected error.', 'alert');
    }
  });

  return false;

});
