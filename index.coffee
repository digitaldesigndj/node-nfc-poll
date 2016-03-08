spawn = require('child_process').spawn

knownTags = [
    name: 'yoshi'
    id: '04  be  e9  2a  54  49  80'
  ,
    name: 'luigi'
    id: '04  ce  da  d2  a0  40  80'
  ,
    name: 'drMario'
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

oldTagsString = []
loopFunc = ->
  spawnLoop = spawn 'nfc-list'
  spawnLoop.stdout.on 'data', ( data ) ->
    # console.log '' + data
    dataString = '' + data
    lines = dataString.split '\n'
    if lines.length isnt 3
      'have tag(s)'
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
        processTags tags
      oldTagsString = JSON.stringify tags
    else
      console.log '0 Tags Found'
    return
  spawnLoop.stderr.on 'data', ( data ) ->
    console.log 'stderr: ' + data
    return
  spawnLoop.on 'close', ( code ) ->
    # console.log 'child process exited with code' + code
    return loopFunc()
  return

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
  console.log ourTags
  return

# setInterval loopFunc, 500

loopFunc()
