$ ->
  $('.js-newsletter-form').submit (e) ->
    e.preventDefault()
    $form = $(this)
    $newsletter = $form.parent()
    $alert = $form.siblings('.js-newsletter-alert')
    $input = $form.find('.js-newsletter-input')
    $button = $form.find('.js-newsletter-button')

    newsletterAlert = (type, message) ->
      $alert.removeClass('alert--positive alert--negative is-hidden')
      $alert.addClass('alert--' + type)
      $alert.text(message)

    $.ajax(
      type: $form.attr('method'),
      url: $form.attr('action'),
      data: $form.serialize(),
      cache: false,
      dataType: 'jsonp',
      jsonp: 'c',
      contentType: 'application/json; charset=utf-8'
    ).done((data) ->
      data.msg = data.msg.replace(/<[^>]+.+<\/[^>]+>/, '')

      if data.result == 'success'
        message = 'Almost done! Please confirm your email address by clicking the link in the email we just sent you.'

        newsletterAlert('positive', message)
        $newsletter.addClass('is-success')
      else
        message = data.msg.replace(/(^\d \- )|( \(\#\d+\)$)/, '')
        message = message.replace(' to list Cushion Updates', '')

        if message == 'Please enter a value'
          message = 'Please enter a valid email address.'

        newsletterAlert('negative', message)
    ).fail(->
      newsletterAlert('negative', 'Could not connect to the newsletter server. Please try again.')
    ).always(->
      $form.removeClass('is-loading')
      $input.prop('disabled', false)
      $button.prop('disabled', false)

      $input.val('')
    )

    $form.addClass('is-loading')
    $input.prop('disabled', true)
    $button.prop('disabled', true)
