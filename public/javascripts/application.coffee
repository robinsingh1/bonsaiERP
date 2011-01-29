$(document).ready(->
  _b = {}
  window._b = _b
  # Speed in milliseconds
  speed = 300
  # csfr
  csfr_token = $('meta[name=csfr-token]').attr('content')
  # Date format
  $.datepicker._defaults.dateFormat = 'dd M yy'

  # Parsea la fecha con formato seleciando a un objeto Date
  # @param String fecha
  # @param String tipo : Tipo de dato a devolver
  parsearFecha = (fecha, tipo)->
    fecha = $.datepicker.parseDate($.datepicker._defaults.dateFormat, fecha )
    d = [ fecha.getFullYear(), fecha.getMonth() + 1, fecha.getDate() ]
    if 'string' == tipo
      d.join("-")
    else
      d

  # Transforms a string date in a default 
  _b.dateFormat = (date, format)->
    format = format || $.datepicker._defaults.dateFormat
    if date
      d = $.datepicker.parseDate('yy-mm-dd', date )
      $.datepicker.formatDate($.datepicker._defaults.dateFormat, d)
    else
      ""
  # Sets rails select fields with the correct datthe correct date
  setDateSelect = (el)->
    fecha = parsearFecha( $(el).val() )
    $(el).siblings('select[name*=1i]').val(fecha[0])
    $(el).siblings('select[name*=2i]').val(fecha[1])
    $(el).siblings('select[name*=3i]').val(fecha[2])

  $.setDateSelect = $.fn.setDateSelect = setDateSelect

  # Transforms the hour to just select 00, 15, 30, 
  transformMinuteSelect = (el, step = 5)->
    $el = $(el)
    val = $el.val()
    steps = parseInt(60/5) - 1
    options = []
    for k in [0..steps]
      if el == val then sel = 'selected="selected"' else sel =""
      options.push('<option value="' + (5 * k) + '" ' + sel + '>' + (5 * k) + '</option>')
    options = options.join("")

    $(el).html(options)

  # Transforms a dateselect field in rails to jQueryUI
  transformDateSelect = ->
    $(this).find('.date, .datetime').each((i, el)->
      # hide fields
      input = document.createElement('input')
      $(input).attr({ 'class': 'date-transform', 'type': 'text', 'size': 10 })
      year = $(el).find('select[name*=1i]').hide().val()
      month = (1 * $(el).find('select[name*=2i]').hide().val()) - 1
      day = $(el).find('select[name*=3i]').hide().after( input ).val()
      minute = $(el).find('select[name*=5i]')

      if minute.length > 0 then transformMinuteSelect(minute)

      # Solo despues de haber adicionado al DOM hay que 
      # usar datepicker si se define el boton
      $(input).datepicker(
        yearRange: '1900:',
        showOn: 'both',
        buttonImageOnly: true,
        buttonImage: '/stylesheets/images/calendar.gif',
        onSelect: (dateText, inst)->
          $.setDateSelect(inst.input)
      )

      if year != '' and month != '' and day != ''
        $(input).datepicker("setDate", new Date(year, month, day))
      $('.ui-datepicker').not('.ui-datepicker-inline').hide()
    )

  $.transformDateSelect = $.fn.transformDateSelect = transformDateSelect


  ##################################################

  # Presents a tooltip
  $('[tooltip]').live('mouseover mouseout', (e)->
    div = '#tooltip'
    if($(this).hasClass('error') )
      div = '#tooltip-error'

    if(e.type == 'mouseover')
      pos = $(this).position()

      $(div).css(
        'top': pos.top + 'px'
        'left': (e.clientX + 20) + 'px'
      ).html( $(this).attr('tooltip') )
      $(div).show()
    else
      $(div).hide()

  )

  # Presents more or less links
  $('a.more').live("click", ->
    $(this).html('Ver menos').removeClass('more').addClass('less').next('.hidden').show(speed)
  )
  $('a.less').live('click', ->
    $(this).html('Ver más').removeClass('less').addClass('more').next('.hidden').hide(speed)
  )


  # Creates the dialog container
  createDialog = (params)->
    data = params['data']
    delete(params['data'])
    params = $.extend({
      'id': new Date().getTime(), 'title': '', 'width': 800, 'height' : 400, 'modal': true, 'resizable' : false,
      'close': (e, ui)->
        $('#' + div_id ).parents("[role=dialog]").detach()
    }, params)
    div_id = params.id
    div = document.createElement('div')
    $(div).attr( { 'id': params['id'], 'title': params['title'] } ).data(data)
    .addClass('ajax-modal').css( { 'z-index': 10000 } )
    delete(params['id'])
    delete(params['title'])
    $(div).dialog( params )
    div

  # Gets if the request is new, edit, show
  getAjaxType = (el)->
    if $(el).hasClass("new")
      'new'
    else if $(el).hasClass("edit")
      'edit'
    else
      'show'

  window.getAjaxType = getAjaxType

  # Presents an AJAX form
  $('a.ajax').live("click", (e)->
    div = createDialog( { 'title': $(this).attr('title'), 'data': {trigger: $(this).data('trigger'), 'ajax-type': getAjaxType(this) } } )
    $(div).load( $(this).attr("href"), (e)->
      #$(div).find('a.new[href*=/], a.edit[href*=/], a.list[href*=/]').hide()
      $(div).transformDateSelect()
    )
    e.stopPropagation()
    false
  )

  currency = {'separator': ",", 'delimiter': '.', 'precision': 2}
  _b.currency = currency
  # ntc similar function to Ruby on rails number_to_currency
  # @param [String, Decimal, Integer] val
  ntc = (val)->
    val = if typeof val == 'string' then (1 * val) else val
    if val < 0 then sign = "-" else sign = ""
    val = val.toFixed(_b.currency.precision)
    vals = val.toString().replace(/^-/, "").split(".")
    val = vals[0]
    l = val.length - 1
    ar = val.split("")
    arr = []
    tmp = ""
    c = 0
    for i in [l..0]
      tmp = ar[i] + tmp
      if (l - i + 1)%3 == 0 and i < l
        arr.push(tmp)
        tmp = ''
      c++

    t = arr.reverse().join(_b.currency.delimiter)
    if tmp != ""
      sep = if t.length > 0 then _b.currency.delimiter else ""
      t = tmp + sep + t
    sign + t + _b.currency.separator + vals[1]

  # Set the global variable
  _b.ntc = ntc

  # presents the dimesion in bytes
  toByteSize = (bytes)->
    switch true
      when bytes < 1024 then bytes + " bytes"
      when bytes < Math.pow(1024, 2) then roundVal( bytes/Math.pow(1024, 1) ) + " Kb"
      when bytes < Math.pow(1024, 3) then roundVal( bytes/Math.pow(1024, 2) ) + " MB"
      when bytes < Math.pow(1024, 4) then roundVal( bytes/Math.pow(1024, 3) ) + " GB"
      when bytes < Math.pow(1024, 5) then roundVal( bytes/Math.pow(1024, 4) ) + " TB"
      when bytes < Math.pow(1024, 6) then roundVal( bytes/Math.pow(1024, 5) ) + " PB"
      else
        roundVal( bytes/ Math.pow(1024, 6)) + " EB"

  # Set the global variable
  _b.tobyteSize = toByteSize

  # Creation of Iframe to make submits like AJAX requests with files
  setIframePostEvents = (iframe, created)->
    iframe.onload = ->
      html = $(iframe).contents().find('body').html()
      if $(html).find('form').length <= 0 and created
        $('#posts ul:first').prepend(html)
        mark('#posts ul li:first')
        posts = parseInt($('#posts ul:first>li').length)
        postsSize = parseInt($('#posts').attr("data-posts_size") )
        if(posts > postsSize)
          $('#posts ul:first>li:last').remove()
        $('#create_post_dialog').dialog('close')
      else
        created = true
        $('#create_post_dialog').html(html)
  # End setIframeForPost

  # Creates an Iframe to submit
  $('a.post').live('click', ->
    if $('iframe#post_iframe').length <= 0
      iframe = $('<iframe />').attr({ 'id': 'post_iframe', 'name': 'post_iframe', 'style': 'display:none;' })[0]
      $('body').append(iframe)
      setIframePostEvents(iframe, false)
      div = createDialog({'id':'create_post_dialog', 'title': 'Crear comentario'})
    else
      div = $('#create_post_dialog').dialog("open").html("")

    $(div).load( $(this).attr("href") )

    false
  )


  # Makes that a dialog opened window makes an AJAX request and returns a JSON response
  # if response is JSON then trigger event stored in dialog else present the HTML
  $('div.ajax-modal form[enctype!=multipart/form-data]').live('submit', ->

    data = serializeFormElements(this)
    el = this
    $div = $(this).parents('.ajax-modal')
    new_record = if $div.data('ajax-type') == 'new' then true else false
    trigger = $div.data('trigger')

    $.ajax(
      'url': $(el).attr('action')
      'cache': false
      'context':el
      'data':data
      'type': (data['_method'] || $(this).attr('method') )
      'success': (resp, status, xhr)->
        try
          data = $.parseJSON(resp)
          data['new_record'] = new_record
          p = $(el).parents('div.ajax-modal')
          $(p).html('').dialog('destroy')
          $('body').trigger(trigger, [data])
        catch e
          div = $(el).parents('div.ajax-modal:first')
          div.html(resp)
          setTimeout(->
            $(div).transformDateSelect()
          ,200)
      'error': (resp)->
        alert('There are errors in the form please correct them')
    )

    false
  )
  # End submit ajax form

  # Function that handles the return of an AJAX request and process if add or replace
  # @param String template: HTML template
  # @param Object data: JSON data
  # @param String selector: jQuery selector CSS3
  # @param String node: Indicates the node type ['tr', 'li']
  updateTemplateRow = (template, data, selector, node)->
    node = node || 'tr'
    if(data['new_record'])
      $node = $.tmpl(template, data).appendTo(selector)
    else
      $node = $(selector).find("#{node}##{data.id}")
      tmp = $.tmpl(template, data).appendTo(selector).insertAfter($node)
      $node.detach()
      $node = tmp

    $node.mark()

  $.updateTemplateRow = $.fn.updateTemplateRow = updateTemplateRow

  # Delete an Item
  $('a.delete').live("click", (e)->
    $(this).parents("tr:first, li:first").addClass('marked')
    if(confirm('Esta seguro de borrar el item seleccionado'))
      url = $(this).attr('href')
      el = this

      $.ajax(
        'url': url
        'type': 'delete'
        'context': el
        'success': ->
          $(el).parents("tr:first, li:first").remove()
          $('body').trigger('ajax:delete', url)
        'error': ->
          alert('Existio un error al borrar')
      )

    else
      $(this).parents("tr:first, li:first").removeClass('marked')
      e.stopPropagation()

    return false
  )

  # Serializes values from a form to be send via AJAX
  serializeFormElements = (elem)->
    params = {}

    $(elem).find('input:not(:radio):not(:checkbox), select, textarea').each((i, el)->
      if $(el).val()
        params[ $(el).attr('name') ] = $(el).val()
    )
    $(elem).find('input:radio:checked, input:checkbox:checked').each((i, el)->
      params[ $(el).attr('name') ] = $(el).val()
    )

    params

  $.serializeFormElements = $.fn.serializeFormElements = serializeFormElements

  # Mark
  # @param String // jQuery selector
  # @param Integer velocity
  mark = (selector, velocity, val)->
    self = selector or this
    val = val or 0
    velocity = velocity or 30
    $(self).css({'background': 'rgb(255,255,'+val+')'})
    if(val >= 255)
      $(self).attr("style", "")
      return false
    setTimeout(->
      val += 5
      mark(self, velocity, val)
    , velocity)

  $.mark = $.fn.mark = mark

  start = ->
    $('body').transformDateSelect()

  start()
)
