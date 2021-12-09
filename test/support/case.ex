defmodule AntlPhonenumber.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      import AntlPhonenumber.Case
      import AntlPhonenumber.Factory
    end
  end
end
