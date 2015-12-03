assert = require('assert')
should = require('should')

eql = (result, expect,msg) ->
  if result?
    result.should.eql(expect,msg)
  else
    assert.equal(result, expect,msg)
equal = assert.equal


exports.equal = equal
exports.eql =eql



test = (assertFun, funNeedTest, rule, env,idx) ->
  if typeof assertFun is 'function'
    mode = 'assert'
  else if typeof assertFun is 'string'
    mode = assertFun

  lab = if rule.lable? then rule.lable else "test "+(idx+1)
  switch mode
    when 'assert' then assertFun(funNeedTest(env, rule.input), rule.expect, lab)
    when 'throw' then funNeedTest.bind(null, env, rule.input).should.throw(rule.expect, lab)
    when 'notThrow' then funNeedTest.bind(null, env, rule.input).should.not.throw(rule.expect, lab)


runTestSuit = (testSuitList) ->
  testSuitList.forEach((testSuit) ->
    describe(testSuit.describe, () ->
      testSuit.its.forEach((theIt) ->
        it(theIt.it, (done) ->
          env = theIt.init()
          theIt.tests.forEach((testRule,idx) ->
            if typeof theIt.do is 'function'
              test(theIt.assert, theIt.do, testRule, env,idx)
            else if Array.isArray(theIt.do)
              theIt.do.forEach((theDo) ->
                test(theIt.assert, theDo, testRule, env,idx))
          )
          done()
        )
      )
    )
  )

exports.runTestSuit = runTestSuit
