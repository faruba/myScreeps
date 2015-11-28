{Container,Good, Wheel, Hand, Frame, HightOrderFuncPair} = require('../src/robot')
{eql, equal, runTestSuit} = require('../src/testTool')

testPutIn = (con, input) ->
	con.putIn(input)
	return con.capacityLeft()

testPutInWhenFull = (con, input) ->
	return con.putIn(input)

testGetFrom =(con, input) ->
	res = con.getFrom(input)
	return res

testMove = (wheel, input) ->
	switch input.opt
		when "move" then wheel.forward()
		when "back" then wheel.backward()
		when "turn" then wheel.turnTo(input.dir)
		when "slow" then wheel.slowDown(input.per)
	return {pos:wheel.pos,dir:wheel.direction}

testHand = (env, input) ->
	switch input.opt
		when "grab" then env.hand.grab(env.resource)
		when "drop" then env.hand.drop(env.resource)
		when "store" then env.hand.store(env.resource)
	return {hand:env.hand.good, box : env.box.goods, res : env.resource.goods}

testFram = (env,input) ->
	switch input.opt
		when "grab" then env.frame.grab(env.resource)
		when "drop" then env.frame.drop(env.resource)
		when "store" then env.frame.store(env.resource)
	return {hand:env.hand.good, box : env.box.goods, res : env.resource.goods}

frame_init_new_and_replace = () ->
	frame = new Frame()
	frame.install(new TestFrameMode1, 1)
	frame.install(new TestFrameMode2, 2)
	frame.install(new TestFrameMode1, 2)
	return frame

frame_init_new_and_remove = () ->
					frame = new Frame()
					frame.install(new TestFrameMode1, 1)
					frame.install(new TestFrameMode2, 2)
					frame.remove(2)
					return frame

class TestFrameMode1
	detach :() -> return 'detach1'
	attach :() -> return 'a1'
	getType : () -> return 1
	t1 :(arg) -> return "T1C"+arg
class TestFrameMode2
	detach :() -> return 'detach1'
	attach :() -> return 'a2'
	getType : () -> return 3
	t2 :() -> return "T2C"

testFrame_dispatch = (frame, input) ->
	switch input.name
		when "getType"
			ret = frame.getType()
		when "t1"
			ret = frame.t1(input.arg)
		when "t2"
			ret = frame.t2()
	return ret
testSuitList =[
	{
		describe: 'Container',
		its : [
			{
				it: '1 putIn empty -> full',
				init : () -> return new Container(10),
				do: testPutIn,
				assert : equal
				tests : [
					{input: {type:1, count:2}, expect :8},
					{input: {type:1, count:4}, expect :4},
					{input: {type:1, count:4}, expect :0},
					{input: {type:1, count:4}, expect :0},
				]
			},
			{
				it: '2 putIn full same time',
				init : () -> return new Container(10,{
					1:new Good(1, 1),
					2:new Good(2, 2),
					3:new Good(3, 3)}),
				do: testPutIn,
				assert : equal
				tests : [
					{input: {type:1, count:2}, expect :2},
					{input: {type:1, count:2}, expect :0},
					{input: {type:1, count:2}, expect :0},
				]
			},
			{
				it: '3 putIn full different type',
				init : () -> return new Container(10,{
					1:new Good(1, 1),
					2:new Good(2, 2),
					3:new Good(3, 3)}),
				do: testPutIn,
				assert : equal
				tests : [
					{input: {type:1, count:1}, expect :3},
					{input: {type:2, count:3}, expect :0},
					{input: {type:3, count:2}, expect :0},
				]
			},
			{
				it: '4 putIn full check return ',
				init : () -> return new Container(10,{
					1:new Good(1, 1),
					2:new Good(2, 2),
					3:new Good(3, 3)}),
				do: testPutInWhenFull,
				assert : eql,
				tests : [
					{input: {type:1, count:3}, expect :{left: 0}},
					{input: {type:2, count:3}, expect :{left: 2}},
					{input: {type:3, count:2}, expect :{left: 0}},
				]
			},
			{
				it: '5 getFrom until empty same type',
				init : () -> return new Container(10,{
					1:new Good(1, 10)}),
				do: testGetFrom,
				assert : eql,
				tests : [
					{input: {type:1, count:3}, expect :new Good(1,3)},
					{input: {type:1, count:4}, expect :new Good(1,4)},
					{input: {type:1, count:4}, expect :new Good(1,3)},
					{input: {type:1, count:4}, expect :null},
				]
			},
			{
				it: '6 getFrom until empty different type',
				init : () -> return new Container(10,{
					1:new Good(1, 2),
					2:new Good(2, 4)}),
				do: testGetFrom,
				assert : eql,
				tests : [
					{input: {type:1, count:1}, expect :new Good(1,1)},
					{input: {type:1, count:4}, expect :new Good(1,1)},
					{input: {type:2, count:5}, expect :new Good(2,4)},
					{input: {type:3, count:4}, expect :null},
				]
			},
			{
				it: '7 getFrom default type',
				init : () -> return new Container(10,{
					1:new Good(1, 2),
					2:new Good(2, 4)}),
				do: testGetFrom,
				assert : eql,
				tests : [
					{input: {count:1}, expect :new Good(1,1)},
					{input: {count:4}, expect :new Good(1,1)},
					{input: {count:5}, expect :new Good(2,4)},
					{input: {count:4}, expect :null},
				]
			}
		]
	},

	{
		describe: 'Wheel',
		its : [
			{
				it: '1 whell move like this N<--->S then W<--->E',
				init : () -> return new Wheel(),
				do: testMove,
				assert : eql
				tests : [
					{input: {opt:"move"}, expect :{pos:{x:0,y:5},dir:0}},
					{input: {opt:"back"}, expect :{pos:{x:0,y:0},dir:0}},
					{input: {opt:"turn",dir: 6}, expect :{pos:{x:0,y:0},dir:6}},
					{input: {opt:"move"}, expect :{pos:{x:0,y:0},dir:6}}, # cant move 
					{input: {opt:"back"}, expect :{pos:{x:5,y:0},dir:6}},
					{input: {opt:"move"}, expect :{pos:{x:0,y:0},dir:6}},
					{input: {opt:"turn",dir: 1}, expect :{pos:{x:0,y:0},dir:1}},
					{input: {opt:"move"}, expect :{pos:{x:5,y:5},dir:1}},
					{input: {opt:"slow", per: 80}, expect :{pos:{x:5,y:5},dir:1}},
					{input: {opt:"back"}, expect :{pos:{x:4,y:4},dir:1}},
				]
			},
		]
	},
		
	{
		describe: 'Hand',
		its : [
			{
				it: '1 grub from container and put in bag',
				init : () ->
					frame = new Frame()
					box = new Container()
					frame.install(box,1)
					hand = new Hand()
					frame.install(hand,2)
					return {frame: frame, hand : hand, box: box, resource : new Container(10,{
					1:new Good(1, 1),
					2:new Good(2, 2),
					3:new Good(3, 3)}),}
				,
				do: [testHand,testFram],
				assert : eql
				tests : [
					#return {hand:hand.good, box : env.box, res : evn.resource}
					{input: {opt:"drop"}, expect :{
						hand:null,
						box :{},
						res:{1:{type:1, count:1},2:{type:2,count:2},3:{type:3,count:3}},
					}},
					{input: {opt:"grab"}, expect :{
						hand:{type:1, count:1},
						box :{},
						res:{2:{type:2,count:2},3:{type:3,count:3}},
					}},
					{input: {opt:"grab"}, expect :{
						hand:{type:1, count:1},
						box :{},
						res:{2:{type:2,count:2},3:{type:3,count:3}},
					}},
	
					{input: {opt:"store"}, expect :{
						hand:null,
						box :{1:{type:1, count:1}},
						res:{2:{type:2,count:2},3:{type:3,count:3}},
					}},
					{input: {opt:"store"}, expect :{
						hand:null,
						box :{1:{type:1, count:1}},
						res:{2:{type:2,count:2},3:{type:3,count:3}},
					}},
					{input: {opt:"grab"}, expect :{
						hand:{type:2, count:1},
						box :{1:{type:1, count:1}},
						res:{2:{type:2,count:1},3:{type:3,count:3}},
					}},
					{input: {opt:"store"}, expect :{
						hand:null,
						box :{1:{type:1, count:1},2:{type:2,count:1}},
						res:{2:{type:2,count:1},3:{type:3,count:3}},
					}},
					{input: {opt:"drop"}, expect :{
						hand:null,
						box :{1:{type:1, count:1},2:{type:2,count:1}},
						res:{2:{type:2,count:1},3:{type:3,count:3}},
					}},
				]
			},
		]
	},

	{
		describe: 'HihtOrderFuncPair',
		its : [
			{
				it: '1 Frame the function of dispatch',
				init : () -> return new HightOrderFuncPair({1:'a', 2:'b', 3:'c'}) ,
				do: (pair, input) ->
					switch input.name
						when "map"
							return pair.map((k,v,arg) ->
								return [k*arg,v+arg]
							,input.arg).valueOf()
						when "filter"
							return pair.filter((k,v,arg) ->
								return k is arg or v is arg
							,input.arg).valueOf()
						when "reduce"
							return pair.reduce(
								(preVale,cur) ->
									return preVale+cur.k+cur.v
								,
								input.arg).valueOf()
				,
				assert : eql
				tests : [
					{input: {name:"map",arg:4}, expect :{4:'a4',8:'b4',12:'c4'}},
					{input: {name:"filter",arg:'1'}, expect :{1:'a'}},
					{input: {name:"filter",arg:'b'}, expect :{2:'b'}},
					{input: {name:"reduce",arg:4}, expect :'41a2b3c'},
				]
			},
		]
	},

	{
		describe: 'Frame',
		its : [
			{
				it: '1 Frame the function of dispatch',
				init : () ->
					frame = new Frame()
					frame.install(new TestFrameMode1, 1)
					frame.install(new TestFrameMode2, 2)
					return frame
				,
				do: testFrame_dispatch,
				assert : eql
				tests : [
					{input: {name:"getType"}, expect :{1:1,2:3}},
					{input: {name:"t1", arg: '<arg>'}, expect :{1:'T1C<arg>'}},
					{input: {name:"t2",}, expect :{2:'T2C'}},
				]
			},
			{
				it: '2 Frame install and replace'
				init : frame_init_new_and_replace ,
				do: testFrame_dispatch,
				assert : eql
				tests : [
					{input: {name:"getType"}, expect :{1:1,2:1}},
					{input: {name:"t1", arg: '<arg>'}, expect :{1:'T1C<arg>',2:'T1C<arg>'}},
				]
			},
			{
				it: '3 Frame install and remove'
				init : frame_init_new_and_remove,
				do: testFrame_dispatch,
				assert : eql
				tests : [
					{input: {name:"getType"}, expect :{1:1}},
					{input: {name:"t1", arg: '<arg>'}, expect :{1:'T1C<arg>'}},
				]
			},
			{
				it: '4 Frame install and replace call function witch dose not exist'
				init : frame_init_new_and_replace,
				do: testFrame_dispatch,
				assert : 'throw'
				tests : [
					{input: {name:"t2", arg: '<arg>'}, expect :/.*has no method 't2'/},
				]
			},
			{
				it: '5 Frame install and remove call function witch dose not exist'
				init : frame_init_new_and_remove,
				do: testFrame_dispatch,
				assert : 'throw'
				tests : [
					{input: {name:"t2", arg: '<arg>'}, expect :/.*has no method 't2'/},
				]
			}
		]
	},
]


runTestSuit(testSuitList )
