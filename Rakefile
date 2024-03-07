# frozen_string_literal: true

require "bundler/gem_tasks"
task default: %i[]

require 'octokit' 
require 'versionomy'


def determine_new_version(version)
  # Load current version
  load 'lib/stretchy/version.rb'
  current_version = Versionomy.parse(Stretchy::VERSION)

  # Determine new version
  case version.to_sym
  when :major
    current_version.bump(:major)
  when :minor
    current_version.bump(:minor)
  when :patch
    current_version.bump(:tiny)
  else
    Versionomy.parse(version)
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
  system("git push origin #{branch_name}")
end

def create_pull_request(new_version, base_branch, branch_name)
  # Create a pull request
  client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
  client.create_pull_request('theablefew/stretchy', base_branch, branch_name, "Release v#{new_version}")
end

namespace :publish do
  desc "Create a release"
  task :release, [:version, :base_branch] do |t, args|
    args.with_defaults(version: :patch, base_branch: 'main')
    version = args[:version]
    base_branch = args[:base_branch]
  
    new_version = determine_new_version(version)
    branch_name = create_release_branch(new_version, base_branch)
    update_version_file(new_version)
    commit_and_push_changes(new_version, branch_name)
    create_pull_request(new_version, base_branch, branch_name)
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
