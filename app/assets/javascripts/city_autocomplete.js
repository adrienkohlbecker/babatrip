$(document).ready(function() {

  autocomplete = new google.maps.places.Autocomplete(
        document.getElementById('user_city'), {
          types: ['(cities)']
        });

  function onPlaceChanged() {
    var place = autocomplete.getPlace();
    document.getElementById('user_latitude').value = place.geometry.location.lat();
    document.getElementById('user_longitude').value = place.geometry.location.lng();
  }

  google.maps.event.addListener(autocomplete, 'place_changed', onPlaceChanged);

});
