var ANSI_CODES = {
    off: 0
  , bold: 1
  , italic: 3
  , underline: 4
  , blink: 5
  , inverse: 7
  , hidden: 8
  , black: 30
  , red: 31
  , green: 32
  , yellow: 33
  , blue: 34
  , magenta: 35
  , cyan: 36
  , white: 37
  , black_bg: 40
  , red_bg: 41
  , green_bg: 42
  , yellow_bg: 43
  , blue_bg: 44
  , magenta_bg: 45
  , cyan_bg: 46
  , white_bg: 47
};

tagColor = {
	info : 'cyan_bg',
	debug : 'green_bg',
	error : 'red_bg',
	warning : 'yellow_bg',
};

function styleTag (name) {
	return "\x1B[" + ANSI_CODES[name] + "m";
}

function colorTag (tag) {
	return styleTag(tagColor[tag]) + '['+tag+']' + styleTag('off');
}

function myLog (tag, msg) {
    if(global.process.platform == 'linux'){
	//if(cc.sys.os == 'Linux') {
		console.log(colorTag(tag) + msg);
	}else {
		console.log('['+tag+']' + msg);
	}
}

function formatArgs() {
    var config = {depth : 11};
    if( cc.sys.os == 'Linux') {
        config.colors = true;
    }
	var str = "";
    for (var i = 0; i < arguments.length; i++) {
        str += util.inspect(arguments[i], config);
        if (i <= arguments.length - 1) {
            if (arguments[i+1] && typeof arguments[i+1] == 'object') {
                str += '\n';
            } else {
                str += '\t';
            }
        }
    }
	return str;
}
function getErrorLineNum(){
    try { 
        throw Error('');
    } catch(err) {
        var stackArr =  err.stack.split("\n");
        var idx = 2;
        if (stackArr.length <= idx) {
            idx = stackArr.length -2;
        }
		return stackArr[idx];
    }
}

function info() {
    var msg = formatArgs.apply(null, arguments);
//    console.log(getErrorLineNum());
    myLog('info', msg);
}


function error() {
    var msg = formatArgs.apply(null, arguments);

    myLog('error', getErrorLineNum()+':'+msg);
    if( DebugRecorderDungeon != null && DebugRecorderDungeon.inited ) {
        DebugRecorderDungeon.addDebugMsg("[error]"+msg);}
}

function warn() {
    var msg = formatArgs.apply(null, arguments);
    myLog('warning',  formatArgs(getErrorLineNum())+':'+msg);
}

function debug() {
    if (libLoader.gameConfig.debug) {
        var msg = formatArgs.apply(null, arguments);
        myLog('debug', msg);
        if( DebugRecorderDungeon != null &&  DebugRecorderDungeon.inited ) {
            DebugRecorderDungeon.addDebugMsg("[debug]"+msg);}
    }
}



