defmodule Base62Test do
  use ExUnit.Case

  doctest Base62

  test "encode integer to string" do
    assert Base62.encode(1) == "1"
    assert Base62.encode(34) == "Y"
    assert Base62.encode(100) == "1c"
    assert Base62.encode(152) == "2S"
    assert Base62.encode(548) == "8q"
    assert Base62.encode(1922) == "V0"
    assert Base62.encode(8373) == "2B3"
    # assert Base62.encode(289_487_823_498_453) = "1KCauzhbR"
    # assert Base62.encode(87_243_578_843_598_453) = "6RZk84KzSP"
  end

  test "decode string to integer" do
    assert Base62.decode("1") == 1
    assert Base62.decode("Y") == 34
    assert Base62.decode("1c") == 100
    assert Base62.decode("2S") == 152
    assert Base62.decode("8q") == 548
    assert Base62.decode("V0") == 1922
    assert Base62.decode("2B3") == 8373
    # assert Base62.decode("1KCauzhbR") = 289_487_823_498_453
    # assert Base62.decode("6RZk84KzSP") = 87_243_578_843_598_453
  end

end
