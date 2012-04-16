require "#{release_path}/lib/ym_gem_loader"

@ym_gems = {}

def ym_gem(gem_name, checkout = nil)
  gem_name = "ym_#{gem_name}" if !(gem_name =~ /^ym_\w+/)
  if @ym_gems[gem_name] && checkout && @ym_gems[gem_name] != checkout
    raise ArgumentError, "Ambiguous checkouts for #{gem_name}: #{@ym_gems[gem_name]}, #{checkout}", caller
  else
    @ym_gems[gem_name] ||= checkout
  end
end

ym_gemfiles = Dir["#{release_path}/vendor/gems/*/Gemfile.ym"] + ["#{release_path}/Gemfile.ym"]

ym_gemfiles.each do |ym_gemfile|
  eval(IO.read(ym_gemfile), binding, ym_gemfile)
end

# @ym_gems.each do |gem_name, checkout|
#   gem_path = "#{release_path}/vendor/gems/#{gem_name}"
#   run "git clone -q git://git.yoomee.com:4321/gems/#{gem_name}.git #{gem_path}"
#   run "cd #{gem_path};git checkout #{checkout}" if checkout
# end
  

# gem_regex = /gem ['"]([^'"]*)['"],\s*:path\s*=>\s*['"]vendor\/gems['"]/
# 
# File.read(gemfile_path).scan(gem_regex).each do |ym_gem|
#  run "git clone git://git.yoomee.com:4321/gems/#{ym_gem[0]}.git #{release_path}/vendor/gems/#{ym_gem[0]}"
# end

