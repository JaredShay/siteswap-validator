require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!(
  [Minitest::Reporters::DefaultReporter.new(:color => true)]
)

require_relative '../lib/siteswap'

class ValidatorTest < MiniTest::Unit::TestCase
  def test_valid_vanilla_sitewaps
    assert_equal Siteswap.validate('3'), true
    assert_equal Siteswap.validate('441'), true
  end

  def test_invalid_vanilla_siteswaps
    assert_equal Siteswap.validate('32'), false
    assert_equal Siteswap.validate('442'), false
  end

  def test_invalid_characters
    assert_raises(Siteswap::SyntaxError) do
      Siteswap.validate('$&')
    end
  end

  def test_valid_characters_invalid_format
    assert_raises(Siteswap::SyntaxError) do
      Siteswap.validate('[](),x')
    end

    assert_raises(Siteswap::SyntaxError) do
      Siteswap.validate('[(33]')
    end
  end

  def test_multiplex_siteswaps
    assert_equal Siteswap.validate('[33]'), true
  end

  def test_synchronous_siteswaps
    assert_equal Siteswap.validate('(6X,4)(4,6X)'), true
  end
end
