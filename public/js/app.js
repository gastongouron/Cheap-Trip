
window.onload = function() {
  var div = document.getElementById('search');
  if (div.style.display !== 'none') {
    div.style.display = 'block';
  } else {
    div.style.display = 'block';
  }

$("#find-subj").autocomplete({
    source: availableTags,
    messages: {
        noResults: '',
        results: function() {}
    }
});


};
