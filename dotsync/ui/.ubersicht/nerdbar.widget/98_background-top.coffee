refreshFrequency: false

render: (output) ->
  "<div class='bottom_bar'><div class='bleft'>&nbsp;</div><div class='bright'>&nbsp;</div></div>"

style: """
  height: 26px;
  box-shadow: none;
  z-index: -1;
  width:100%;
  position:abbsolute;
  bottom:0;
  .bleft
    position:absolute;
    background-color: rgba(0,0,0,0.60);
    width: 15%;
    min-width:280px;
    left 0px;
    bottom: 0;
    height:26px;
    -webkit-border-bottom-right-radius: 5px;
    border-bottom-right-radius: 5px;
  .bright
    position:absolute;
    width: 18%;
    min-width:250px;
    bottom: 0;
    background-color: rgba(0,0,0,0.60);
    -webkit-border-bottom-left-radius: 5px;
    border-bottom-left-radius: 5px;
    right:0px;
    height:26px;
"""
