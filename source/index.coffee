configure = ($ = {}) ->
  $.Core ?= require("boco-mdd-jasmine-core").configure($)
  $.CoffeeScript ?= require("coffee-script")
  $.reduceUnique ?= (vals, val) -> vals.push(val) unless val in vals; vals

  class CoffeeToken
    type: null
    value: null
    variable: null
    firstLine: null
    firstColumn: null
    lastLine: null
    lastColumn: null

    constructor: (props = {}) ->
      @[key] = val for own key, val of props

    @isVariable: (token) ->
      token.type is "IDENTIFIER" and token.variable

    @getValue: (token) ->
      token.value

    @convert: (csToken) ->
      [type, value, {first_line, first_column, last_line, last_column}] = csToken
      new CoffeeToken
        type: type, value: value, variable: csToken.variable,
        firstLine: first_line, firstColumn: first_column,
        lastLine: last_line, lastColumn: last_column

  class CoffeeScriptService extends $.Core.ScriptService
    tokenize: (code) ->
      $.CoffeeScript.tokens(code).map CoffeeToken.convert

    getVariableNames: (code) ->
      tokens = @tokenize(code).filter CoffeeToken.isVariable
      names = tokens.map CoffeeToken.getValue
      names.reduce $.reduceUnique, []

  class CoffeeSnippetsRenderer extends $.Core.SnippetsRenderer

    renderInitializeFilesVariable: ({variableName}) ->
      "#{variableName} = {}"

    renderDescribeStart: ({text}) ->
      "describe #{JSON.stringify(text)}, ->"

    renderInitializeVariables: ({variableNames}) ->
      "[#{variableNames.join(', ')}] = []"

    renderBeforeEachStart: ->
      "beforeEach ->"

    renderAssignFile: ({variableName, path, data}) ->
      "#{variableName}[#{JSON.stringify(path)}] = #{JSON.stringify(data)}"

    renderBeforeEachCode: ({code}) ->
      code

    renderAfterEachStart: ->
      "afterEach ->"

    renderDeleteFile: ({variableName, path}) ->
      "delete #{variableName}[#{JSON.stringify(path)}]"

    renderAssertionStart: ({text, isAsync, doneFunctionName}) ->
      fnArgsStr = if isAsync then "(#{doneFunctionName}) " else ""
      "it #{JSON.stringify(text)}, #{fnArgsStr}->"

    renderAssertionCode: ({code}) ->
      code

    renderAssertionEnd: -> null
    renderAfterEachEnd: -> null
    renderBeforeEachEnd: -> null
    renderDescribeEnd: -> null

  class Generator extends $.Core.Generator
    constructor: (props = {}) ->
      super props
      @scriptService ?= new CoffeeScriptService
      @snippetsRenderer ?= new CoffeeSnippetsRenderer

  JasmineCoffee =
    configuration: $
    configure: configure
    CoffeeToken: CoffeeToken
    CoffeeScriptService: CoffeeScriptService
    CoffeeSnippetsRenderer: CoffeeSnippetsRenderer
    Generator: Generator

module.exports = configure()
