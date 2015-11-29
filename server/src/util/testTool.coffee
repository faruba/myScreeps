assert = require('assert')
should = require('should')

eql = (result, expect) ->
	if result?
		result.should.eql(expect)
	else
		assert.equal(result, expect)
equal = assert.equal


exports.equal = equal
exports.eql =eql



test = (assertFun, funNeedTest, rule, env) ->
	if typeof assertFun is 'function'
		mode = 'assert'
	else if typeof assertFun is 'string'
		mode = assertFun

	switch mode
		when 'assert' then assertFun(funNeedTest(env, rule.input), rule.expect, rule.lable)
		when 'throw' then funNeedTest.bind(null, env, rule.input).should.throw(rule.expect, rule.lable)
		when 'notThrow' then funNeedTest.bind(null, env, rule.input).should.not.throw(rule.expect, rule.lable)


runTestSuit = (testSuitList) ->
	testSuitList.forEach((testSuit) ->
		describe(testSuit.describe, () ->
			testSuit.its.forEach((theIt) ->
				it(theIt.it, (done) ->
					env = theIt.init()
					theIt.tests.forEach((testRule) ->
						if typeof theIt.do is 'function'
							test(theIt.assert, theIt.do, testRule, env)
						else if Array.isArray(theIt.do)
							theIt.do.forEach((theDo) ->
								test(theIt.assert, theDo, testRule, env))
					)
					done()
				)
			)
		)
	)

exports.runTestSuit = runTestSuit
