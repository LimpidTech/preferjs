defaultLoaders = require './loaders/defaults'

_ = require 'lodash'


class Prefer
  resolveModule: (identifier, separator) ->
    separator ?= ':'

    attributeIndex = identifier.lastIndexOf separator

    if attributeIndex
      attributeName = identifier[attributeIndex+1..]
      identifier = identifier[..attributeIndex-1]

    result = require identifier

    if attributeName?
      result = result[attributeName]

    return result


  load: (identifier, options, callback) =>
    # Allow options to be optional.
    if _.isFunction options
      callback = options
      options = undefined

    options ?= {}
    options.loaders ?= defaultLoaders

    if not options.loader?
      matches = _.filter options.loaders, (potentialLoader) ->
        if potentialLoader.match identifier
          return true
        else
          return false

      if matches.length is 0
        callback new Error 'No configuration loader found for: ' + identifier
        return

      match = _.first matches

      Type = @resolveModule match.module
      loader = new Type options

    else
      if _.isFunction options.loader
        Type = options.loader
        options.loader = new Type options

      loader = options.loader

    loader.load identifier, (err, context) ->
      unless err
        Type = loader.configurator
        configurator = new Type context, options

      callback err, configurator


instance = new Prefer

module.exports = {
  load: instance.load,
  Prefer: Prefer
}
