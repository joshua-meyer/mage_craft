module Base
  class EveryOtherTurn < EveryNthTurn

    def initialize(hash_args)
      super(hash_args)
      @n = 2
    end

  end
end
