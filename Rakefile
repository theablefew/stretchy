# frozen_string_literal: true

require "bundler/gem_tasks"
task default: %i[]

require 'octokit' 
require 'versionomy'
require 'rainbow'

def determine_current_version
  # Load current version
  load 'lib/stretchy/version.rb'
  current_version = Versionomy.parse(Stretchy::VERSION)
end

def determine_new_version(version)
  # Load current version
  current_version = determine_current_version

  # Determine new version
  case version.to_sym
  when :major
    current_version.bump(:major)
  when :minor
    current_version.bump(:minor)
  when :patch
    current_version.bump(:tiny)
  else
    version =~ /\Av\d+\.\d+\.\d+\z/ ? Versionomy.parse(version) : current_version
  end
end

def create_release_branch(new_version, base_branch)
  system("git fetch origin #{base_branch}")
  branch_name = "release/v#{new_version}"
  system("git checkout -b #{branch_name} #{base_branch}")
  branch_name
end

def update_version_file(new_version)
  # Update lib/stretchy/version.rb
  File.open('lib/stretchy/version.rb', 'w') do |file|
    file.puts "module Stretchy\n  VERSION = '#{new_version}'\nend"
  end
end

def commit_and_push_changes(new_version, branch_name)
  system("git add lib/stretchy/version.rb")
  system("git commit -m 'Bump version to v#{new_version}'")
  system("git tag v#{new_version}")
  system("git push origin #{branch_name} --tags")
end

def create_pull_request(new_version, base_branch, branch_name)
  # Create a pull request
  client = Octokit::Client.new(access_token: ENV['GH_TOKEN'])
  client.create_pull_request('theablefew/stretchy', base_branch, branch_name, "Release v#{new_version}")
end

namespace :publish do
  desc "Create a release"
  task :release, [:version, :base_branch] do |t, args|
    args.with_defaults(version: :patch, base_branch: 'main')
    version = args[:version]
    base_branch = args[:base_branch]
  
    old_version = determine_current_version
    new_version = determine_new_version(version)
    puts Rainbow("Bumping version from #{old_version} to #{new_version}").green
    branch_name = create_release_branch(new_version, base_branch)
    begin
    update_version_file(new_version)
    commit_and_push_changes(new_version, branch_name)
    create_pull_request(new_version, base_branch, branch_name)
    rescue => e
      puts "Error: #{e.message}"
      puts "Rolling back changes"
      system("git tag -d v#{new_version}")
      system("git checkout #{base_branch}")
      system("git branch -D #{branch_name}")
    end
  end

  task :major do
    Rake::Task['publish:release'].invoke('major')
  end

  task :minor do
    Rake::Task['publish:release'].invoke('minor')
  end

  task :patch do
    Rake::Task['publish:release'].invoke('patch')
  end
end
