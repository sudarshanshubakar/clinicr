$(document).ready(function() {

  $("#search").submit(function(submitEvent) {
    submitEvent.preventDefault();
    var url = $(this).attr("action");
    var formValues = $(this).serialize();
    postAndAddToContent(url, formValues)
  });

  $('body').on('click', '#search_result_hyperlink a',function(event){
    event.preventDefault();
    var url = $(this).attr("href");
    getAndAddToContent(url);
  });
  
    $('body').on('click', '#show_history_hyperlink a',function(event){
    event.preventDefault();
    var url = $(this).attr("href");
    getAndAddToContent(url);
  });

  function postAndAddToContent(url, formValues) {
    $.post(url, formValues,
      function(returnHTML) {
        addToContentArea(returnHTML)
      });
    }

    function getAndAddToContent(url) {
      $.get(url, function(returnHTML) {
        addToContentArea(returnHTML)
      });
    }

    function addToContentArea(html) {
      var result_location = $(document).find("#content_area");
      $(result_location).html(html);
    }

    
    
  });