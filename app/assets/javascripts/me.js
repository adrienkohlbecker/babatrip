// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){

  $('#user_nationality').chosen();

  $('#edit-modal').on('submit', 'form', function(e) {

    $.ajax({
      type: "POST",
      url: e.target.getAttribute('action'),
      data: $(e.target).serialize(),
      success: function() {
        location.reload();
      },
      error: function() {
        alertBox('Unexpected error.', 'alert');
      }
    });

    return false;

  });

  $('#edit-modal').on('click', 'a.delete-button', function(e) {

    e.preventDefault();

    var form = $('#edit-modal .delete-form');

    if (!confirm('Are you sure?')) {
      return;
    }

    $.ajax({
      type: "DELETE",
      url: form[0].getAttribute('action'),
      data: form.serialize(),
      success: function() {
        location.reload();
      },
      error: function() {
        alertBox('Unexpected error.', 'alert');
      }
    });

  });

});
