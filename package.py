from subprocess import check_call as call
import tempfile

def package(builder):

    name = builder.name
    jruby_version = builder.metadata["packaging"]["jruby_version"]
    install_path = "/usr/lib/{0}".format(builder.name)

    tmpdir = tempfile.mkdtemp()

    def install_jruby():

        url = "http://jruby.org.s3.amazonaws.com/downloads/{0}/jruby-bin-{0}.tar.gz".format(jruby_version)
        package_path = "{0}/jruby-bin-{1}.tar.gz".format(tmpdir, jruby_version)

        print "Downloading JRuby {0}".format(jruby_version)
        call(["/usr/bin/curl", "--progress-bar", "-L", url, "-o", package_path])

        print "Extracting {0}".format(package_path)
        call(["tar", "zxf", package_path, "-C", tmpdir])

    def create_jar():
        gem_bin = "{0}/jruby-{1}/bin/gem".format(tmpdir, jruby_version)
        jruby_bin = "{0}/jruby-{1}/bin/jruby".format(tmpdir, jruby_version)
        # gem_home = "{0}/jruby-{1}/lib/ruby/gems/shared".format(tmpdir, jruby_version)

        # print "Installing bundler: {0}".format(gem_bin)
        call([jruby_bin, gem_bin, "install", "bundler", "--install-dir", ".gem"])
        call([jruby_bin, "-e", "ENV['GEM_HOME']=File.join(Dir.pwd,'.gem');ENV['GEM_PATH']=File.join(Dir.pwd,'.gem');ENV['BUNDLE_GEMFILE']=File.join(Dir.pwd,'Gemfile');require'rubygems';require'bundler';require'bundler/cli';cli=Bundler::CLI.start"])
        call([jruby_bin, "-e", "ENV['GEM_HOME']=File.join(Dir.pwd,'.gem');ENV['GEM_PATH']=File.join(Dir.pwd,'.gem');ENV['BUNDLE_GEMFILE']=File.join(Dir.pwd,'Gemfile');require'rubygems';require'warbler';Dir.mkdir('target');Warbler::Application.new.run;"])


    def setup_dependencies():
        builder.spec.set_build_arch('x86_64')

        builder.spec.add_build_requires([
            'cosmos-ca-tools'
        ])

    def user():
        builder.spec.add_pre_steps([
            ["groupadd -r {0}".format(name)],
            ["useradd -r -g {0} -G {0} -d / -s /sbin/nologin -c \"{0} ruby service\" {0}".format(name)]
        ])

    def set_perms():
        builder.spec.add_pre_steps([
            ["chown -R {0}:{0}".format(name)],
            ["chmod 744 {0}".format(install_path)]
        ])

    def setup_bundler():
        builder.spec.add_post_steps([
            ['/opt/jruby/bin/gem install bundler --no-ri --no-rdoc']
        ])

    def install_gems():
        builder.spec.add_post_steps([[
            "GEM_HOME=/opt/jruby/lib/ruby/gems/shared",
            "BUNDLE_GEMFILE={0}/Gemfile".format(install_path),
            "/opt/jruby/bin/jruby -e \"require 'bundler/cli'; Bundler::CLI.start\""]
        ])

    install_jruby()
    create_jar()

    setup_dependencies()
    user()
    setup_bundler()
    install_gems()
