a = navigator.userAgent || navigator.vendor || window.opera
isMobile = if /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4)) then true

$ ->
  $html = $('html')
  $window = $(window)
  scrollY = 0

  #
  # Newsletter
  #

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

  #
  # Mobile check
  #

  if isMobile
    $html.addClass('is-mobile')
    return false

  #
  # Budget
  #

  $budget = $('#budget')
  $budgetGraph = $('.js-budget__graph')
  $budgetGraphTicks = $('.js-budget__graph-ticks')
  $budgetFeatures = $budget.find('.js-budget__feature')
  $budgetBars = $budget.find('.js-budget__bar')
  budgetIndex = -999

  selectBudgetFeature = (n) ->
    return if n == budgetIndex

    $budgetFeatures.addClass('is-hidden')
    $budgetBars.removeClass('is-hidden')

    budgetIndex = n
    $budgetFeature = $($budgetFeatures[n]).removeClass('is-hidden')

    for i in [0..1]
      if i > Math.max(0, 1 - n)
        $budgetBar = $($budgetBars[i])
        $budgetBar.addClass('is-hidden')


  scrollBudget = ->
    wh = $window.height()
    bY = $budgetGraph.offset().top
    bh = $budgetGraph.height()

    perc = 1 - ((bY - wh / 2 + bh / 2) - scrollY) / (wh / 2)
    n = Math.max(0, Math.min(1, Math.floor(perc)))

    selectBudgetFeature(n)


  $budgetFeatures.hover(->
    selectBudgetFeature($(this).index())
  , scrollBudget)


  #
  # Schedule
  #

  $schedule = $('#schedule')
  $scheduleGraph = $schedule.find('.js-schedule__graph')
  $scheduleFeatures = $schedule.find('.js-schedule__feature')
  scheduleIndex = -2

  selectScheduleFeature = (n) ->
    return if n == scheduleIndex
    $scheduleFeatures.find('.timeline-item__dot.is-weak').addClass('is-collapsed')
    $scheduleFeatures.find('.timeline__tooltip').addClass('is-hidden')
    $scheduleFeatures.addClass('is-hidden')

    scheduleIndex = n
    $scheduleFeature = $($scheduleFeatures[n])

    $scheduleFeature.removeClass('is-hidden')
    $scheduleItem = $scheduleFeature.find('.js-timeline__item')
    $scheduleItem.find('.timeline-item__dot.is-weak').removeClass('is-collapsed')
    $scheduleFeature.find('.timeline__tooltip').removeClass('is-hidden')


  scrollSchedule = ->
    wh = $window.height()
    sy = $scheduleGraph.offset().top
    sh = $scheduleGraph.height()

    perc = 1 - ((sy - wh / 3 + sh / 2) - scrollY) / (wh / 3)#-((sy + sh) - (scrollY + wh)) / (wh - sh)
    n = Math.max(0, Math.min(2, Math.round(perc * 2)))

    selectScheduleFeature(n)


  $scheduleFeatures.hover(->
    selectScheduleFeature($(this).index())
  , scrollSchedule)


  #
  # Insights
  #

  $insight = $('#insights')
  $insightImages = $('.js-insight__image')
  insightIndex = -1

  selectInsightFeature = (n) ->
    return if n == insightIndex
    $insightImages.addClass('is-hidden')

    insightIndex = n
    $insightImage = $($insightImages[n]).removeClass('is-hidden')


  scrollInsight = ->
    wh = $window.height()
    iy = $insightImages.offset().top
    ih = $insightImages.height()

    perc = 1 - (iy - scrollY) / (wh - ih)
    n = Math.max(0, Math.min(2, Math.round(perc * 2)))

    selectInsightFeature(n)


  scrolled = (e) ->
    scrollY = $window.scrollTop()

    scrollBudget()
    scrollSchedule()
    scrollInsight()

  $window.scroll(scrolled)
  $window.resize(scrolled)
  scrolled()


  #
  # nudge
  #

  $('.js-hero__nudge').click (e) ->
    e.preventDefault()

    $('html,body').animate(scrollTop: $budget.offset().top - $budget.height(), 1000)

  nudged = (e) ->
    $html.addClass('is-scrolled')

    $window.unbind('scroll', nudged)

  $window.bind('scroll', nudged)
