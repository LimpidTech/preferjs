{Loader} = require '../src/loaders/file_loader'
loaders = require './loaders'

sinon = require 'sinon'
chai = require 'chai'


describe 'FileLoader', ->
  describe '#load', ->
    it 'results in a not found error if no file was found', (done) ->
      callback = sinon.spy (err, data) ->
        chai.expect(err).to.be.instanceof Error
        chai.expect(callback.calledOnce).to.be.true

        done()

      loader = loaders.create Loader
      loader.load 'fakeFile', callback

    it 'calls parse if a file was found', sinon.spy (done) ->
      loader = loaders.create Loader

      callback = sinon.stub loader, 'parse', ->
        chai.expect(callback.calledOnce).to.be.true
        done()

      loader.load 'loader_test.json'

    it 'throws an error if parse is called without inheriting', (done) ->
      loader = loaders.create Loader

      callback = sinon.spy (err, data) ->
        chai.expect(callback.calledOnce).to.be.true
        chai.expect(err).to.be.instanceof Error

        done()

      loader.parse '', callback
