var gulp = require('gulp');

var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');
var mocha = require('gulp-mocha');
var coffeeLint = require('gulp-coffeelint');
var cache = require('gulp-cached');
var cover = require('gulp-coverage');
var changed = require('gulp-changed');
var sass = require('gulp-sass');
//var tar = require('gulp-tar');
//var gzip = require('gulp-gzip');
//var s3 = require('gulp-gzip');
//var gif = require('gulp-if');
//var footer = require('gulp-footer');

var paths = {
  coffees: ['src/**/*.coffee'],
  tests: { src:['test/*.coffee'], des:'build/test/'},
  js:['src/**/*.js']
};

gulp.task('compileTest', function () {
    return gulp.src(paths.tests.src)
//		.pipe(changed(paths.tests.des))
        //.pipe(cache('compiletest'))
		//.pipe(sass({
		//style: 'compressed',
		//errLogToConsole: false,
		//onError:function(error){
		//	notify({
		//	title:"SASS ERROR",
		//	message: "line " + error.line + error.file.replace(/^.*[\\\/]/,'') +"\n" + error.message }).write(error); }
		//}))
        .pipe(coffee())
        .pipe(gulp.dest(paths.tests.des))
        .on('error', console.log);
});


gulp.task('mocha', function () {
  gulp.src([paths.tests.des+'/*.js'], { read: false })
    .pipe(mocha({
      reporter: 'nyan',
    }))
    .on('error', console.log);
});

gulp.task('coverage', function () {
  gulp.src(paths.tests, { read: false })
    .pipe(cover.instrument({
      pattern: ['js/*']
    }))
    .pipe(mocha({
    }))
    .pipe(cover.report({
      outFile: 'coverage.html'
    }))
    .on('error', function () {});
});

gulp.task('js', function () {
  return gulp.src(paths.js)
    //.pipe(cache('js'))
    //.pipe(uglify())
    .pipe(gulp.dest('build/src'))
    .on('error', console.log);
});

gulp.task('compile', function () {
  return gulp.src(paths.coffees)
	.pipe(changed('build/src'))
	//.pipe(sass({
	//	style: 'compressed',
	//	errLogToConsole: false,
	//	onError:function(error){
	//		notify({
	//			title:"SASS ERROR",
	//			message: "line " + error.line + error.file.replace(/^.*[\\\/]/,'') +"\n"
	//			+ error.message
	//		}).write(error);
	//	}
	//}))
    .pipe(coffee())
    //.pipe(cache('compile'))
    //.pipe(uglify())
    .pipe(gulp.dest('build/src'))
    .on('error', console.log);
});

gulp.task('c',['compile','js']);
gulp.task('t',['c','compileTest','mocha']);
gulp.task('watch', function () {
  //gulp.watch(paths.coffees, ['lint', 'compile']);
  gulp.watch(paths.coffees, ['c']);
  gulp.watch(paths.tests.src, ['compileTest','mocha']);
});

gulp.task('lint', function () {
  return gulp.src(paths.coffees)
    //.pipe(cache('lint'))
    .pipe(coffeeLint(null, {max_line_length: {level: 'error', value: 180}}))
    .pipe(coffeeLint.reporter());
});
/*
var gulp = require('gulp');
var changed = require('gulp-changed');
var ngmin = require('gulp-ngmin'); // just as an example

var SRC = 'src/*.js';
var DEST = 'dist';

gulp.task('default', function () {
gulp.src(SRC)
.pipe(changed(DEST))
    // ngmin will only get the files that
    // changed since the last time it was run
    .pipe(ngmin())
    .pipe(gulp.dest(DEST));
    });
 */
// npm install gulp yargs gulp-if gulp-uglify
// var args   = require('yargs').argv;
// var gulp   = require('gulp');
// var gulpif = require('gulp-if');
// var uglify = require('gulp-uglify');
//
// var isProduction = args.type === 'production';
//
// gulp.task('scripts', function() {
//   return gulp.src('**/*.js')
//       .pipe(gulpif(isProduction, uglify())) // only minify if production
//           .pipe(gulp.dest('dist'));
//           });
//gulp scripts --type production

gulp.task('default', ['watch']);
