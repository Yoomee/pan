def ym_gem(gem_name, checkout = nil)
  return true unless gem_name
  gem_name = "ym_#{gem_name}" if !(gem_name =~ /^ym_\w+/)
  gem_path = File.expand_path("../../vendor/gems/#{gem_name}", __FILE__)
  if !File.directory?(gem_path)
    system("git clone git://git.yoomee.com:4321/gems/#{gem_name}.git #{gem_path}")
    system("cd #{gem_path};git checkout #{checkout}") if checkout
  end
  gem gem_name, :path => File.expand_path("../../vendor/gems", __FILE__)
end

def load_ym_gems!
  calling_file = caller.detect {|calling_file| calling_file =~ /Gemfile/}.match(/[\/\w]+Gemfile/).to_s
  ym_gemfile = "#{calling_file}.ym"
  eval(IO.read(ym_gemfile), binding, ym_gemfile)
end
