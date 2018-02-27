refreshFrequency: false

render: (output) ->
  "<div class='top_bar'><div class='left'>&nbsp;</div><div class='right'>&nbsp;</div></div>"

style: """
  height: 26px;
  box-shadow: none;
  z-index: -1;
  width:100%;
  .left
    position:absolute;
    background-color: rgba(0,0,0,0.60);
    width: 15%;
    min-width:360px;
    left 0px;
    height:26px;
    -webkit-border-bottom-right-radius: 5px;
    border-bottom-right-radius: 5px;
  .right
    position:absolute;
    width: 20%;
    min-width:613px;
    background-color: rgba(0,0,0,0.60);
    -webkit-border-bottom-left-radius: 5px;
    border-bottom-left-radius: 5px;
    right:0px;
    height:26px;
"""
