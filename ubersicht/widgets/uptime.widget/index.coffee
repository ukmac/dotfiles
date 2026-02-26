settings:
  animation: true

command: """
up=$(( $(date +%s) - $(sysctl -n kern.boottime | awk -F'[=, ]' '{print $5}') ));
printf "%dd %dh %dm\\n" $((up/86400)) $(((up%86400)/3600)) $(((up%3600)/60))
"""


refreshFrequency: '1m'
render: (output) -> """
<h2>Uptime</h2>
<h1>#{output}</h1>
"""

update: (output, domEl) ->    

  $(domEl).find('h1').text output.trim()



style: """
  border 1px solid rgba(255,255,255,0.35)
  border-radius 25px
  box-sizing border-box
  background rgba(0,0,0,0.3)  // translucent white overlay
  backdrop-filter blur(20px)         // adds the frosted glass effect
  color #141f33
  font-family -apple-system, Avenir
  font-weight 300
  line-height 1.5
  padding 16px 20px
  left 1550px
  top 1216px
  width 280px
  text-align center
  box-shadow 0 4px 12px rgba(0,0,0,0.15)

  h1
    font-size 40px
    font-weight 600
    margin 0
    line-height 1
    font-family -apple-system, Avenir
    color rgba(255,255,225,0.40)
    letter-spacing -1px
    transition all 0.3s ease-in-out
  
  h2
    font-size 24px
    font-weight 400
    margin 0
    line-height 1.2
    font-family -apple-system, Avenir
    color rgba(255,255,225,0.5)
    letter-spacing 0.5px
    transition all 0.3s ease-in-out
"""
