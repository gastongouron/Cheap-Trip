window.onload = function() {
  var div = document.getElementById('search');
  if (div.style.display !== 'none') {
    div.style.display = 'block';
  } else {
    div.style.display = 'block';
  }
};


// $(document).ready(function() {

// $('#search-button').on('submit', function(e){
//     e.preventDefault()
//   });
//     var data = $(this).serialize()
//     console.log(data);

//     var request = $.ajax({
//       method: 'POST',
//       data: data,
//       url:'/'
//     });
//     request.done(function(response){
//       $(#'search-button').append(response)
//     });

// });


// $("#search").autocomplete({
//     source: "/app/friends",
//     minLength: 2,
//     response: function( event, ui ) {
//         display(ui.content);
//     },
//     open: function( event, ui ) {
//         $(".ui-autocomplete").hide();
//     }
// });
  // think about a way to get rid of jquery behaviors such as dropdown when input city name
  // $("#find-subj").autocomplete({
  //     source: availableTags,
  //     messages: {
  //         noResults: '',
  //         results: function() {}
  //     }
  // });




