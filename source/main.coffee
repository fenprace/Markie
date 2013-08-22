# Utilities
Array.prototype.last     = -> @slice(-1)[0]
Array.prototype.before   = (i) -> @slice(0, i)
Array.prototype.after    = (i) -> @slice(i + 1, @length)
Array.prototype.delete   = (e) -> @filter (t) -> t isnt e

# Initial
flag = 0

@Markie =
  source_list: []
  
  source_list_before: (index) -> @source_list.before(index)
  source_list_after : (index) -> @source_list.after(index)
  clean: -> @source_list = @source_list.join('').split("\n").delete('')
    
  source_text: -> @clean().join('\n\n')
  source_text_before: (index) -> @source_list_before(index).join('')
  source_text_after : (index) -> @source_list_after(index).join('')
  
  up: ->
    if has_content
      modify()
      flag -= 1
    flag -= 1
    refresh()
  down: ->
    flag += 1
    refresh()
    

# Functioning
resize      = -> $('#current').autosize().trigger('autosize.resize')
position    = -> document.getElementById('current').selectionStart
is_first    = -> flag is 0
is_at_end   = -> position() >= $('#current').val().length - 1
is_last     = -> @Markie.source_list_after(flag).length is 0
has_content = -> $('#current').val().length isnt 0
value       = -> $('#current').val()
for_rainbow = ->
  $('code[class^="lang-"]').each ->
    $(@).attr('data-language', $(@).attr('class')[5..])
  Rainbow.color()
modify      = -> 
  @Markie.source_list[flag] = $('#current').val()
  flag += 1
refresh     = ->
  $('#current').val @Markie.source_list[flag]
  $('#before').html marked(@Markie.source_text_before(flag))
  $('#after').html  marked(@Markie.source_text_after(flag))
  resize()
  for_rainbow()

@onKeyUp = (e) ->
  resize()
  if e.keyCode is 13 and is_at_end() and $('#current').val().match(/\n\n$/) 
    modify()
    refresh()
  
@onKeyDown = (e) ->
  resize()
  if e.keyCode is 38 and position() is 0 and not is_first()
    @Markie.up()
  if e.keyCode is 8  and position() is 0 and not is_first()
    @Markie.up()
  if e.keyCode is 40 and is_at_end()     and not is_last()
    @Markie.down()
    