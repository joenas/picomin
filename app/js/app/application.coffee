$ ->

  $.cl = (obj) ->
    console.log(obj)

  ###
  Templates
  ###
  _.templateSettings =
    evaluate:    /\{\{(.+?)\}\}/g
    interpolate: /\{\{=(.+?)\}\}/g

  tmpl = {}

  $.each $('script[id^=tmpl-]'), (t) ->
    name = $( @ ).attr( "id" ).replace( "tmpl-", "" )
    tmpl[name] = $( @ ).html()
    return true

  ###
  General button binders
  ###

  # Close button
  $(document).on "click", 'button.close', () ->
    $('div.alert').hide()

  # Menu: Services
  $(document).on "click", 'a[data-menu=services]', () ->
    servicesInfo()

  # Close button
  $(document).on "click", 'button[data-dismiss=alert]', () ->
    $(@).parent().hide()

  ###
  Services page
  ###

  # Controls to start/restart etc
  $(document).on "click", 'input[data-type=service_control]', (e) ->
    service = $(this).data('service')
    action = $(this).data('action')
    url = ['/service', service, action].join('/')

    $.getJSON url + '.json', (data) ->
      if data['message'] isnt null
        $('.alert').show()
        $('.alert-message').html data['message'].replace(/\n/g, "<br>")
      renderServiceInfo data['service']

  # General function to get info, on load fe
  servicesInfo = () ->
    $.getJSON '/services.json', (data) ->
      _.each data['services'], (service) ->
        renderServiceInfo service

  renderServiceInfo = (service) ->
    template = _.template tmpl['service-info'], service
    $('ul.list li[data-id='+service.id+']').html(template)

  ###
  On load
  ###

  $('#tabs a:first').tab('show')

  servicesInfo()
