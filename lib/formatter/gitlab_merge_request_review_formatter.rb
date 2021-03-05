module Pronto
  module Formatter
    # Pronto::Formatter::GitlabMergeRequestReviewFormatter comes from the
    # Pronto gem itself.
    #
    # The methods below are feature overrides to:
    #   1. prevent the {#line_number} class from failing if none of the patches
    #      contain the `message.line.line.new_lineno` value found. Which can happen
    #      in the context of this pronto-bundler audit gem since we aren't
    #      necessarily altering the Gemfile.lock file within a PR at the time of
    #      finding an issue in the Gemfile.lock file.
    class GitlabMergeRequestReviewFormatter
      def line_number(message, _)
        puts message
        if defined?(message.line)
          if defined?(message.line.line)
            message.line.line.new_lineno
          elsif defined?(message.line.commit_line)
            message.line.commit_line.new_lineno
          else
            message.line.new_lineno
          end
        else
          $stderr.puts "Undefined method line for message: #{message}"
        end
      end
    end
  end
end
