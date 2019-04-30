require "pronto"
require "bundler/audit/database"
require "bundler/audit/scanner"
require "pronto/bundler_audit/version"
require "pronto/bundler_audit/patch_handler"

module Pronto
  # Pronto::BundlerAudit is a Pronto::Runner that:
  # 1. Finds the most relevant patch (the last patch that contains a change to
  #    Gemfile.lock)
  # 2. Updates the Ruby Advisory Database
  # 3. Runs bundle-audit to scan the Gemfile.lock
  # 4. Returns an Array of Pronto::Message objects if any advisories are found
  class BundlerAudit < Runner
    GEMFILE_LOCK_FILENAME = "Gemfile.lock".freeze

    def run
      patch = find_relevant_patch

      if patch
        patch_handler = PatchHandler.new(patch, runner: self)
        patch_handler.call
      end
    end

    private

    def find_relevant_patch
      @patches.reverse.detect { |patch|
        patch.additions > 0 && relevant_patch_path?(patch)
      }
    end

    def relevant_patch_path?(patch)
      patch_path = patch.new_file_full_path.to_s
      patch_path.end_with?(GEMFILE_LOCK_FILENAME)
    end
  end
end
