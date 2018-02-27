command: "/usr/local/bin/bash /Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/scripts/stats.sh"

refreshFrequency: 3000 # ms

render: (output) ->
  """
    <div class='stats'></div>
  """

style: """
  font: 14px Hack;
  right: 20px;
  bottom: 5px;
  color: #E5E8E7;
  height: 14px;
  width:100%;
  .hdd,.cpu,.mem,.netarrow
    font-family: FontAwesome;
    font-size:16px;
    margin-top:0px
  .hdd
    color:#35CCCB;
  .cpu
    color:#8DC152;
    font-size:16px;
  .mem
    color:#FAC836;
    font-size:17px!important;
    line-height:1px;
    position:absolute;
    bottom:8px;
    right:224px;
  .netspeed
    margin-top:-3px;
  .netarrow
    line-height:1px
  .netarrow.orange
    color:#F69126;
    position:absolute;
    font-size:18px!important;
    left:70px;
    bottom:8px;
  .netarrow.blue
    color:#34A3DF;
    position:absolute;
    font-size:18px!important;
    left:-15px;
    bottom:8px;
  #networkWidgets
    position:absolute;
    left:135px;
  #hardwareWidgets
    right: 10px;
    position:absolute;
    
"""


getCPU: (cpu) ->
  cpuNum = parseFloat(cpu)
  # I have four cores, so I divide my CPU percentage by four to get the proper number
  cpuNum = (cpuNum/4)
  cpuNum = cpuNum.toFixed(1)
  cpuString = String(cpuNum)
  if cpuNum < 10
    cpuString = '0' + cpuString
  return "<span class='icon cpu'>&nbsp&nbsp</span>" +
         "<span class='white'>#{cpuString}%</span>"

getMem: (mem) ->
  memNum = parseFloat(mem)
  memNum = memNum.toFixed(1)
  memString = String(memNum)
  if memNum < 10
    memString = '0' + memString
  return "<span class='mem icon'>&nbsp&nbsp</span>" +
         "<span class='white'>#{memString}%</span>"

convertBytes: (bytes) ->
  kb = bytes / 1024
  return @usageFormat(kb)

usageFormat: (kb) ->
    mb = kb / 1024
    if mb < 0.01
      return "0.00mb"
    return "#{parseFloat(mb.toFixed(2))}MB"

getNetTraffic: (down, up) ->
  downString = @convertBytes(parseInt(down))
  upString = @convertBytes(parseInt(up))
  return "<div id='networkWidgets'><span class='netarrow icon blue'></span>" +
         "<span class='netspeed'>&nbsp#{downString}&nbsp</span>" +
         "<span>&nbsp</span>" +
         "<span class='netarrow icon orange'></span>" +
         "<span class='netspeed'>&nbsp&nbsp#{upString}</span></div>"

getFreeSpace: (space) ->
  return "<span class='icon hdd'></span>&nbsp<span class='white'>#{space}gb</span>"

update: (output, domEl) ->

  # split the output of the script
  values = output.split('@')

  cpu  = values[0]
  mem  = values[1]
  down = values[2]
  up   = values[3]
  free = values[4].replace(/[^0-9]/g,'')

  # create an HTML string to be displayed by the widget
  htmlString =  @getNetTraffic(down, up) + "<div id='hardwareWidgets'><span class='cyan'>&nbsp&nbsp</span>&nbsp" +
                @getMem(mem) + "<span class='cyan'>&nbsp⎢&nbsp</span>" +
                @getCPU(cpu) + "<span class='cyan'>&nbsp⎢&nbsp</span>" +
                @getFreeSpace(free) + "</div>"

  $(domEl).find('.stats').html(htmlString)
