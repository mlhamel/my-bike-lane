jQuery ->
  $sendFeedbackBtn = $('#sendFeedback')
  $feedback = $('#feedback')

  $feedback.focus ->
    $sendFeedbackBtn.show() if $sendFeedbackBtn.is(':hidden') and $('#mobileTag').is(':visible')
    return if !$sendFeedbackBtn.hasClass 'disabled'
    $sendFeedbackBtn.removeClass 'disabled'
    $sendFeedbackBtn.addClass 'btn-primary'
    $feedback.autosize
      append: "\n"

  $feedback.blur ->
    return if $sendFeedbackBtn.hasClass('disabled') or $feedback.val().length > 0
    $('#sendFeedback').hide() if $('#sendFeedback').is(':visible') and $('#mobileTag').is(':visible')
    $sendFeedbackBtn.addClass 'disabled'
    $sendFeedbackBtn.removeClass 'btn-primary'


  $sendFeedbackBtn.click ->
    return if $feedback.val().length == 0 or $sendFeedbackBtn.hasClass 'disabled'
    $sendFeedbackBtn.addClass 'disabled'
    $sendFeedbackBtn.html 'Sending...'

    $.ajax '/feedback',
      type: 'POST',
      dataType: 'json',
      data:
        message: $feedback.val()
      error: (jqXHR, textStatus, errorThrown) ->
        alert 'There was an error trying to send feedback... Sorry!'
        console.log jqXHR
        console.log textStatus
        console.log errorThrown
      success: (data, textStatus, jqXHR) ->
        $sendFeedbackBtn.removeClass 'btn-primary'
        $sendFeedbackBtn.html 'Sent'
        $feedback.height 20
        $feedback.addClass 'disabled'
        $feedback.attr 'disabled', true
        $feedback.attr 'readonly', true
        $feedback.val data
        $feedback.html data