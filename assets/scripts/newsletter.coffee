$ ->
  $('.js-newsletter-form').submit (e) ->
    e.preventDefault()
    $form = $(this)
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
      if data.result == 'success'
        newsletterAlert('positive', data.msg)
      else
        newsletterAlert('negative', data.msg.replace(/(^\d \- )|( \(\#\d+\)$)/, ''))
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
