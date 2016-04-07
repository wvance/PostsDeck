// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
// require jquery.turbolinks
//= require jquery_ujs
//
//= require d3
//= require twitter/bootstrap
//= require jquery-readyselector
//= require markdown.converter
//= require markdown.sanitizer
//= require markdown.editor
//= require awesome-share-buttons
//
//= require turbolinks
//= require_tree .

function getGeoLocation() {
  navigator.geolocation.getCurrentPosition(setGeoCookie);
}

function setGeoCookie(position) {
  var cookie_val = position.coords.latitude + "|" + position.coords.longitude;
  document.cookie = "lat_lng=" + escape(cookie_val);
}

$(document).on("turbolinks:load", function() {

  // FUNCTION FOR SMOOTH SCROLLING
  $(function() {
    $("a[href*='#']:not([href='#'])").click(function() {
      if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
        var target = $(this.hash);
        target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
        if (target.length) {
          $('html,body').animate({
            scrollTop: target.offset().top
          }, 1000);
          console.log("Success");
          return false;
        }
      }
    });
  });

  // AUTOGROW TEXT AREA
  growObject = document.getElementById('.autoGrowText');

  if(growObject != null){
    growObject.autogrow();
  }

  // $('.autoGrowText').autogrow();

  $("#subscribe").bind("ajax:complete", function(event,xhr,status){
    $('#email').val('');
  });

  // HIDE FLASH AFTER 3 SECONDS
  $(".alert").delay(2000).fadeOut(1000, function(){
      $(".alert").alert('close');
  });

  markdownEditor = document.getElementById('.wmd-button-bar');
  if(markdownEditor != null){
    // INITIALIZE MARKDOWN INPUT BOX
    var converter = Markdown.getSanitizingConverter();
    var editor = new Markdown.Editor(converter);
    editor.run();
  }

});
