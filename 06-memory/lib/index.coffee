fs = require 'fs'
readline = require 'readline';

exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  counter = 0

  lineReader = readline.createInterface({
    input: fs.createReadStream "#{__dirname}/../data/geo.txt"
  })

  lineReader.on('line', (line) ->
    line = line.split '\t'
    # GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
    # line[0],       line[1],       line[3]

    if line[3] == countryCode then counter += +line[1] - +line[0]
  )

  lineReader.on('close', () -> cb null, counter)
