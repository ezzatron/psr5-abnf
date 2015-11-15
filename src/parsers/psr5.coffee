# This is the general set up for demonstrating both
# the translation and `XML` display of the `AST`.
# See [`simple/setup.js`](../simple/setup.html) for a complete description of the various parts of this set up.

module.exports = (inputString) ->
  'use strict'
  nodeUtil = require('util')
  inspectOptions =
    showHidden: true
    depth: null
    colors: true
  try
    # Acquire the required parser components.
    grammar = new (require('../grammars/psr5'))
    apglib = require('apg-lib')
    parser = new (apglib.parser)
    # Construct an `AST` object and attach it to the parser.
    parser.ast = new (apglib.ast)
    id = apglib.ids
    # The `AST` translating callback functions. These are similar to the parsers syntax callback functions
    # in that they are each called twice, once down the tree and once up the tree, with matched phrase information.
    # With the `AST`, however, the matched phrase is known in the down direction as well as up.
    # - *state* - `SEM_PRE` (down) or `SEM_POST` (up)
    # - *chars* - the array of character codes for the entire input string.
    # - *phraseIndex* - the index in *chars* of the first character of the matched phrase
    # - *phraseLength* - the number of characters in the matched phrase
    # - *data* - the user's optional data object, passed to the translator when it is called
    # - *return value* - normally `SEM_OK`. Can also be `SEM_SKIP` in the `SEM_PRE`
    # state to skip the translation of the branch below the current node.

    typeExpression = (state, chars, phraseIndex, phraseLength, data) ->
      ret = id.SEM_OK
      if state == id.SEM_PRE
        data['type-expression'] = apglib.utils.charsToString(chars, phraseIndex, phraseLength)

      ret

    parser.ast.callbacks['type-expression'] = typeExpression

    ### use a hard coded input string ###

    # inputString = 'bool'
    inputCharacterCodes = apglib.utils.stringToChars(inputString)
    startRule = 'type-expression'

    ### parse the string here, generating an `AST` ###

    result = parser.parse(grammar, startRule, inputCharacterCodes)
    # console.log()
    # console.log 'the parser\'s results'
    # console.dir result, inspectOptions
    if result.success == false
      throw new Error('input string: \'' + inputString + '\' : parse failed')
    # Return the `AST` object for further processing.
    return parser.ast
  catch e
    msg = '\nEXCEPTION THROWN: '
    +'\n'
    if e instanceof Error
      msg += e.name + ': ' + e.message
    else if typeof e == 'string'
      msg += e
    else
      msg += nodeUtil.inspect(e, inspectOptions)
    process.exitCode = 1
    console.log msg
    throw e
  return

# ---
# generated by js2coffee 2.1.0
