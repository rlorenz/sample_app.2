function countDown() {
    //max of 140 char
    var left = 140 - jQuery('.micropost_text_area').val().length;
    jQuery('.countdown').text(Math.abs(left));
}

jQuery(document).ready(function($) {
  updateCountdown();
  $('.micropost_text_area').change(countDown);
  $('.micropost_text_area').keyup(countDown);
});