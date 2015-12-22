module.exports = function(grunt) {
    require('load-grunt-tasks')(grunt);
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        
        // Compiling (ES6)
        babel: {
            dist: {
                files: [{
                    expand: true,
                    cwd: 'src/',
                    src: ['**/*.js'],
                    dest: 'lib/',
                    ext: '.js',
                    extDot: 'first'
                }]
            }
        },
        
        less: {
            client: {
                files: {
                    'public/index.css': ['./public/styles/index.less']
                }
            }
        },
        
        browserify: {
            client: {
                files: {
                    'public/index.js': ['./src/client/index.js']
                },
                options: {
                    transform: ['babelify'],
                    browserifyOptions: {
                        extensions: ['.js', '.json'],
                        noParse: [require.resolve('phaser/dist/phaser-no-libs')]
                    }
                }
            }
        },
        
        // Linting
        
        eslint: {
            main: {
                files: {
                    src: [
                        'Gruntfile.js',
                        'src/**/*.js',
                        'test/**/*.js'
                    ]
                }
            }
        },
        
        // Testing
        mochaTest: {
            options: {
                reporter: 'spec',
                require: ['babel-core/register']
            },
            
            server: {
                src: ['test/server/**/*.test.js']
            }
        },
        
        // Misc (automated testing using Watch)
        concurrent: {
            options: {
                logConcurrentOutput: true
            },
            dev: {
                tasks: [
                    'watch:main', 'execute:main_server'
                ]
            }
        },
        
        execute: {
            main_server: {
                src: ['<%= pkg.main %>']
            }
        },
        
        watch: {
            main: {
                files: ['src/**/*', 'test/**/*', 'public/styles/**/*'],
                tasks: ['default'],
                
                options: {
                    livereload: true
                }
            }
        }
    });
    grunt.registerTask('default', ['lint', 'test', 'build']);
    grunt.registerTask('server', ['lint', 'test-server', 'build-server']);
    grunt.registerTask('client', ['lint', 'test-client', 'build-client']);

    grunt.registerTask('lint', ['eslint:main']);

    grunt.registerTask('test', ['test-server', 'test-client']);
    grunt.registerTask('test-server', []);
    grunt.registerTask('test-client', []);

    grunt.registerTask('build', ['build-server', 'build-client']);
    grunt.registerTask('build-server', ['babel']);
    grunt.registerTask('build-client', ['browserify:client', 'less:client']);

    grunt.registerTask('dev', ['concurrent:dev']);
};