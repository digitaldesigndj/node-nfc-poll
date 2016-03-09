async = require 'async'
gpio = require 'rpi-gpio'
zerorpc = require 'zerorpc'

client = new (zerorpc.Client)

client.connect 'tcp://127.0.0.1:4242'

client.on 'error', (error) ->
  console.error 'RPC client error:', error
  return

client.invoke 'message', 'test Message!', (error, res, more) ->
  if error
    console.error error
  else
    console.log 'UPDATE:', res
  if !more
    console.log 'Done.'
  return

waiting = false

oldTagsString = []

spawn = require('child_process').spawn

knownTags = [
    name: 'Yoshi'
    id: '04  be  e9  2a  54  49  80'
  ,
    name: 'Luigi'
    id: '04  ce  da  d2  a0  40  80'
  ,
    name: 'Dr.Mario'
    id: '04  d9  61  72  b2  48  80'
  ,
    name: 'keychain'
    id: '04  47  3b  da  99  3c  80'
  ,
    name: 'lightGreen'
    id: '04  52  bb  da  ed  44  80'
  ,
    name: 'green'
    id: '04  75  95  da  ed  44  80'
  ,
    name: 'red'
    id: '04  a2  4b  da  ed  44  80'
  ,
    name: 'lightRed'
    id: '04  44  bc  da  ed  44  81'
  ,
    name: 'yellow'
    id: '04  85  f1  da  ed  44  80'
  ,
    name: 'orange'
    id: '04  43  9b  da  ed  44  80'
  ,
    name: 'blue'
    id: '04  80  65  da  ed  44  81'
  ,
    name: 'skyBlue'
    id: '04  42  c2  da  ed  44  81'
  ,
    name: 'lightBlue'
    id: '04  3b  96  6a  a0  48  81'
  ,
    name: 'redBlue'
    id: '04  0c  af  da  ed  44  81'
  ,
    name: 'darkGreen'
    id: '04  52  ae  da  ed  44  81'
  ,
    name: 'card'
    id: 'd1  52  ee  cf'
]

loopFunc = ->
  spawnLoop = spawn 'nfc-list'
  spawnLoop.stdout.on 'data', ( data ) ->
    # console.log '' + data
    dataString = '' + data
    lines = dataString.split '\n'
    if lines.length isnt 3
      waiting = false
      console.log lines[2][0] + ' Tags Found'
      tagLines = lines.filter ( v, i ) ->
        if !v.indexOf '       UID (NFCID1):'
          return v
      tags = tagLines.map ( v ) ->
        return v.trim().replace 'UID (NFCID1): ', ''
      if JSON.stringify( tags ) is oldTagsString
        # console.log 'tick!'
      else
        # console.log tags
        ledsOff()
        processTags tags
      oldTagsString = JSON.stringify tags
    else
      if !waiting
        console.log '0 Tags Found'
        ledsOff()
        client.invoke 'message', 'NFC Wait...'
        waiting = true
        oldTagsString = []
    return
  spawnLoop.stderr.on 'data', ( data ) ->
    console.log 'stderr: ' + data
    return
  spawnLoop.on 'close', ( code ) ->
    # console.log 'child process exited with code' + code
    return loopFunc()
  return

spliceSlice = (str, index, count, add) ->
  str.slice(0, index) + (add or '') + str.slice(index + count)

processTags = ( tags ) ->
  ourTags = []
  tags.forEach ( v, i ) ->
    knownTags.forEach ( tag ) ->
      # console.log tag.id
      if tag.id is v
        ourTags.push tag.name
      return
    if i + 1 isnt ourTags.length
      ourTags.push v
    return
  ourTags.forEach ( tag ) ->
    console.log tag
    if tag is 'keychain'
      gpio.write 40, true
    if tag is 'Dr.Mario'
      gpio.write 40, true
    if tag is 'Luigi'
      gpio.write 18, true
      gpio.write 16, true
      gpio.write 12, true
    if tag is 'lightRed'
      gpio.write 38, true
    if tag is 'red'
      gpio.write 36, true
    if tag is 'orange'
      gpio.write 32, true
    if tag is 'yellow'
      gpio.write 22, true
    if tag is 'green'
      gpio.write 18, true
    if tag is 'lightGreen'
      gpio.write 18, true
    if tag is 'darkGreen'
      gpio.write 18, true
    if tag is 'Yoshi'
      gpio.write 18, true
    if tag is 'lightBlue'
      gpio.write 16, true
    if tag is 'skyBlue'
      gpio.write 16, true
    if tag is 'blue'
      gpio.write 12, true
  client.invoke 'message', spliceSlice( ourTags.join( ' ' ), 16, 0, '\n' )
  return

loopFunc()

# gpio.setup 18, gpio.DIR_OUT, write
#
# write = ->
#   console.log 'write!'

# setInterval loopFunc, 500

async.parallel [
  ( callback ) ->
    gpio.setup 12, gpio.DIR_OUT, callback
    return
  ( callback ) ->
    gpio.setup 16, gpio.DIR_OUT, callback
    return
  ( callback ) ->
    gpio.setup 18, gpio.DIR_OUT, callback
    return
  ( callback ) ->
    gpio.setup 22, gpio.DIR_OUT, callback
    return
  ( callback ) ->
    gpio.setup 32, gpio.DIR_OUT, callback
    return
  ( callback ) ->
    gpio.setup 36, gpio.DIR_OUT, callback
    return
  ( callback ) ->
    gpio.setup 38, gpio.DIR_OUT, callback
    return
  ( callback ) ->
    gpio.setup 40, gpio.DIR_OUT, callback
    return
], ( err, results ) ->
  console.log 'Pins set up, Testing...'
  gpio.write 40, true, ->
    setTimeout ->
      gpio.write 40, false, ->
        console.log 'Test complete'
    , 5000
  return

ledsOff = ->
  async.parallel [
    ( callback ) ->
      gpio.write 12, false, callback
      return
    ( callback ) ->
      gpio.write 16, false, callback
      return
    ( callback ) ->
      gpio.write 18, false, callback
      return
    ( callback ) ->
      gpio.write 22, false, callback
      return
    ( callback ) ->
      gpio.write 32, false, callback
      return
    ( callback ) ->
      gpio.write 36, false, callback
      return
    ( callback ) ->
      gpio.write 38, false, callback
      return
    ( callback ) ->
      gpio.write 40, false, callback
      return
  ], ( err, results ) ->
      # console.log 'lights out'
    return

# 12, 16, 18, 22, 32, 36, 38, 40
