settings:
  animation: true

# command: "sysctl -n vm.loadavg|awk '{print $2}'"
command: "ps -A -o %cpu | awk '{s+=$1} END {print s}'"

refreshFrequency: '1m'
render: (output) -> """
<style>
  @-webkit-keyframes pulse
  {
    0% {-webkit-transform: scale(1); opacity: .8;}
    50% {-webkit-transform: scale(1.2) translateY(-4px); opacity: .6;}
    100% {-webkit-transform: scale(1); opacity: .8;}
  }
  @-webkit-keyframes pulseSmall
  {
    0% {-webkit-transform: scale(1); opacity: .8;}
    50% {-webkit-transform: scale(1.1) translateY(-4px); opacity: .6;}
    100% {-webkit-transform: scale(1); opacity: .8;}
  }
  @-webkit-keyframes pulseOpacity
  {
    0% {opacity: .9;}
    50% {opacity: .4;}
    100% {opacity: .9;}
  }
</style>
<h2>Load Average</h2>
<h1>#{output}</h1>
"""

update: (output, domEl) ->

  storageKey = 'com.brettterpstra.storedLoadVal'

  val = parseFloat(output)
  $stat = $(domEl).find('h1')

  $stat.removeClass('highest higher high normal low')
  $stat.html(output.replace(/\./,'<i>.</i>'))

  if @settings.animation
    colorclass = switch
      when val > 6 then 'highest'
      when val > 4 then 'higher'
      when val > 2 then 'high'
      when val > 1 then 'normal'
      else 'low'
    $stat.find('i').addClass colorclass

  prevVal = parseFloat(localStorage.getItem(storageKey))
  if prevVal > val
    $stat.prepend '<b class="down">&darr;</b>'
  else
    $stat.prepend '<b class="up">&uarr;</b>'

  localStorage.setItem('com.brettterpstra.storedLoadVal', val)

style: """
  border 1px solid rgba(255,255,255,0.35)
  border-radius 25px
  box-sizing border-box
  background rgba(0,0,0,0.3)  // translucent white overlay
  backdrop-filter blur(20px)         // adds the frosted glass effect
  color #141f33
  font-family -apple-system, Avenir, Helvetica Neue
  font-weight 300
  line-height 1.5
  padding 16px 20px
  left 1280px
  top 1218px
  width 260px
  text-align center
  box-shadow 0 4px 12px rgba(0,0,0,0.15)

  h1
    font-size 40px
    font-weight 600
    margin 0
    line-height 1
    font-family -apple-system, Avenir
    color rgba(255,255,255,.35)
    transition all 1s ease-in-out
  
  h2
    font-size 24px
    font-weight 400
    margin 0
    line-height 1.2
    font-family -apple-system, Avenir
    color rgba(255,255,255,.5)
    transition all 1s ease-in-out

  i
    display inline-block
    text-shadow none
    font-style normal
    animation-direction alternate
    animation-timing-function ease-out

  b
    font-size 36px

  .low
    color rgba(255, 255, 255, .5)
    animation pulseOpacity 10s infinite

  .normal
    color rgba(243, 255, 134, .5)
    animation pulseOpacity 5s infinite

  .high
    color rgba(195, 147, 59, .75)
    animation pulseOpacity 3s infinite

  .higher
    color rgba(255, 141, 77, .75)
    animation pulse 2s infinite

  .highest
    color rgba(255, 71, 71, .8)
    animation pulse .6s infinite
"""
