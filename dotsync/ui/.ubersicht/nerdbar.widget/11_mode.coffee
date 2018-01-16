command: "/usr/local/bin/bash /Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/scripts/chunk_desktop_mode.sh"

refreshFrequency: 3000 # ms

render: (output) ->
  """
   <div class='kwmmode'></div>
  """

style: """
  -webkit-font-smoothing: antialiased
  font: 15px Hack
  text-transform: uppercase
  left: 3.5%
  color:#FFFFFF
  top: 19px
  width:200px
  cursor: pointer;
  .tilingMode
    display:inline-block
    top:0px
    position:absolute
    font-weight:bold
    color:#34A3DF
    font-size:15px
    left:50px
  .icon,.si
    font-size: 15px
    font-family: 'FontAwesome'
  .screennum
    top:0px
    left:29px
    position:absolute
    font-size:16px
    font-weight:bold;
    color:#56E159
  .logo
    top:10px
    left:2.8%
    padding:6px
    border-radius:50%
    background:#1f1f1f
    position:fixed
    font-size:24px
    font-weight:bold;
    color:#D3D6D5
  .si
    font-size: 17px
    color:#E73573
    padding: 0 5px 0 5px
  .dots
    margin-left:100px
"""

update: (output, domEl) ->

  values = output.split('@')

  file = ""
  screenhtml = ""
  mode = values[0]
  totalscreens = values[2]

  if mode.includes("failed")
    screens = "NO"
  else
    screens = values[1]

  win = ""
  #console.log(mode)
  i = 0

  tshtml = ''
  count = 1
  while count <= totalscreens
    tshtml += "<span class='si screen"+count+"'></span>"
    count++;

  # The script ouputs the space names in parens so you can split them here. The
  # script outputs the names of the screens, if you prefer to use those instead
  # of generic indicators.
  screensegs = screens.split('(')

  for sseg in screensegs
    screensegs[i] = sseg.replace /^\s+|\s+$/g, ""
    i+=1

  screensegs = (x for x in screensegs when x != '')

  i = 0

  #display the html string
  $(domEl).find('.kwmmode').html("<span class='icon logo'></span> <span class='screennum'>#{screens}</span> <span class='tilingMode'>#{mode}</span><span class='dots'>#{tshtml}</span>")

  # add screen changing controls to the screen icons
  activeScreen = ".screen#{screens}"
  aSI = ""
  iSI = ""

  $(".si").html(iSI)
  $(activeScreen).html(aSI)

  $(".screen1").on 'click', => @run "osascript -e 'tell application \"System Events\" to key code 18 using control down'"
  $(".screen2").on 'click', => @run "osascript -e 'tell application \"System Events\" to key code 19 using control down'"
  $(".screen3").on 'click', => @run "osascript -e 'tell application \"System Events\" to key code 20 using control down'"
  $(".screen4").on 'click', => @run "osascript -e 'tell application \"System Events\" to key code 21 using control down'"
  $(".screen5").on 'click', => @run "osascript -e 'tell application \"System Events\" to key code 21 using control down'"

    # if mode.includes("bsp") == true
    #   $(".tilingMode").on 'click', => @run "/usr/local/bin/chunkc tiling::desktop --layout float", $(".tilingMode").text("float")
    # else if mode.includes("float") == true
    #   $(".tilingMode").on 'click', => @run "/usr/local/bin/chunkc tiling::desktop --layout monocle", $(".tilingMode").text("monocle")
    # else
    #   $(".tilingMode").on 'click', => @run "/usr/local/bin/chunkc tiling::desktop --layout bsp", $(".tilingMode").text("bsp")

  # cycle through KWM space modes by clicking on the mode icon or mode name
  if mode.includes("bsp") == true
    $(".tilingMode").on 'click', => @run "/usr/local/bin/chunkc set #{screens}_desktop_mode float"
  else if mode.includes("float") == true
    $(".tilingMode").on 'click', => @run "/usr/local/bin/chunkc set #{screens}_desktop_mode monocle"
  else
    $(".tilingMode").on 'click', => @run "/usr/local/bin/chunkc set #{screens}_desktop_mode bsp"
