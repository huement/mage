command: "/usr/local/bin/python3 /Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/scripts/weatherscript.py"

refreshFrequency: 600000 # ms

render: (output) ->
  """
    <link rel="stylesheet" type="text/css" href="/Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/colors.css" />
    <div class='compstatus'></div>
    <div class='weather_forecast'></div>
  """

style: """
  text-align: center
  right: 3%
  top: 17px
  height: 16px
  font: 16px Hack
  cursor: pointer;
  table
    margin: auto
  .center
    text-align: center
  .weather_forecast
    top: 1px
    width: 8em
    color:#E0E0E0
    background: #1f2029
    right: 30px
    opacity: 0.75
    position: relative
    border-radius: 4px
    padding:6px 8px 6px 8px
  .icon
    font-family: 'FontAwesome'
    font-size:16px;
  .ntime
    color:#80B4E7
  .dtime
    color:#FAC836
"""

colorizeTemp: (temp, thehours) ->
  #returns a formatted html string with the temperature colorized depending on
  # whether it is hot, temperate or cold
  if temp == '--'
    return "<span class='white'>--</span>";

  today = new Date
  hours = today.getHours()


  if(hours > 17 || hours < 7)
    dayNight="&nbsp&nbsp<span class='timesep icon ntime'></span>"
  else
    dayNight="&nbsp&nbsp<span class='timesep icon dtime'></span>"

  if thehours == undefined
    dayNight = ""

  tempnum = parseInt(temp);
  if tempnum >= 90
    return "#{dayNight}<span class='red' style='color:#d3232e;'>&nbsp#{temp}°</span>";
  if tempnum < 90 and tempnum >= 65
    return "#{dayNight}<span class='yellow' style='color:#c77a4b'>&nbsp#{temp}°</span>";
  if tempnum < 65
    return "#{dayNight}<span class='blue' style='color:#28ACFC'>&nbsp#{temp}°</span>";

# Yahoo has horrible documentation for these codes, the ones on their website
# are incorrect so I'm slowly fixing these by trial and error.

getWeatherCon: (connum) ->
  if connum == 0
    return "<span class='white'>Tornado</span>" ;
  if connum == 1
    return "<span class='white'>Tropical Storm</span>" ;
  if connum == 2
    return "<span class='white'>Hurricane</span>" ;
  if connum == 3
    return "<span class='white'>Severe Thunderstorms</span>" ;
  if connum == 4
    return "<span class='white'>Thunderstorms</span>" ;
  if connum == 5
    return "<span class='white'>Mixed Rain and Snow</span>" ;
  if connum == 6
    return "<span class='white'>Mixed Rain and Sleet</span>" ;
  if connum == 7
    return "<span class='white'>Mixed Snow and Sleet</span>" ;
  if connum == 8
    return "<span class='white'>Freezing Drizzle</span>" ;
  if connum == 9
    return "<span class='white'>Drizzle</span>" ;
  if connum == 10
    return "<span class='white'>Freezing Rain</span>" ;
  if connum == 11
    return "<span class='white'>Showers</span>" ;
  if connum == 12
    return "<span class='white'>Showers</span>" ;
  if connum == 13
    return "<span class='white'>Snow Flurries</span>" ;
  if connum == 14
    return "<span class='white'>Light Snow Flurries</span>" ;
  if connum == 15
    return "<span class='white'>Blowing Snow</span>" ;
  if connum == 16
    return "<span class='white'>Snow</span>" ;
  if connum == 17
    return "<span class='white'>Hail</span>" ;
  if connum == 18
    return "<span class='white'>Sleet</span>" ;
  if connum == 19
    return "<span class='white'>Dust</span>" ;
  if connum == 20
    return "<span class='white'>Foggy</span>" ;
  if connum == 21
    return "<span class='white'>Haze</span>" ;
  if connum == 22
    return "<span class='white'>Smokey</span>" ;
  if connum == 23
    return "<span class='white'>Blustery</span>" ;
  if connum == 24
    return "<span class='white'>Windy</span>" ;
  if connum == 25
    return "<span class='white'>Cold</span>" ;
  if connum == 26
    return "<span class='white'>Cloudy</span>" ;
  if connum == 27
    return "<span class='white'>Mostly Cloudy</span>" ;
  if connum == 28
    return "<span class='white'>Mostly Cloudy</span>" ;
  if connum == 29
    return "<span class='white'>Partly Cloudy</span>" ;
  if connum == 30
    return "<span class='white'>Partly Cloudy</span>" ;
  if connum == 31
    return "<span class='white'>Clear</span>" ;
  if connum == 32
    return "<span class='white'>Sunny</span>" ;
  if connum == 33
    return "<span class='white'>Fair</span>" ;
  if connum == 34
    return "<span class='white'>Mostly Sunny</span>" ;
  if connum == 35
    return "<span class='white'>Mixed Rain and Hail</span>" ;
  if connum == 36
    return "<span class='white'>Hot</span>" ;
  if connum == 37
    return "<span class='white'>Iso. Thunder</span>" ;
  if connum == 38
    return "<span class='white'>Sca. Thunder</span>" ;
  if connum == 39
    return "<span class='white'>Sca. Showers</span>" ;
  if connum == 40
    return "<span class='white'>Sca. Showers</span>" ;
  if connum == 41
    return "<span class='white'>Heavy Snow</span>" ;
  if connum == 42
    return "<span class='white'>Partly Cloudy</span>" ;
  if connum == 43
    return "<span class='white'>Heavy Snow</span>" ;
  if connum == 44
    return "<span class='white'>Partly Cloudy</span>" ;
  if connum == 45
    return "<span class='white'>Thundershowers</span>" ;
  if connum == 46
    return "<span class='white'>Snow Showers</span>" ;
  if connum == 47
    return "<span class='white'>Iso. Thunder</span>" ;
  # no internet connection
  if connum == 99
    return "<span>"

update: (output, domEl) ->

  # split the output of the script
  values = output.split('@');

  temp = values[0];
  condition = values[1];
  connum = parseInt(condition);

  # Five Day Forcast Parsing
  day0 = [values[2], values[3], values[4], values[5]]
  day1 = [values[6], values[7], values[8], values[9]]
  day2 = [values[10], values[11], values[12], values[13]]

  day3 = [values[14], values[15], values[16], values[17]]
  day4 = [values[18], values[19], values[20], values[21]]

  days = [day0, day1, day2, day3, day4]

  city = values[22]
  region = values[23]

  # create an HTML string to be displayed by the widget
  htmlString = "<span class='clickable'>" + @colorizeTemp(temp,"set") + "</span>";
  $(domEl).find('.compstatus').html(htmlString)

  # create an HTML string for the forecast widget

  if connum != 99
    forecastString = "<table style='margin-top:6px;'>";

    for day in days
        forecastString = forecastString + "<tr>" + "<td class='white'>#{day[3]}</td>" + "<td>" + "</td>" + "<td>" + @colorizeTemp(day[0]) + "</td>" + "<td>" + @colorizeTemp(day[1]) + "</td>" + "</tr>";

    forecastString = forecastString + "<tr class='center' style='margin-bottom:4px;padding-bottom:4px'><span>" + city + ', ' + region + "</span></tr>"
    forecastString = forecastString + "<tr class='center'>" + @getWeatherCon(connum) + "</tr></table>"

  $(domEl).find('.weather_forecast').html(forecastString)
  # weather forecast script
  isForecastVisable = false

  $(".clickable").on "click", ->
    console.log("button clicked!")
    if isForecastVisable == false
      $(".weather_forecast").css("opacity", "1");
      isForecastVisable = true;
    else
      $(".weather_forecast").css("opacity", "0");
      isForecastVisable = false;
    if connum == 99
      @update
