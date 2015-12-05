configure = ($ = {}) ->
  $.Core ?= require("boco-mdd-jasmine-core").configure($)
  $.reduceUnique ?= (vals, val) -> vals.push(val) unless val in vals; vals

  class JavascriptService extends $.Core.ScriptService
    getVariableNames: (code) ->
      pattern = /var ([$\w]+)/gm
      match[1] while match = pattern.exec(code)

  class JavascriptSnippetsRenderer extends $.Core.SnippetsRenderer

    renderInitializeFilesVariable: ({variableName}) ->
      "var #{variableName} = {};"

    renderDescribeStart: ({text}) ->
      "describe(#{JSON.stringify(text)}, function() {"

    renderInitializeVariables: ({variableNames}) ->
      "var #{variableNames.join(', ')};"

    renderBeforeEachStart: ->
      "beforeEach(function() {"

    renderAssignFile: ({variableName, path, data}) ->
      "#{variableName}[#{JSON.stringify(path)}] = #{JSON.stringify(data)};"

    renderBeforeEachCode: ({code}) ->
      code

    renderAfterEachStart: ->
      "afterEach(function() {"

    renderDeleteFile: ({variableName, path}) ->
      "delete #{variableName}[#{JSON.stringify(path)}];"

    renderAssertionStart: ({text, isAsync, doneFunctionName}) ->
      fnArgsStr = if isAsync then doneFunctionName else ""
      "it(#{JSON.stringify(text)}, function(#{fnArgsStr}) {"

    renderAssertionCode: ({code}) ->
      code

    renderAssertionEnd: ->
      "});"

    renderAfterEachEnd: ->
      "});"

    renderBeforeEachEnd: ->
      "});"

    renderDescribeEnd: ->
      "});"

  class Generator extends $.Core.Generator
    constructor: (props = {}) ->
      super props
      @scriptService ?= new JavascriptService
      @snippetsRenderer ?= new JavascriptSnippetsRenderer

  JasmineCoffee =
    configuration: $
    configure: configure
    JavascriptService: JavascriptService
    JavascriptSnippetsRenderer: JavascriptSnippetsRenderer
    Generator: Generator

module.exports = configure()
