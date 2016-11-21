module.exports = ((JSJS) ->
  (onConsoleLog) ->
    jsObjs = JSJS.Init()

    ptrFakeConsole = (t) ->
      JSJS.NewFunction jsObjs.cx, JSJS.wrapFunction({
        func: (_message) ->
          message = JSJS.identifyConvertValue JSJS.Types.dynamicPtr, _message
          onConsoleLog message, t
          return
        args: [JSJS.Types.dynamicPtr]
        returns: null
      }), 1, t

    ptrFakeConsoleLog = ptrFakeConsole('log')

    consoleGetProperty = (prop) ->
      switch prop
        when 'log' then { type: JSJS.Types.funcPtr, val: ptrFakeConsoleLog }
        else
          return true

    consoleClass = JSJS.CreateClass JSJS.JSCLASS_GLOBAL_FLAGS,
      JSJS['PropertyStub'], JSJS['PropertyStub'], JSJS.wrapGetter( consoleGetProperty, JSJS.Types.bool),
      JSJS['StrictPropertyStub'], JSJS['EnumerateStub'], JSJS.wrapResolver (propName) ->
        (['log']).indexOf(propName) != -1
      JSJS['ConvertStub'], JSJS['FinalizeStub']
    jsConsole = JSJS.DefineObject jsObjs.cx, jsObjs.glob, "console", consoleClass

    jsObjs
)(window.JSJS)
