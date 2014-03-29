guard 'sass', :output => 'assets/styles', :all_on_start => true, :style => :compressed do
  watch %r{^assets/styles/(.+\.s[ac]ss)$}
end

guard 'coffeescript', :output => 'assets/scripts', :all_on_start => true do
  watch(%r{^assets/scripts/(.+\.coffee)})
end

guard 'livereload' do
  watch(%r{.+\.(css|js|html)})
end
