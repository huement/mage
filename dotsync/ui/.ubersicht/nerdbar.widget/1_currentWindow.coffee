command: "/usr/local/bin/chunkc tiling::query --window tag"
refreshFrequency: 2000 # ms

render: (output) ->
  """
    <div class='kwmmode'><span class='white'> | </span><span id='cWinDisplay' class='white'>#{output}</span></div>
  """
#
style: """
  -webkit-font-smoothing: antialiased
  color: #FFFFFF
  font: 15px Hack
  height: 16px
  left: 320px
  overflow: hidden
  text-overflow: ellipsis
  top: 18px
  width: 500px
  .icon
    font-size: 16px
    font-family: 'FontAwesome'
"""

update: (output, domEl) ->
  modOut = output.split("-")
  $(domEl).find('#cWinDisplay').html(modOut[0])
  
#
# update: (output, domEl) ->
#
#
#   file = ""
#   screenhtml = ""
#   wins = output
#   win = ""
#   winseg = wins.split('/')
#   file = winseg[winseg.length - 1]
#   j = winseg.length - 1
#   flag1 = 0
#   flag2 = 0
#
#   while file.length >= 65
#    file = file.slice(0, -1)
#    flag1 = 1
#
#   if j > 1
#     while j >= 1
#       j -= 1
#       if (win + file).length >= 65
#         win = '…/' + win
#         break
#       else
#         win = winseg[j] + '/' + win
#
#   while win.length >= 65
#     win = win.slice(1)
#     flag2 = 1
#
#   if flag1 >= 1
#     file = file + '…'
#
#   if flag2 >= 1
#     win = '…' + win
#
#   if output == ""
#     win = "<span class='white'>…</span>"
#
#
#   $(domEl).find('.kwmmode').html("<span class='icon'></span> " +
#                                  "<span>#{output}</span><span class='white'>#{file}</span>")
