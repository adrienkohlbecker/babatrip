function city_autocomplete(elt) {

  autocomplete = new google.maps.places.Autocomplete(
        elt, {
          types: ['(cities)']
        });



  function onPlaceChanged() {
    var place = autocomplete.getPlace();
    document.getElementById($(elt).data('city-autocomplete-lat')).value = place.geometry.location.lat();
    document.getElementById($(elt).data('city-autocomplete-lng')).value = place.geometry.location.lng();
  }

  google.maps.event.addListener(autocomplete, 'place_changed', onPlaceChanged);

}

$(document).ready(function() {

  $('[data-city-autocomplete]').each(function(i, elt) {
    city_autocomplete(elt);
  });

});
