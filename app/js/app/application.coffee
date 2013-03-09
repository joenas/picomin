$ ->

  $.cl = (obj) ->
    console.log(obj)

  ###
  Faye!
  ###

  client = new Faye.Client 'http://' + location.hostname + ':9292/faye'

  subscription = client.subscribe '/foo', (msg) ->
    #fayeStatusMsg(msg.text)
    fayeActionHandler(msg.action) if msg.action?

  subscription.callback ->
    fayeStatus(true)

  subscription.errback (error) ->
    fayeStatus(false)

  client.bind 'transport:down', ->
    fayeStatus(false)

  client.bind 'transport:up', ->
    fayeStatus(true)

  fayeActionHandler = (action) ->
    switch action
      when 'service'  then servicesInfo()

  fayeStatus = (connected) ->
    if connected
      icon = 'icon-ok'
      #fayeStatusMsg('Faye online!')
    else
      icon = 'icon-remove'
      #fayeStatusMsg('Faye offline :(')
    #icon = if connected then 'icon-ok' else 'icon-remove'
    fayeStatusIcon icon

  fayeStatusMsg = (msg) ->
    $('span[data-id=faye-status-msg]').html(msg.replace(/\n/g, "<br>"))

  fayeStatusIcon = (icon) ->
    $('i[data-id=faye-status-icon]').attr('class', icon)

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
      renderServiceInfo service, data

  # General function to get info, on load fe
  servicesInfo = () ->
    $.getJSON '/services.json', (data) ->
      $.each data['services'], (service, data) ->
        renderServiceInfo service, data


  renderServiceInfo = (service, data) ->
    template = _.template tmpl['service-info'], { data: data, service: service }
    $('ul.list li[data-id='+service+']').html(template)


  ###
  On load
  ###

  $('#tabs a:first').tab('show')

  servicesInfo()
