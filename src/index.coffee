defaultLoaders = require './loaders/defaults'

_ = require 'lodash'


resolveModule = (identifier, separator) ->
  separator ?= ':'

  attributeIndex = identifier.lastIndexOf separator

  if attributeIndex >= 0
    attributeName = identifier[attributeIndex+1..]
    moduleName = identifier[..attributeIndex-1]
  else
    moduleName = identifier

  containedModule = require moduleName

  if attributeName?
    return containedModule[attributeName]

  return containedModule


load = (identifier, options, callback) ->
  if _.isFunction options
    callback = options
    options = {}

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

    Type = resolveModule match.module
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


module.exports = {load}
