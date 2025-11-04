package seven

import ts "core:container/topological_sort"
import "core:fmt"
import "core:strconv"
import "core:strings"

Signal :: u16
Wire :: string
Val :: union {
	Signal,
	Wire,
}
Kind :: enum {
	v,
	not,
	and,
	or,
	ls,
	rs,
}
Tuple :: struct {
	l, r: Val,
	k:    Kind,
}
Ast :: map[Wire]Tuple
main :: proc() {
	solve(#load("input", string))
	solve(#load("input2", string))
}
solve :: proc(input: string) {
	input := input
	ast := make(Ast)
	sorter: ts.Sorter(string)
	ts.init(&sorter)

	for line in strings.split_lines_iterator(&input) {
		line := line

		expr, _ := strings.split_iterator(&line, " -> ")
		wire, _ := strings.split_iterator(&line, " -> ")

		ts.add_key(&sorter, wire)

		fst, _ := strings.split_iterator(&expr, " ")
		snd, snd_ok := strings.split_iterator(&expr, " ")
		if !snd_ok {
			// signal or wire
			sig, sig_ok := strconv.parse_int(fst)
			t: Tuple
			t.k = .v
			if sig_ok {
				t.l = Signal(sig)
			} else {
				ts.add_dependency(&sorter, wire, fst)
				t.l = Wire(fst)
			}
			ast[wire] = t
			continue
		}
		thr, thr_ok := strings.split_iterator(&expr, " ")
		if !thr_ok {
			// unary
			assert(fst == "NOT")
			sig, sig_ok := strconv.parse_int(snd)
			t: Tuple
			t.k = .not
			if sig_ok {
				t.l = Signal(sig)
			} else {
				ts.add_dependency(&sorter, wire, snd)
				t.l = Wire(snd)
			}
			ast[wire] = t
			continue
		}
		// binary
		t: Tuple
		lsig, lsig_ok := strconv.parse_int(fst)
		if lsig_ok {
			t.l = Signal(lsig)
		} else {
			t.l = Wire(fst)
			ts.add_dependency(&sorter, wire, fst)
		}
		rsig, rsig_ok := strconv.parse_int(thr)
		if rsig_ok {
			t.r = Signal(rsig)
		} else {
			t.r = Wire(thr)
			ts.add_dependency(&sorter, wire, thr)
		}
		switch snd {
		case "AND":
			t.k = .and
		case "OR":
			t.k = .or
		case "RSHIFT":
			t.k = .rs
		case "LSHIFT":
			t.k = .ls
		}
		ast[wire] = t
	}
	sorted, cycled := ts.sort(&sorter)
	assert(len(cycled) == 0)
	for key in &sorted {
		ast[key] = leaf(&ast, key)
	}
	// fmt.println(ast)
	fmt.println(ast["a"].l)
}
leaf :: proc(ast: ^Ast, key: string) -> Tuple {
	t := ast[key]
	switch t.k {
	case .v:
		if s, s_ok := t.l.(string); s_ok {
			return leaf(ast, s)
		}
		return t
	case .not:
		if s, s_ok := t.l.(string); s_ok {
			out := leaf(ast, s)
			out.l = ~out.l.(Signal)
			return out
		}
		t.l = ~t.l.(Signal)
		return t
	case .and:
		lv, rv := leaf_binary(ast, t)
		out: Tuple
		out.l = lv & rv
		return out
	case .or:
		lv, rv := leaf_binary(ast, t)
		out: Tuple
		out.l = lv | rv
		return out
	case .rs:
		lv, rv := leaf_binary(ast, t)
		out: Tuple
		out.l = lv >> rv
		return out
	case .ls:
		lv, rv := leaf_binary(ast, t)
		out: Tuple
		out.l = lv << rv
		return out
	}
	return {}
}
leaf_binary :: proc(ast: ^Ast, t: Tuple) -> (lv, rv: Signal) {
	if s, s_ok := t.l.(string); s_ok {
		lv = leaf(ast, s).l.(Signal)
	} else {
		lv = t.l.(Signal)
	}
	if s, s_ok := t.r.(string); s_ok {
		rv = leaf(ast, s).l.(Signal)
	} else {
		rv = t.r.(Signal)
	}
	return
}
