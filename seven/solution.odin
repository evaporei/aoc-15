package seven
import ts "core:container/topological_sort"
import "core:strconv"

import "core:fmt"
import "core:strings"

Signal :: u16
Wire :: string
Val :: union {
	Signal,
	Wire,
	Not,
	And,
	Or,
	RShift,
	LShift,
}
Unary :: struct {
	v: ^Val,
}
Binary :: struct {
	l, r: ^Val,
}
Not :: distinct Unary
And :: distinct Binary
Or :: distinct Binary
RShift :: distinct Binary
LShift :: distinct Binary
Ast :: map[Wire]Val
MAX_LINE_SIZE :: 18
main :: proc() {
	input := #load("input", string)
	ast := make(Ast)
	sorter: ts.Sorter(string)
	ts.init(&sorter)

	for line in strings.split_lines_iterator(&input) {
		line2 := line

		expr, _ := strings.split_iterator(&line2, " -> ")
		wire, _ := strings.split_iterator(&line2, " -> ")
		wire2 := strings.clone(wire)
		ts.add_key(&sorter, wire2)

		fst, _ := strings.split_iterator(&expr, " ")
		snd, snd_ok := strings.split_iterator(&expr, " ")
		if !snd_ok {
			// signal or wire
			sig, sig_ok := strconv.parse_int(fst)
			v := new(Val)
			if sig_ok {
				v^ = Signal(sig)
			} else {
				s := strings.clone(fst)
				ts.add_dependency(&sorter, wire2, s)
				v^ = Wire(s)
			}
			ast[wire2] = v^
			continue
		}
		thr, thr_ok := strings.split_iterator(&expr, " ")
		if !thr_ok {
			// unary
			assert(fst == "NOT")
			sig, sig_ok := strconv.parse_int(snd)
			v := new(Val)
			if sig_ok {
				v^ = Signal(sig)
			} else {
				s := strings.clone(snd)
				ts.add_dependency(&sorter, wire2, s)
				v^ = Wire(s)
			}
			ast[wire2] = Not {
				v = v,
			}
			continue
		}
		// binary
		lsig, lsig_ok := strconv.parse_int(fst)
		lv := new(Val)
		if lsig_ok {
			lv^ = Signal(lsig)
		} else {
			s := strings.clone(fst)
			lv^ = Wire(s)
			ts.add_dependency(&sorter, wire2, s)
		}
		rsig, rsig_ok := strconv.parse_int(thr)
		rv := new(Val)
		if rsig_ok {
			rv^ = Signal(rsig)
		} else {
			s := strings.clone(thr)
			rv^ = Wire(s)
			ts.add_dependency(&sorter, wire2, s)
		}
		v := new(Val)
		switch snd {
		case "AND":
			v^ = And {
				r = rv,
				l = lv,
			}
		case "OR":
			v^ = Or {
				r = rv,
				l = lv,
			}
		case "RSHIFT":
			v^ = RShift {
				r = rv,
				l = lv,
			}
		case "LSHIFT":
			v^ = LShift {
				r = rv,
				l = lv,
			}
		}
		ast[wire2] = v^
	}
	sorted, cycled := ts.sort(&sorter)
	assert(len(cycled) == 0)
	for key in &sorted {
		ast[key] = leaf(&ast, key)
	}
	// fmt.println(ast)
	fmt.println(ast["a"])
}
leaf :: proc(ast: ^Ast, key: string) -> Signal {
	val := ast[key]
	switch v in val {
	case Signal:
		return v
	case Wire:
		return leaf(ast, v)
	case Not:
		if s, s_ok := v.v.(string); s_ok {
			return ~leaf(ast, s)
		}
		return ~v.v.(Signal)
	case And:
		lv, rv := leaf_binary(ast, Binary(v))
		return lv & rv
	case Or:
		lv, rv := leaf_binary(ast, Binary(v))
		return lv | rv
	case RShift:
		lv, rv := leaf_binary(ast, Binary(v))
		return lv >> rv
	case LShift:
		lv, rv := leaf_binary(ast, Binary(v))
		return lv << rv
	}
	return 0
}
leaf_binary :: proc(ast: ^Ast, v: Binary) -> (lv, rv: Signal) {
	if s, s_ok := v.l.(string); s_ok {
		lv = leaf(ast, s)
	} else {
		lv = v.l.(Signal)
	}
	if s, s_ok := v.r.(string); s_ok {
		rv = leaf(ast, s)
	} else {
		rv = v.r.(Signal)
	}
	return
}
