gulp = require 'gulp'
connect = require 'gulp-connect'
debug = require 'gulp-debug'
jade = require 'gulp-jade'
concat = require 'gulp-concat'
stylus = require 'gulp-stylus'
less = require 'gulp-less'
rename = require 'gulp-rename'
minify = require 'gulp-minify-css'
clean = require 'gulp-clean'
rjs = require 'gulp-requirejs'
uglify = require 'gulp-uglify'
coffee = require 'gulp-coffee'

gulp.task 'connect', ->
	connect.server
		port: 1337
		livereload: on
		root: '_public'

gulp.task 'build-html', ->	
	gulp.src [ 'src/jade/*.jade', '!src/jade/layout.jade' ]		 	
		.pipe do jade									
		.pipe gulp.dest '_public'
		.pipe do connect.reload			

gulp.task 'stylus', ->
	gulp.src 'src/stylus/*.styl'
		.pipe concat 'styles'
		.pipe stylus set: ['compress']
		.pipe gulp.dest 'src/css'

gulp.task 'bootstrap-less', ->
	gulp.src 'bower_components/bootstrap/less/bootstrap.less'
		.pipe do less
		.pipe gulp.dest 'src/css'

gulp.task 'build-css', ['stylus', 'bootstrap-less'], ->	
	gulp.src 'src/css/*.css' 
		.pipe concat 'styles.css'
		.pipe rename 'styles.min.css'		
		.pipe do minify, keepBreaks: on		
		.pipe gulp.dest '_public/css'
		.pipe do connect.reload
		.on 'end', ->
			gulp.src 'src/css/', read: no
			.pipe do clean

gulp.task 'coffee', ->
	gulp.src 'src/coffee/*.coffee'
		.pipe do coffee
		.pipe gulp.dest 'src/js'

gulp.task 'javascript', ->
	gulp.src 'src/scripts/*.js'		
		.pipe gulp.dest 'src/js'	

gulp.task 'build-js', ['coffee', 'javascript'], ->	
	rjs 
		baseUrl: 'src/js'		
		name:  '../../bower_components/almond/almond'
		include: ['main'] 
		insertRequire: ['main']
		out: 'script.js'
		wrap: true
	#.pipe do uglify
	.pipe gulp.dest '_public/js'	
	.pipe do connect.reload

	gulp.src 'src/js', read: no
      .pipe do clean      


gulp.task 'watch', ->	
	gulp.watch 'src/jade/*.jade', ['build-html']
	gulp.watch 'src/stylus/*.styl', ['build-css']	
	gulp.watch 'src/scripts/*.js', ['build-js']
	gulp.watch 'src/coffee/*.coffee', ['build-js']			

gulp.task 'default', ['connect', 'watch', 'build-html', 'build-css', 'build-js']	