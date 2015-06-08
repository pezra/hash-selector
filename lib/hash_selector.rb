require "hash_selector/version"

# Selects a value from a complex or deeply nested hash structure with default
# values.
#
# Example
#
# HashSelector.new[:foo][:bar][:baz].find_in(foo: { bar: { baz: 42 } } )
# # => 42
#
# HashSelector.new[:foo][:bar][:baz].find_in(foo: nil) { 42 }
# # => 42
class HashSelector

  # Returns a new selector that selects the specified key from result of the
  # current selector.
  def [](key)
    HashSelector.new steps + [ ->(subject) {
                                 begin
                                   subject.fetch(key)
                                 rescue IndexError
                                   raise KeyError
                                 end
                               } ],
                     desc + "[#{key.inspect}]"
  end

  # Returns a new selector that selects an entry from the result of the current
  # selector using a predicate block.
  def find(&blk)
    HashSelector.new steps + [ ->(subject) {
                                   needle = subject.find(->(){ MISSING }, &blk)
                                   if MISSING == needle
                                     fail KeyError
                                   else
                                     needle
                                   end
                               } ],
                     desc + ".find{...}"
  end
  alias_method :detect, :find

  # Returns the value from a hash at the location specified by this selector.
  def find_in(hay_stack)
    idx = 0
    steps.reduce(hay_stack) { |search_area, step| idx +=1; step.call(search_area) }

  rescue KeyError
    if block_given?
      yield hay_stack
    else
      raise KeyError, "step #{idx} of #{self} failed to match"
    end
  end

  def to_s
    desc
  end

  protected

  MISSING = Object.new

  def initialize(steps = [], desc="HashSelector.new")
    @steps = steps
    @desc = desc
  end

  attr_reader :steps, :desc
end
