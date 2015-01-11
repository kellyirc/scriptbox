module.exports = (grunt) ->
	
	require('load-grunt-tasks')(grunt)

	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'

		#### Compiling (CoffeeScript)
		coffee:
			server:
				files: [{
					expand: yes
					cwd: 'src/'
					src: '**/*.coffee'
					dest: 'lib/'
					ext: '.js'
				}]

		less:
			client:
				files:
					'public/index.css': ['./public/styles/index.less']

		browserify:
			client:
				files:
					'public/index.js': ['./src/client/index.coffee']

				options:
					transform: ['coffeeify']

					browserifyOptions:
						extensions: ['.coffee', '.js', '.json']

		#### Linting
		coffeelint:
			options:
				no_tabs: level: 'ignore' # this is tab land, boy
				indentation: value: 1 # single tabs

			main:
				files: src: [
					'Gruntfile.coffee'
					'src/**/*.coffee'
					'test/**/*.coffee'
				]

		#### Testing
		mochaTest:
			options:
				reporter: 'spec'
				require: ['coffee-script/register']

			server:
				src: ['test/server/**/*.test.coffee']

		#### Misc (automated testing using watch)
		concurrent:
			options:
				logConcurrentOutput: true

			dev:
				tasks: [
					'watch:main', 'execute:main_server'
				]

		execute:
			main_server:
				src: ['<%= pkg.main %>']

		watch:
			main:
				files: ['src/**/*', 'test/**/*', 'public/styles/**/*']
				tasks: ['default']

				options:
					livereload: yes

	grunt.registerTask 'default', ['lint', 'test', 'build']
	grunt.registerTask 'server', ['lint', 'test-server', 'build-server']
	grunt.registerTask 'client', ['lint', 'test-client', 'build-client']

	grunt.registerTask 'lint', ['coffeelint:main']

	grunt.registerTask 'test', ['test-server', 'test-client']
	grunt.registerTask 'test-server', ['mochaTest:server']
	grunt.registerTask 'test-client', []

	grunt.registerTask 'build', ['build-server', 'build-client']
	grunt.registerTask 'build-server', ['coffee:server']
	grunt.registerTask 'build-client', ['browserify:client', 'less:client']

	grunt.registerTask 'dev', ['concurrent:dev']