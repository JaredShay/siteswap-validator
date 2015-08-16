# Sitewap validator for two handed sitewap notation.
#
# Throws are denoted by the characters a-z and numbers 0-9.
#
# Multiplexes are denoted by throws wrapped in square brackets
# eg.
#   [33]
#
# Synchronous throws are denoted by two comma seperated throws (multiplex or
# single) wrapped in curved brackets
# eg.
#   (4,4)
#
# The uppercase 'X' character is used to distinguish the special meaning from
# the throw.
#
# White space is ignored.
#
# A siteswap is considered valid if the supplied sequence can be thrown
# continually. A sitewap is considered partially valid if it can exist in a
# sequence that is valid.
class Siteswap
  SINGLE_REGEX       = /([a-z]|\d)X?/
  MULTIPLEX_REGEX    = /\[#{SINGLE_REGEX}+\]/
  THROW_REGEX        = /(#{MULTIPLEX_REGEX}|#{SINGLE_REGEX})/
  SYNCHRONOUS_REGEX  = /\(#{THROW_REGEX},#{THROW_REGEX}\)/

  # Characters representing the start of a token sequence.
  TOKEN_INITIALIZERS  = /(#{SINGLE_REGEX}|\[|\()/

  TOKEN_REGEXES = (Hash.new { SINGLE_REGEX }).merge({
    "[" => MULTIPLEX_REGEX, "(" => SYNCHRONOUS_REGEX
  })

  def self.validate(siteswap)
    new(siteswap).validate
  end

  def initialize(siteswap)
    @action_tokens = parse(siteswap)
  end

  def validate
    @action_tokens.length == @action_tokens
      .each_with_index
      .map { |s, i| s.to_i + i + @action_tokens.length }
      .uniq
      .length
  end

  private

  def parse(siteswap)
    [].tap { |actions|
      while siteswap.length > 0
        if siteswap[0].match(TOKEN_INITIALIZERS)
          actions << siteswap.slice!(token_length(siteswap))
        else
          raise SyntaxError
        end
      end
    }
  end

  def token_length(siteswap)
    token = siteswap.match(TOKEN_REGEXES[siteswap[0]])

    if token
      (0..(token[0].length - 1))
    else
      raise SyntaxError
    end
  end

  class SyntaxError < StandardError
  end
end
