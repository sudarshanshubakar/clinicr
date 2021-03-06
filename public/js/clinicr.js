$(document).ready(function() {



  $("#search").submit(function(submitEvent) {
    submitEvent.preventDefault();
    var url = $(this).attr("action");
    var formValues = $(this).serialize();
    postAndAddToLocation_search_result(url, formValues, "#search_result_area");

    var pat_bas_info_area =  $(document).find("#patient_basic_information_section");
    $(pat_bas_info_area).css("display", "none");
    var visit_history_section =  $(document).find("#visit_history_section");
    $(visit_history_section).css("display", "none");
  });

  $("#update_form").submit(function(submitEvent) {
    submitEvent.preventDefault();
    var id = $('#update_form input[name=\"id\"]').val();
    var url = $(this).attr("action");
    var location = $(this).attr("location");
    var formValues = $(this).serialize();

    $.post(url, formValues, function(returnHTML) {

      details_url = "/details/getDetails?id="+id;
      history_url = "/visitHistory/getVisitHistory?id="+id;
      getAndAddToLocation_callback(function(){
        getAndAddToLocation(history_url, "#visit_history_section");
        }, details_url, "#patient_basic_information_section");
        hideOverlay();
      });
    });

    $("#add_patient_form").submit(function(submitEvent) {
      submitEvent.preventDefault();
      var url = $(this).attr("action");
      var formValues = $(this).serialize();
      var id = "";
      var search_result_area =  $(document).find("#search_result_area");
      $(search_result_area).css("display", "none");
      $.post(url, formValues, function(returnHTML) {
        id = returnHTML;
        details_url = "/details/getDetails?id="+id;
        history_url = "/visitHistory/getVisitHistory?id="+id;
        getAndAddToLocation_callback(function(){
          getAndAddToLocation(history_url, "#visit_history_section");
          }, details_url, "#patient_basic_information_section");
          hideOverlay();
        });
      });

      $("#update_patient_details_form").submit(function(submitEvent) {
        submitEvent.preventDefault();
        var url = $(this).attr("action");
        var formValues = $(this).serialize();
        var id = "";
        $.post(url, formValues, function(returnHTML) {
          id = returnHTML;
          details_url = "/details/getDetails?id="+id;
          getAndAddToLocation(details_url, "#patient_basic_information_section");
        });
      });

      $('body').on('click', '#links a',function(event){
        event.preventDefault();
        var url = $(this).attr("href");
        getAndOverlay(url);
      });


      $('body').on('click', '#search_result_hyperlink a',function(event){
        event.preventDefault();
        var url = $(this).attr("href");
        getAndAddToLocation_callback(function(url) {
          var params = url.split("?")[1];
          var each_param = params.split("&")
          var id = "";
          for (var i=0, len=each_param.length; i < len; i++) {
            var kv_pair = each_param[i].split("=");
            var key = kv_pair[0];
            if (key == "id") {
              id = kv_pair[1];
              break;
            }
          }
          var url = "/visitHistory/getVisitHistory?id="+id;
          getAndAddToLocation(url, "#visit_history_section");
          },url, "#patient_basic_information_section");
          var search_result_area =  $(document).find("#search_result_area");
          $(search_result_area).css("display", "none");
        });

        $('body').on('click', '#show_history_hyperlink a',function(event){
          event.preventDefault();
          var url = $(this).attr("href");
          var location = $(this).attr("location");
          getAndAddToLocation(url, location);
        });

        $('body').on('click', '#cancel_update_patient_details' ,function(event){
          event.preventDefault();
          var url = $(this).attr("href");
          getAndAddToLocation(url, "#patient_basic_information_section");
        });

        $('body').on('click', '#details_hyperlinks a',function(event){
          event.preventDefault();
          var url = $(this).attr("href");
          var location = $(this).attr("location");
          getAndAddToLocation(url, location);
        });

        $('body').on('click', '#show_new_visit_form a',function(event){
          event.preventDefault();
          var url = $(this).attr("href");
          getAndOverlay(url);
        });

        function getAndOverlay(url) {
          showOverlay();
          $.get(url, function(returnHTML) {
            var result_location = $(document).find("#overlayContent");
            $(result_location).html(returnHTML);
          });
        }

        function showOverlay() {
          var overlay_location = $(document).find("#overlayArea");
          var result_location = $(document).find("#overlayContent");
          $(overlay_location).css("opacity", "0.7");
          $(result_location).css("opacity", "1");          
          $(overlay_location).css("display", "block");
          $(result_location).css("display", "block");
        }


        function postAndAddToLocation(url, formValues, location) {
          $.post(url, formValues,
            function(returnHTML) {
              addToLocation(returnHTML,location);
            });
          }

          function postAndAddToLocation_search_result(url, formValues, location) {
            $.post(url, formValues,
              function(returnHTML) {
                addToLocation(returnHTML,location);
              });
            }

            function getAndAddToLocation_callback(callback, url, location ) {
              getAndAddToLocation(url, location);
              if (typeof callback === "function") {
                callback(url);
              }
            }

            function getAndAddToLocation(url, location) {
              $.get(url, function(returnHTML) {
                addToLocation(returnHTML, location);
              });
            }

            function addToLocation(html, location) {
              var result_location = $(document).find(location);
              $(result_location).html(html);
              $(result_location).css("display", "block");
            }

          });

          function hideOverlay() {
            var overlay_location = $(document).find("#overlayArea");
            var result_location = $(document).find("#overlayContent");
            $(result_location).html("");
            $(overlay_location).css("display", "none");
            $(result_location).css("display", "none");
          }

