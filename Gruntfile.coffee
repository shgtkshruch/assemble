module.exports = (grunt) ->
  'use strict'

  grunt.initConfig

    pkg: grunt.file.readJSON("package.json")

    config:
      src: 'src'
      srcCommon: '<%= config.src %>/assets'
      dist: 'www'
      distCommon: '<%= config.dist %>/assets'
      template: 'templates'
      tmp: 'tmp'

    assemble:
      options:
        assets: '<%= config.distCommon %>'
        partials: '<%= config.template %>/includes/**/*.{hbs,md}'
        layoutdir: '<%= config.template %>/layouts/'
        layout: 'default.hbs'
        data: '<%= config.template %>/data/**/*.{json,yml}'

      dev:
        options:
          dev: true
          production: false
        files: [
          expand: true
          cwd: '<%= config.template %>/pages'
          src: '**/*.hbs'
          dest: '<%= config.dist %>'
        ]

      production:
        options:
          dev: false
          production: true
        files: [
          expand: true
          cwd: '<%= config.template %>/pages'
          src: '**/*.hbs'
          dest: '<%= config.dist %>/'
        ]

    autoprefixer:
      options:
        browsers: ['last 2 version', 'ie 8', 'ie 7']
      dist:
        src: '<%= sass.dist.dest %>'
        dest: 'htdocs/css/screen.style.css'

    browser_sync:
      files:
        src: ['<%= config.dist %>/index.html', '<%= config.distCommon %>/css/screen.css']
      options:
        server:
          baseDir: '<%= config.dist %>'
        watchTask: true
        ghostMode:
          scroll: true
          links: true
          forms: true

    clean:
      ['<%= config.tmp %>']

    coffee:
      options:
        sourceMap: true
        bare: true
      compile:
        src: '<%= config.srcCommon %>/coffee/script.coffee'
        dest: '<%= config.distCommon %>/js/script.js'

    connect:
      server:
        options:
          port: 8080
          base: '<%= config.dist %>'
          open: 'http://localhost:8080/'

    csscss:
      options:
        compass: true
        require: 'config.rb'
      dist:
        src: '<%= autoprefixer.dist.dest %>'

    cssmin:
      dist:
        src: '<%= sass.dist.dest %>'
        dest: '<%= config.distCommon %>/css/screen.min.css'

    csscomb:
      dist:
        options:
          sortOrder: 'csscomb.json'
        src: '<%= autoprefixer.dist.dest %>'
        dest: '<%= config.distCommon %>/css/screen.css'

    csslint:
      dist:
        options:
          csslintrc: '.csslintrc'
        src: '<%= autoprefixer.dist.dest %>'
        dest: '<%= config.distCommon %>/css/screen.css'

    imagemin:
      dist:
        options:
          optimizationLevel: 7
        files: [
          expand: true
          cwd: '<%= config.srcCommon %>/img/'
          src: ['**/*.{png,jpg,gif}']
          dest: '<%= config.distCommon %>/img/'
        ]

    prettify:
      options:
        condense: true
        indent: 2
        indent_char: ' '
        brace_style: 'expand'
      files:
        expand: true
        cwd: '<%= config.dist %>'
        src: ['**/*.html']
        dest: '<%= config.dist %>'

    sass:
      dist:
        options:
          style: 'expanded'
          compass: true
        src: '<%= config.srcCommon %>/sass/screen.sass'
        dest: '<%= config.distCommon %>/css/screen.css'

    slim:
      dist:
        options:
          pretty: true
        files: [
          expand: true
          cwd: '<%= config.src %>'
          src: ['{,*/}*.slim']
          dest: '<%= config.dist %>'
          ext: '.html'
        ]

    watch:
      options:
        spawn: false
        atBegin: false
        livereload: true

      assemble:
        files: '<%= config.template %>/pages/**/*.hbs'
        tasks: 'assemble:dev'

      coffee:
        files: '<%= coffee.compile.src %>'
        tasks: 'coffee'

      sass:
        files: '<%= config.srcCommon %>/sass/**/*.sass'
        tasks: 'sass'

      # slim:
      #   files: '<%= config.src %>/**/*.slim'
      #   tasks: 'slim'

  grunt.registerTask 'default', [], ->
    grunt.task.run 'connect', 'assemble'

  grunt.registerTask 'connect', [], ->
    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.task.run 'connect'

  grunt.registerTask 'watch', [], ->
    # grunt.loadNpmTasks 'grunt-slim'
    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.task.run 'watch'

  grunt.registerTask 'sync', [], ->
    grunt.loadNpmTasks 'grunt-browser-sync'
    grunt.task.run 'browser_sync', 'assemble'

  grunt.registerTask 'style', [], ->
    grunt.loadNpmTasks 'grunt-csscss'
    grunt.loadNpmTasks 'grunt-csscomb'
    grunt.loadNpmTasks 'grunt-autoprefixer'
    grunt.loadNpmTasks 'grunt-contrib-csslint'
    grunt.task.run 'autoprefixer', 'csscomb', 'csscss', 'csslint'

  grunt.registerTask 'min', [], ->
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-contrib-imagemin'
    grunt.task.run 'cssmin', 'imagemin'

  grunt.registerTask 'assemble', [], ->
    grunt.loadNpmTasks 'assemble'
    grunt.task.run 'watch'

  grunt.registerTask 'pr', [], ->
    grunt.loadNpmTasks 'grunt-prettify'
    grunt.task.run 'prettify'
