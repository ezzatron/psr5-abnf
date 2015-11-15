describe 'PSR-5 ABNF', ->

    beforeEach ->
        @parser = require '../src/parsers/psr5'

    it 'does not completely explode', ->
        @parser()
