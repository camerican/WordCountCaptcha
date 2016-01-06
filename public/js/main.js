$(document).ready(function(){
  //overwrite form submission with ajax call
  $('input[type="submit"]').click(function(){
    var exclude = $.map($('#captcha .exclude'),function(el){
          console.log( "at " + el );
          return el.innerHTML;});
    if(!exclude) exclude = [];

    $.ajax( {
      url: "/",
      method: "POST",
      data: { 
        source_text: $('#captcha .text').html(),
        exclude: exclude,
        guess: $('input[name="word_count"]').val()
      },
      success: function(data,status,$xhr) {
        var data = JSON.parse($xhr.responseText);
        $('#captcha').attr('data-content',data.msg);
        $('#captcha').removeClass().addClass("pass");
      },
      error: function($xhr) {
        // console.log( $xhr );
        var data = JSON.parse($xhr.responseText);
        $('#captcha').attr('data-content',data.msg);
        $('#captcha').removeClass().addClass("fail");
      }
    });
  });
});