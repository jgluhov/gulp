gulp = require 'gulp'
connect = require 'gulp-connect'
jade = require 'gulp-jade'
clean = require 'gulp-clean'
stylus = require 'gulp-stylus'
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'
less = require 'gulp-less'
minify = require 'gulp-minify-css'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
rjs = require 'gulp-requirejs'
notify = require 'gulp-notify'
jshint = require 'gulp-jshint'

gulp.task 'connect', ->
	connect.server
		port: 1337
		livereload: on
		root: './public'

gulp.task 'jade', ->
	gulp.src 'src/jade/*.jade'
		.pipe do jade
		.pipe gulp.dest './public'				

gulp.task 'build-jade', ['jade'], ->
	gulp.src './public/layout.html', read: no
		.pipe do clean
		.pipe do connect.reload			

#----------------------------------------------------------------------------------------
gulp.task 'jquery', ->
	gulp.src 'bower_components/jquery/dist/jquery.min.js'
		.pipe rename 'jquery.js'
		.pipe gulp.dest 'src/js'

gulp.task 'flot', ->
	gulp.src 'bower_components/flot/jquery.flot.js'
		.pipe rename 'flot.js'
		.pipe gulp.dest 'src/js'		

gulp.task 'scripts', ->
	gulp.src 'src/scripts/*.js'			
		.pipe gulp.dest 'src/js'				

gulp.task 'build-js', ['jquery', 'flot', 'scripts'], ->
	rjs 
		baseUrl: 'src/js'		
		name:  '../../bower_components/almond/almond'
		include: ['main'] 
		insertRequire: ['main']
		out: 'scripts.js'
		wrap: on	
	#.pipe do jshint
	#.pipe jshint.reporter 'jshint-stylish'
	.pipe gulp.dest 'public/js'	
	.pipe do connect.reload	
	gulp.src 'src/js', read: no
        .pipe do clean			

#----------------------------------------------------------------------------------------
gulp.task 'stylus', ->
	gulp.src 'src/stylus/*.styl'
		.pipe concat 'stylus'
		.pipe stylus set: ['compress']
		.pipe gulp.dest 'src/css'				

gulp.task 'bootstrap', ->
	gulp.src 'bower_components/bootstrap/less/bootstrap.less'
		.pipe do less
		.pipe gulp.dest 'src/css'		

gulp.task 'build-css', ['bootstrap', 'stylus'], ->	
	gulp.src [ 'src/css/bootstrap.css', 'src/css/stylus.css' ]
		.pipe concat 'styles.css'
		.pipe rename 'styles.min.css'		
		.pipe do minify, keepBreaks: on		
		.pipe gulp.dest 'public/css'
	gulp.src 'src/css', read: no
        .pipe do clean			
		.pipe do connect.reload		

gulp.task 'watch', ->	
	gulp.watch 'src/jade/*.jade', ['build-jade'],
	gulp.watch 'src/stylus/*.styl', ['build-css'],
	gulp.watch 'bower_components/bootstrap/less/**/*.less', ['build-css'],
	gulp.watch 'src/scripts/*.js', ['build-js']

gulp.task 'default', [ 'connect', 'watch', 'build-jade', 'build-css', 'build-js' ]
