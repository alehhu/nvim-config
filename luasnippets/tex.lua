local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

-- Helper functions for context detection (equivalent to UltiSnips global functions)
local function math()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local function comment()
	return vim.fn["vimtex#syntax#in_comment"]() == 1
end

local function env(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return is_inside[1] > 0 and is_inside[2] > 0
end

-- Condition functions for snippet contexts
local in_mathzone = function()
	return math()
end

local not_in_mathzone = function()
	return not math()
end

local in_comment = function()
	return comment()
end

local not_in_comment = function()
	return not comment()
end

local in_env = function(env_name)
	return function()
		return env(env_name)
	end
end

-- Example: Create context checkers for specific environments
local in_itemize = in_env("itemize")
local in_enumerate = in_env("enumerate")
local in_align = in_env("align")
local in_equation = in_env("equation")

-- Auto subscript function
local generate_matrix_placeholders = function(args)
	local nodes = {}
	local col_count = string.len(args[1][1])
	for j = 1, col_count do
		if j == col_count then
			table.insert(nodes, t({ "" }))
		else
			table.insert(nodes, t({ " & " }))
		end
	end
	return sn(nil, nodes)
end

return {
	-- CONTEXT EXAMPLES: Different ways to use context conditions

	-- 1. Math-only snippets (only trigger in math zones)
	s("alpha", t("\\alpha"), { condition = in_mathzone }),
	s("beta", t("\\beta"), { condition = in_mathzone }),
	s("gamma", t("\\gamma"), { condition = in_mathzone }),

	-- 2. Text-only snippets (only trigger outside math zones)
	s("emph", fmta("\\emph{<>}", { i(1) }), { condition = not_in_mathzone }),
	s("textbf", fmta("\\textbf{<>}", { i(1) }), { condition = not_in_mathzone }),

	-- 3. Environment-specific snippets
	s("item", t("\\item "), {
		condition = function()
			return in_itemize() or in_enumerate()
		end,
	}),

	-- 4. Combined conditions (math AND not in comment)
	s("frac", fmta("\\frac{<>}{<>}", { i(1), i(2) }), {
		condition = function()
			return in_mathzone() and not in_comment()
		end,
	}),

	-- 5. Complex condition example
	s("aligned", fmta("\\begin{aligned}\n\t<>\n\\end{aligned}", { i(1) }), {
		condition = function()
			-- Only in math mode, not in align environment already, and not in comments
			return in_mathzone() and not in_align() and not in_comment()
		end,
	}),

	-- Basic template
	s("template", {
		t({
			"\\documentclass[a4paper]{article}",
			"",
			"\\usepackage[utf8]{inputenc}",
			"\\usepackage[T1]{fontenc}",
			"\\usepackage{textcomp}",
			"\\usepackage[dutch]{babel}",
			"\\usepackage{amsmath, amssymb}",
			"",
			"",
			"% figure support",
			"\\usepackage{import}",
			"\\usepackage{xifthen}",
			"\\pdfminorversion=7",
			"\\usepackage{pdfpages}",
			"\\usepackage{transparent}",
			"\\newcommand{\\incfig}[1]{%",
			"\t\\def\\svgwidth{\\columnwidth}",
			"\t\\import{./figures/}{#1.pdf_tex}",
			"}",
			"",
			"\\pdfsuppresswarningpagegroup=1",
			"",
			"\\begin{document}",
			"\t",
		}),
		i(0),
		t({ "", "\\end{document}" }),
	}),

	-- Begin/end environment
	s("beg", fmta("\\begin{<>}\n\t<>\n\\end{<>}", { i(1), i(0), rep(1) })),

	-- Dots
	s({ trig = "...", priority = 100 }, t("\\ldots"), { condition = in_mathzone }),

	-- Table environment
	s(
		"table",
		fmta(
			[[
\begin{table}[<>]
	\centering
	\caption{<>}
	\label{tab:<>}
	\begin{tabular}{<>}
	<><>
	\end{tabular}
\end{table}]],
			{
				i(1, "htpb"),
				i(2, "caption"),
				i(3, "label"),
				i(4, "c"),
				i(0),
				d(5, generate_matrix_placeholders, { 4 }),
			}
		)
	),

	-- Figure environment
	s(
		"fig",
		fmta(
			[[
\begin{figure}[<>]
	\centering
	<>
	\caption{<>}
	\label{fig:<>}
\end{figure}]],
			{
				i(1, "htpb"),
				i(2, "\\includegraphics[width=0.8\\textwidth]{<>}"),
				i(3),
				i(4),
			}
		)
	),

	-- Lists
	s("enum", fmta("\\begin{enumerate}\n\t\\item <>\n\\end{enumerate}", { i(0) })),
	s("item", fmta("\\begin{itemize}\n\t\\item <>\n\\end{itemize}", { i(0) })),
	s("desc", fmta("\\begin{description}\n\t\\item[<>] <>\n\\end{description}", { i(1), i(0) })),

	-- Package
	s("pac", fmta("\\usepackage[<>]{<>}<>", { i(1, "options"), i(2, "package"), i(0) })),

	-- Logic symbols
	s("=>", t("\\implies"), { condition = in_mathzone }),
	s("=<", t("\\impliedby"), { condition = in_mathzone }),
	s("iff", t("\\iff"), { condition = in_mathzone }),

	-- Math modes
	s(
		"mk",
		fmta("$<>$<>", {
			i(1),
			f(function(args, snip, user_arg_1)
				if #args[1] > 0 and args[1][1]:sub(-1) and not string.match(args[1][1]:sub(-1), "[,%.%?%- ]") then
					return " "
				end
				return ""
			end, { 1 }),
		})
	),

	s("dm", fmta("\\[\n<>\n.\\] <>", { i(1), i(0) })),
	s("ali", fmta("\\begin{align*}\n\t<>\n.\\end{align*}", { i(1) })),

	-- Fractions
	s("/", fmta("\\frac{<>}{<>}<>", { i(1), i(2), i(0) }), { condition = in_mathzone }),
	s("//", fmta("\\frac{<>}{<>}<>", { i(1), i(2), i(0) })),

	-- Auto subscript
	s(
		{ trig = "([A-Za-z])(%d)", regTrig = true },
		f(function(_, snip)
			return snip.captures[1] .. "_{" .. snip.captures[2] .. "}"
		end),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "([A-Za-z])_(%d%d)", regTrig = true },
		f(function(_, snip)
			return snip.captures[1] .. "_{" .. snip.captures[2] .. "}"
		end),
		{ condition = in_mathzone }
	),

	-- SymPy integration (simplified - would need actual sympy integration)
	s("sympy", fmta("sympy <> sympy<>", { i(1), i(0) })),

	-- Equals and comparisons
	s("==", fmta("&= <> \\\\", { i(1) })),
	s("!=", t("\\neq "), { condition = in_mathzone }),
	s("<=", t("\\le ")),
	s(">=", t("\\ge ")),

	-- Brackets and delimiters
	s("ceil", fmta("\\left\\lceil <> \\right\\rceil <>", { i(1), i(0) }), { condition = in_mathzone }),
	s("floor", fmta("\\left\\lfloor <> \\right\\rfloor<>", { i(1), i(0) }), { condition = in_mathzone }),
	s("pmat", fmta("\\begin{pmatrix} <> \\end{pmatrix} <>", { i(1), i(0) })),
	s("bmat", fmta("\\begin{bmatrix} <> \\end{bmatrix} <>", { i(1), i(0) })),

	-- Parentheses variants
	s("()", fmta("\\left( <> \\right) <>", { i(1), i(0) }), { condition = in_mathzone }),
	s("lr", fmta("\\left( <> \\right) <>", { i(1), i(0) })),
	s("lr(", fmta("\\left( <> \\right) <>", { i(1), i(0) })),
	s("lr|", fmta("\\left| <> \\right| <>", { i(1), i(0) })),
	s("lr{", fmta("\\left\\{ <> \\right\\} <>", { i(1), i(0) })),
	s("lrb", fmta("\\left\\{ <> \\right\\} <>", { i(1), i(0) })),
	s("lr[", fmta("\\left[ <> \\right] <>", { i(1), i(0) })),
	s("lra", fmta("\\left\\langle <> \\right\\rangle<>", { i(1), i(0) })),

	-- Math functions and operators
	s("conj", fmta("\\overline{<>}<>", { i(1), i(0) }), { condition = in_mathzone }),
	s("sum", fmta("\\sum_{n=<>}^{<>} <>", { i(1, "1"), i(2, "\\infty"), i(3, "a_n z^n") })),
	s(
		"taylor",
		fmta("\\sum_{<>=<>}^{<>} <> (x-a)^<> <>", { i(1, "k"), i(2, "0"), i(3, "\\infty"), i(4, "c_k"), rep(1), i(0) })
	),
	s("lim", fmta("\\lim_{<> \\to <>} ", { i(1, "n"), i(2, "\\infty") })),
	s("limsup", fmta("\\limsup_{<> \\to <>} ", { i(1, "n"), i(2, "\\infty") })),
	s("prod", fmta("\\prod_{<>}^{<>} <> <>", { i(1, "n=1"), i(2, "\\infty"), i(3), i(0) })),
	s("part", fmta("\\frac{\\partial <>}{\\partial <>} <>", { i(1, "V"), i(2, "x"), i(0) })),

	-- Powers and indices
	s("sq", fmta("\\sqrt{<>} <>", { i(1), i(0) }), { condition = in_mathzone }),
	s("sr", t("^2"), { condition = in_mathzone }),
	s("cb", t("^3"), { condition = in_mathzone }),
	s("td", fmta("^{<>}<>", { i(1), i(0) }), { condition = in_mathzone }),
	s("rd", fmta("^{(<>)}<>", { i(1), i(0) }), { condition = in_mathzone }),
	s("__", fmta("_{<>}<>", { i(1), i(0) })),

	-- Special symbols
	s("ooo", t("\\infty")),
	s("rij", fmta("(<>_<>)_{<> \\in <>}<>", { i(1, "x"), i(2, "n"), i(3, "n"), i(4, "\\N"), i(0) })),

	-- Logic quantifiers
	s("EE", t("\\exists "), { condition = in_mathzone }),
	s("AA", t("\\forall "), { condition = in_mathzone }),

	-- Common subscripts
	s("xnn", t("x_{n}"), { condition = in_mathzone }),
	s("ynn", t("y_{n}"), { condition = in_mathzone }),
	s("xii", t("x_{i}"), { condition = in_mathzone }),
	s("yii", t("y_{i}"), { condition = in_mathzone }),
	s("xjj", t("x_{j}"), { condition = in_mathzone }),
	s("yjj", t("y_{j}"), { condition = in_mathzone }),
	s("xp1", t("x_{n+1}"), { condition = in_mathzone }),
	s("xmm", t("x_{m}"), { condition = in_mathzone }),

	-- Special number sets
	s("R0+", t("\\R_0^+")),
	s("NN", t("\\N")),
	s("RR", t("\\R")),
	s("QQ", t("\\Q")),
	s("ZZ", t("\\Z")),
	s("HH", t("\\mathbb{H}")),
	s("DD", t("\\mathbb{D}")),

	-- Plot environment
	s(
		"plot",
		fmta(
			[[
\begin{figure}[<>]
	\centering
	\begin{tikzpicture}
		\begin{axis}[
			xmin= <>, xmax= <>,
			ymin= <>, ymax = <>,
			axis lines = middle,
		]
			\addplot[domain=<>:<>, samples=<>]{<>};
		\end{axis}
	\end{tikzpicture}
	\caption{<>}
	\label{<>}
\end{figure}]],
			{
				i(1),
				i(2, "-10"),
				i(3, "10"),
				i(4, "-10"),
				i(5, "10"),
				i(6, "-10"),
				i(7, "10"),
				i(8, "100"),
				i(9),
				i(10),
				i(11),
			}
		)
	),

	-- TikZ node
	s(
		"nn",
		fmta("\\node[<>] (<>) <> {$<>$};\n<>", {
			i(2),
			i(3),
			i(4, "at (0,0) "),
			i(1),
			i(0),
		})
	),

	-- Math fonts and symbols
	s("mcal", fmta("\\mathcal{<>}<>", { i(1), i(0) }), { condition = in_mathzone }),
	s("lll", t("\\ell")),
	s("nabl", t("\\nabla "), { condition = in_mathzone }),
	s("xx", t("\\times "), { condition = in_mathzone }),
	s({ trig = "**", priority = 100 }, t("\\cdot ")),
	s("norm", fmta("\\|<>\\|<>", { i(1), i(0) }), { condition = in_mathzone }),

	-- Trigonometric and other functions
	s(
		{ trig = "(sin|cos|arccot|cot|csc|ln|log|exp|star|perp)", regTrig = true, priority = 100 },
		f(function(_, snip)
			return "\\" .. snip.captures[1]
		end),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "(arcsin|arccos|arctan|arccot|arccsc|arcsec|pi|zeta|int)", regTrig = true, priority = 200 },
		f(function(_, snip)
			return "\\" .. snip.captures[1]
		end),
		{ condition = in_mathzone }
	),

	-- Integrals
	s(
		{ trig = "dint", priority = 300 },
		fmta("\\int_{<>}^{<>} <> <>", { i(1, "-\\infty"), i(2, "\\infty"), i(3), i(0) }),
		{ condition = in_mathzone }
	),

	-- Arrows
	s("->", t("\\to "), { condition = in_mathzone, priority = 100 }),
	s("<->", t("\\leftrightarrow"), { condition = in_mathzone, priority = 200 }),
	s("!>", t("\\mapsto "), { condition = in_mathzone }),

	-- Special operators
	s("invs", t("^{-1}"), { condition = in_mathzone }),
	s("compl", t("^{c}"), { condition = in_mathzone }),
	s("\\\\\\", t("\\setminus"), { condition = in_mathzone }),
	s(">>", t("\\gg")),
	s("<<", t("\\ll")),
	s("~~", t("\\sim ")),
	s("||", t(" \\mid ")),

	-- Set operations
	s("set", fmta("\\{<>\\} <>", { i(1), i(0) }), { condition = in_mathzone }),
	s("cc", t("\\subset "), { condition = in_mathzone }),
	s("notin", t("\\not\\in ")),
	s("inn", t("\\in "), { condition = in_mathzone }),
	s("Nn", t("\\cap ")),
	s("UU", t("\\cup ")),
	s("uuu", fmta("\\bigcup_{<>} <>", { i(1, "i \\in I"), i(0) })),
	s("nnn", fmta("\\bigcap_{<>} <>", { i(1, "i \\in I"), i(0) })),
	s("OO", t("\\O")),
	s("<!", t("\\triangleleft ")),
	s({ trig = "<>", priority = 50 }, t("\\diamond ")),

	-- Text in math
	s({ trig = "sts", regTrig = true }, fmta("_\\text{<>} <>", { i(1), i(0) }), { condition = in_mathzone }),
	s("tt", fmta("\\text{<>}<>", { i(1), i(0) }), { condition = in_mathzone }),

	-- Cases
	s("case", fmta("\\begin{cases}\n\t<>\n\\end{cases}", { i(1) }), { condition = in_mathzone }),

	-- SI units
	s("SI", fmta("\\SI{<>}{<>}", { i(1), i(2) })),

	-- Big function
	s(
		"bigfun",
		fmta(
			[[
\begin{align*}
	<>: <> &\longrightarrow <> \\
	<> &\longmapsto <>(<>) = <>
.\end{align*}]],
			{ i(1), i(2), i(3), i(4), rep(1), rep(4), i(0) }
		)
	),

	-- Column vector
	s(
		"cvec",
		fmta(
			"\\begin{pmatrix} <>_{<>}\\\\ \\vdots\\\\ <>_{<>} \\end{pmatrix}",
			{ i(1, "x"), i(2, "1"), rep(1), i(3, "n") }
		)
	),

	-- Bar and hat with regex
	s(
		{ trig = "([a-zA-Z])bar", regTrig = true, priority = 100 },
		f(function(_, snip)
			return "\\overline{" .. snip.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "([a-zA-Z])hat", regTrig = true, priority = 100 },
		f(function(_, snip)
			return "\\hat{" .. snip.captures[1] .. "}"
		end),
		{ condition = in_mathzone }
	),

	s({ trig = "bar", priority = 10 }, fmta("\\overline{<>}<>", { i(1), i(0) }), { condition = in_mathzone }),
	s({ trig = "hat", priority = 10 }, fmta("\\hat{<>}<>", { i(1), i(0) }), { condition = in_mathzone }),

	-- Common phrases
	s("letw", t("Let $\\Omega \\subset \\C$ be open.")),
}
