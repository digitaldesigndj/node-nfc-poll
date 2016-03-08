exec = require('child_process').exec

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
]

oldTagsString = []

loopFunc = ->
  return exec 'nfc-list', ( error, stdout, stderr ) ->
    if error isnt null
      console.log 'exec error:' + error
    lines = stdout.split '\n'
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
        console.log tags
      oldTagsString = JSON.stringify tags
    else
      console.log '0 Tags Found'
    # console.log 'stdout:' + stdout
    # console.log 'stderr:' + stderr


setInterval loopFunc, 1000

loopFunc()
