local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		{ trig = "ife", name = "If Err Wrapped", dscr = "if error return" },
		fmt(
			[[
			if <>err != nil {
				return <>fmt.Errorf("<>: %w", err)
			}
			]], {
				i(1, ""), i(2, ""), i(3, "")
			}, {
				delimiters = "<>",
			}
		)
	),
	s(
		{ trig = "test", name = "Test Func", dscr = "test function" },
		fmt(
			[[
			func Test<>(t *testing.T) {
				<>
			}
			]], {
				i(1, ""), i(2, ""),
			}, {
				delimiters = "<>",
			}
		)
	),
	s(
		{ trig = "testt", name = "Table-Test Func", dscr = "table-test function" },
		fmt(
			[[
			func Test<>(t *testing.T) {
				tests := []struct {
					name string
					<>
				} {
					<>
				}
				for _, test := range tests {
					t.Run(test.name, func(t *testing.T) {
						<>
					})
				}
			}
			]], {
				i(1, ""), i(2, ""), i(3, ""), i(4, ""),
			}, {
				delimiters = "<>",
			}
		)
	),
}
