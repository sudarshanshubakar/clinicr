$(document).ready(function() {

  $("#search").submit(function(submitEvent) {
    submitEvent.preventDefault();
    var url = $(this).attr("action");
    // alert(url);
    var formValues = $(this).serialize();
    postAndAddToContent(url, formValues);
  });
  
    $("#update_form").submit(function(submitEvent) {
    submitEvent.preventDefault();
    var id = $('#update_form input[name=\"id\"]').val();
    var url = $(this).attr("action");
    // alert(url);
    var location = $(this).attr("location");
    // alert(location);
    var formValues = $(this).serialize();
    // alert(formValues);
    postAndAddToLocation(url, formValues, location);
    visit_url = "/myClinic/visitHistory?id="+id;
    getAndAddToLocation(visit_url, "#visit_history_section");
  });

  $('body').on('click', '#search_result_hyperlink a',function(event){
    event.preventDefault();
    var url = $(this).attr("href");
    getAndAddToLocation(url, "#content_area");
  });
  
    $('body').on('click', '#show_history_hyperlink a',function(event){
    event.preventDefault();
    var url = $(this).attr("href");
    var location = $(this).attr("location");
    getAndAddToLocation(url, location);
  });

    $('body').on('click', '#show_new_visit_form a',function(event){
    event.preventDefault();
    var url = $(this).attr("href");
    var location = $(this).attr("location");
    getAndAddToLocation(url, location);
  });  
  
  function postAndAddToContent(url, formValues) {
    $.post(url, formValues,
      function(returnHTML) {
        addToLocation(returnHTML,"#content_area");
      });
    }
    
  function postAndAddToLocation(url, formValues, location) {
    $.post(url, formValues,
      function(returnHTML) {
        addToLocation(returnHTML,location);
      });
    }

    function getAndAddToLocation(url, location) {
      $.get(url, function(returnHTML) {
        addToLocation(returnHTML, location);
      });
    }

    function addToLocation(html, location) {
      var result_location = $(document).find(location);
      $(result_location).html(html);
    }

  });
  
