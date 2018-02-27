command: "osascript /Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/scripts/itunes.scpt"

refreshFrequency: 2000 # ms

render: (output) ->
  """
    <link rel="stylesheet" type="text/css" href="$HOME/mage/dotsync/macOS/Ubersicht/nerdbar.widget/colors.css" />
    <div class='nowplaying' id="play">#{output}</div>
  """

style: """
  color: #E5E8E7
  font: 14px Hack
  left: 260px
  bottom: 15px
  width:850px
  height: 16px
  cursor: pointer;
"""

afterRender: (domEl) ->
	button = $(domEl).find '#play'
	$(domEl).addClass button.get(0).className
	button.unbind 'click'
	button.on 'click', (ev) =>
    @run("osascript /Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/scripts/play.scpt")

