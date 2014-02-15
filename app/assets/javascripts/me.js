// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){

  $('#user_nationality').chosen();

  $('#edit-modal').on('submit', 'form', function(e) {

    $('#edit-modal input[type=submit]').attr('value', 'Editing...').attr('disabled', true);

    $.ajax({
      type: "POST",
      url: e.target.getAttribute('action'),
      data: $(e.target).serialize(),
      success: function() {
        location.reload();
      },
      error: function() {
        $('#edit-modal input[type=submit]').attr('value', 'Edit').attr('disabled', false);
        alertBox('Unexpected error.', 'alert');
      }
    });

    return false;

  });

  $('#edit-modal').on('click', 'a.delete-button', function(e) {

    e.preventDefault();

    if ($(e.target).attr('disabled') !== undefined) {
        event.preventDefault();
        return;
    }

    $(e.target).html('Deleting...').attr('disabled', true);

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
        $(e.target).html('Delete').attr('disabled', false);
        alertBox('Unexpected error.', 'alert');
      }
    });

  });

});
