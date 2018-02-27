command: "/usr/local/bin/bash /Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/scripts/getvolume.sh"

refreshFrequency: 2000 # ms

render: (output) ->
  """
    <link rel="stylesheet" type="text/css" href="/Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/colors.css" />
    <input class="greenbg"  id="volume" type="range" min="0" max="100" step="5" color="green"/>
  """

style: """
  -webkit-font-smoothing: antialiased
  left: 4.5%
  bottom: 14px
  width: 150px
  input[type=range]
    -webkit-appearance: none
    background: transparent;
  input[type=range]::-webkit-slider-thumb
    -webkit-appearance: none
  input[type=range]:focus
    outline: none
  input[type=range]::-webkit-slider-thumb
    -webkit-appearance: none
    height: 20px;
    width: 20px;
    border-radius: 50%;
    background: #E73573;
    border:1px solid #fff
    cursor: pointer;
    margin-top:-5px;
  input[type=range]::-webkit-slider-runnable-track
    top: 0px;
    width: 200px;
    height: 10px;
    background: #9CDE66;
    border-radius:2px;
    cursor: pointer;
"""

update: (output, domEl) ->
  values = output.split('@')
  oldvol = parseInt(values[0])
  oldmute = values[1]
  newvol = parseInt(values[2])
  muted = values[3].replace /^\s+|\s+$/g, ""


  if oldvol != newvol or oldmute != muted
    $("#volume").val(values[2])

  if oldvol == newvol
    slidvol = $("#volume").val()
    @run "osascript -e 'set volume output volume #{slidvol}'"
