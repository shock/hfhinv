if __FILE__ == $0
  puts "Run with: watchr #{__FILE__}. \n\nRequired gems: watchr rev"
  exit 1
end

require 'systemu'

$run_success = 0
$run_message = "Starting Watchr"

# --------------------------------------------------
# Convenience Methods
# --------------------------------------------------

def growl_message(title, message, opts={})
  opts[:priority] ||= -2
  opts[:success] = true  if opts[:success].nil?
  opts[:image] ||= opts[:success] ? "~/.watchr/images/success.jpg" : "~/.watchr/images/failure.gif"
  sticky_option = opts[:sticky] ? "-s" : ""
  growlnotify = `which growlnotify`.chomp
  options = ["-w -n Watchr -m '#{message}' -p #{opts[:priority]} #{sticky_option}"]
  options << "--image '#{File.expand_path(opts[:image])}'" if opts[:image] != ""
  system %(#{growlnotify} #{options.join(" ")} #{title} &)
end

def play_sound(sound)
  if File.exist?("#{ENV['HOME']}/slack-sounds/#{sound}.mp3")
    cmd = "afplay #{ENV['HOME']}/slack-sounds/#{sound}.mp3"
  elsif File.exist?("/System/Library/Sounds/#{sound}.aiff")
    cmd = "afplay /System/Library/Sounds/#{sound}.aiff"
  end
  system %(#{cmd} &)
end

def growl(title = "Watchr Test Results")
  opts = {}
  message = "#{$run_message}\n\n"
  opts[:success] = $run_success
  message += $run_success ? "SUCCESS! " * 3 : "FAILED! " * 4
  opts[:priority] = $run_success ? -2 : 2
  opts[:sticky] = !$run_success || title =~ /WHOLE SUITE RESULTS/
  growl_message(title, message, opts)
end

def exec(cmd)
  puts(cmd)
  status, stdout, stderr = systemu cmd
  puts stdout
  puts stderr
  puts status
  status == 0 ? true : false
end

def run(cmd)
  puts(cmd)
  status, stdout, stderr = systemu cmd
  puts stdout
  puts stderr
  puts status
  $run_success = stdout.scan(/0 failures/).any? ? true : false
  $run_success = status == 0 ? true : false
  stdout
end

def run_all_specs
  cmd = "rspec spec spec/features"
  growl_message("Watchr", "Running All Tests", image: (""))
  puts cmd
  system(cmd)
  $run_success = $?.success?
  growl("WHOLE SUITE RESULTS")
  $run_success ? play_sound("whoomp") : play_sound("trombone")
end

def spec(specs)
  $run_message = "rspec #{specs}"

  files = specs.split(' ')
  specs = []
  files.each do |file|
    if File.exists?(file)
      specs << file
    else
      growl_message("Missing Spec", file, image: ("~/.watchr/images/failure.gif"))
      puts("Spec: #{file} does not exist.")
    end
  end
  if specs.any?
    growl_message("Watchr", "Running #{$run_message}", image: (""))
    run("spring rspec #{specs.join(" ")}")
    growl
    $run_success ? play_sound("Hero") : play_sound("Frog")
  end
end

def run_specs *spec
  specs = spec.join(' ')
  spec(specs)
end

def run_suite
  system "clear"
  puts " --- Running all tests ---\n\n"
  run_all_specs
end

def restart_spring
  growl_message("Watchr", "Restarting Spring", success: (exec "spring stop"))
end


# Ctrl-\
Signal.trap 'QUIT' do
  abort("Stopped with QUIT")
end

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    # abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    run_suite
    Thread.new do
      Kernel.sleep 3
      @interrupted = false
    end
  end
end

# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------
watch( '^spec/spec_helper\.rb'                    ) { restart_spring }
watch( '^spec/support/.*\.rb'                    ) { restart_spring }
# watch( '^spec/.*_spec\.rb'                        ) { |m| run_specs(m[0]) }
watch( '^app/(.*)\.rb'                            ) { |m| run_specs("spec/%s_spec.rb" % m[1]) }
watch( '^lib/(.*)\.rb'                            ) { |m| run_specs("spec/lib/%s_spec.rb" % m[1]) }
watch( '^app/views/(.*)\.erb'                    ) { |m| run_specs("spec/views/%s.erb_spec.rb" % m[1]) }
watch( '^spec/factories/.*$'                    ) { |m| restart_spring }
watch( '^config/.*$'                    ) { |m| restart_spring }
watch( '^Gemfile.*$'                    ) { |m| restart_spring }

puts "Watching..."
growl("Watcher Running")
