command: "/usr/local/bin/bash /Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/scripts/status.sh"

refreshFrequency: 10000 # ms

render: (output) ->
  """
    <div class="compstatus"></div>
  """

style: """
  right: 150px
  top: 17px
  font: 14px Hack
  color: #FFFFFF
  height: 13px
  .time_machine
    padding: 0px 10px 0 5px;
    right: 10px;
    left: 0px;
    top:-1px
    clear:none;
    display:inline-block;
  .ntime
    color:#80B4E7
    padding-right: 4px;
  .dtime
    color:#E8D86A
    padding-right: 4px;
  .netName
    right: 0px;
    font-family: Hack
    padding-right:0px;
  .wifi
    font-size: 16px
    font-family: 'FontAwesome'
    top: 1px
    position: relative
    color:#35CCCB
    right: 8px
  .timesep.icon
    font-size: 16px
    font-family: 'FontAwesome'
    top: 1px
    position: relative
    right: -1px
  .reminders.icon, .email.icon
    font-size: 18px
    font-family: 'FontAwesome'
    top: 1px
    position: relative
    right: 0px
    color:#D0534A
  .msg-me
    right: 0px
    left: 0px
  .todo
    padding-top: 2px;
    top:3px;
    left: 0px;
    right: 20px;
  .email.icon
    top: 1px
    right: 0px
    left: -3px
    color:#34A3DF
  .charging
    font-size: 15px
    font-family: 'FontAwesome'
    position: relative
    top: 0px
    padding-right:4px
    padding-left:0px
    z-index: 1
  .charging.green
    color:#56E159
  .charging.yellow
    color:#FAC836
  .charging.red
    color:#DC4332
  .charging.white
    right: -18px
    z-index:999
    font-size: 17px
  .bat_signal
    margin-right: 20px
    margin-left: 5px
  .white.crazy
    padding: 0 3px 0 3px
  .timesep.green
    padding-right:4px
    color:#56E159
  """
timeAndDate: (date, time, dayNight) ->
  return "&nbsp&nbsp<span class='timesep icon green'></span><span class='white time_machine'>#{date} #{time}</span>&nbsp&nbsp";


batteryStatus: (battery, state, battime) ->
  #returns a formatted html string current battery percentage, a representative icon and adds a lighting bolt if the
  # battery is plugged in and charging
  batnum = parseInt(battery)
  if state == 'AC' and batnum >= 90
    return "<span class='charging white icon'></span><span class='charging green icon '></span><span class='white crazy'>#{batnum}%</span>"
  else if state == 'AC' and batnum >= 50 and batnum < 90
    return "<span class='charging white icon'></span><span class='charging green icon'></span><span class='white crazy'>#{batnum}%</span>"
  else if state == 'AC' and batnum < 50 and batnum >= 25
    return "<span class='charging white icon'></span><span class='charging yellow icon'></span><span class='white crazy'>#{batnum}%</span>"
  else if state == 'AC' and batnum < 25 and batnum >= 15
    return "<span class='charging white icon'></span><span class='charging yellow icon'></span><span class='white crazy'>#{batnum}%</span>"
  else if state == 'AC' and batnum < 15
    return "<span class='charging white icon'></span><span class='charging red icon'></span><span class='white crazy'>#{batnum}%</span>"
  else if batnum >= 90
    return "<span class='charging green icon'></span><span class='white crazy'>#{battime} #{batnum}%</span>"
  else if batnum >= 50 and batnum < 90
    return "<span class='charging green icon'></span><span class='white crazy'>#{battime} #{batnum}%</span>"
  else if batnum < 50 and batnum >= 25
    return "<span class='charging yellow icon'></span><span class='white crazy'>#{battime} #{batnum}%</span>"
  else if batnum < 25 and batnum >= 15
    return "<span class='charging yellow icon'></span><span class='white crazy'>#{battime} #{batnum}%</span>"
  else if batnum < 15
    return "<span class='charging red icon'></span><span class='white crazy'>#{battime} #{batnum}%</span>"


getWifiStatus: (status, netName, netIP) ->
  if status == "Wi-Fi"
    return "<span class='wifi'></span><span class='netName white'>#{netName}</span>&nbsp&nbsp"
  if status == 'USB 10/100/1000 LAN' or status == 'Apple USB Ethernet Adapter'
    return "<span class='wifi'></span><span class='netName white'>#{netIP}</span>&nbsp&nbsp"
  else
    return "<span class='grey wifi'></span><span class='netName white'>&nbsp--&nbsp</span>&nbsp&nbsp"


getMailCount: (count) ->
  return "<span class='msg-me'><span class='email icon'></span><span class=white>&nbsp#{count}</span></span>"


getReminders: (reminders) ->
  return "<span class='todo'><span class='reminders icon'></span><span class='white'>&nbsp#{reminders}</span></span>"



# MAIN CONTROLLER
update: (output, domEl) ->

  # split the output of the script
  values = output.split('@')
  today = new Date
  hours = today.getHours()
  if(hours > 17 || hours < 7)
    dayNight="night"
  else
    dayNight="day"

  time = values[0].replace /^\s+\s+$/g, ""
  date = values[1]
  battery = values[2]
  isCharging = values[3]
  netStatus = values[4].replace /^\s+\s+$/g, ""
  netName = values[5]
  netIP = values[6]
  mail = values[7]
  reminders = values[8].replace /^\s+\s+$/g, ""
  batteryTime = values[9]

  # create an HTML string to be displayed by the widget
  htmlString = @getWifiStatus(netStatus, netName, netIP) +
               "<span class='bat_signal'>" +
               @batteryStatus(battery, isCharging, batteryTime) +
               "</span>&nbsp" +
               @getMailCount(mail) + "&nbsp&nbsp" +
               @getReminders(reminders) + "<span></span>&nbsp" +
               @timeAndDate(date,time,dayNight) + "<span></span>&nbsp"

  $(domEl).find('.compstatus').html(htmlString)
