$(function () {
  
  var MESSAGES = {
    'yes': 'SI!',
    'no': 'NO'
  }
  
  $('#js_form').submit(function () {
    var params = $(this).serialize()
    $('#loading').show()
    $.getJSON($(this).attr('action') + '?' + params, function(data) {
      if(data['rut']) {
        var klass = data['response'] ? 'yes' : 'no'
        var $e = $('#results')
        $e.find('.message').html(MESSAGES[klass])
        $e.find('#results_rut').html(data['rut'])
        $('#raw').text(data['body']).show()
        $e.removeClass('yes').removeClass('no').addClass(klass).slideDown('fast')
      } else {
        alert(data['error'])
      }
      $('#loading').hide()
    });
    return false
  })
});