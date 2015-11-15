{assert} = require 'chai'

describe 'PSR-5 ABNF', ->

    before ->
        @parser = require '../src/parsers/psr5'

    it 'parses the array keyword', ->
        ast = @parser('array')
        parts = {}
        ast.translate parts
        expected = 'type-expression': 'array'

        assert.deepEqual parts, expected

    it 'parses the bool keyword', ->
        ast = @parser('bool')
        parts = {}
        ast.translate parts
        expected = 'type-expression': 'bool'

        assert.deepEqual parts, expected

    it 'parses multi-part type expressions', ->
        ast = @parser('int|null')
        parts = {}
        ast.translate parts
        expected = 'type-expression': 'int|null'

        assert.deepEqual parts, expected
