'use strict';

var autoprefixer  = require('gulp-autoprefixer');
var coffee        = require('gulp-coffee');
var env           = require('gulp-util').env;
var gulp          = require('gulp');
var livereload    = require('gulp-livereload');
var notify        = require('gulp-notify');
var sass          = require('gulp-ruby-sass');
var sequence      = require('run-sequence');
var uglify        = require('gulp-uglify');


//
// Styles
//

gulp.task('styles', function() {
  return gulp.src('./assets/styles/**/*.{sass,scss}')
    .pipe(sass({
      "sourcemap=none": true,
      noCache: true,
      style: 'compressed',
      loadPath: [
        './assets/styles/includes'
      ],
      quiet: true
    }))
    .on('error', function() {
      notify.onError({
        message: '<%= error.message %>',
        title: 'SASS Error'
      });
    })
    .on('error', function(error) {
      this.emit('end');
    })
    .pipe(autoprefixer())
    .pipe(gulp.dest('./assets/styles'))
    .pipe(livereload());
});


//
// Scripts
//

gulp.task('scripts', function() {
  return gulp.src('./assets/scripts/*.coffee')
    .pipe(coffee({bare: true}))
    .on('error', notify.onError({
      message: '<%= error %>',
      title: 'JavaScript Error'
    }))
    .on('error', function(error) {
      this.emit('end');
    })
    .pipe(uglify())
    .pipe(gulp.dest('./assets/scripts/'))
    .pipe(livereload());
});


//
// Livereload
//

gulp.task('watch', function() {
  livereload.listen();

  gulp.watch('./assets/scripts/**/*.{js,coffee}', ['scripts']);
  gulp.watch('./assets/styles/**/*.{scss,sass}', ['styles']);
  gulp.watch('./**/*.html', function(e) {
    livereload.changed(e.path);
  });
});


//
// Tasks
//

gulp.task('build', function (callback) {
  sequence('scripts', 'styles', callback);
});

gulp.task('default', function (callback) {
  sequence('build', 'watch', callback);
});
