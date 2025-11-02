package seven
import "core:strconv"
import "core:mem"

import "core:fmt"
import "core:strings"
import "core:os"

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
    l,r: ^Val,
}
Not :: struct {
    using _: Unary,
}
And :: struct {
    using _: Binary,
}
Or :: struct {
    using _: Binary,
}
RShift :: struct {
    using _: Binary,
}
LShift :: struct {
    using _: Binary,
}
MAX_LINE_SIZE :: 18
main :: proc(){
    input := #load("example", string)
    ast := make(map[Wire]Val)
    // TODO: use stack
    scratch: mem.Scratch
    mem.scratch_init(&scratch, size_of(rune) * MAX_LINE_SIZE * 2)
    for line in strings.split_lines_iterator(&input) {
        line2 := strings.clone(line, mem.scratch_allocator(&scratch))
        // all?
        defer free(&line2, mem.scratch_allocator(&scratch))

        expr, _ := strings.split_iterator(&line2, " -> ")
        wire, _ := strings.split_iterator(&line2, " -> ")

        fst, _ := strings.split_iterator(&expr, " ")
        snd, snd_ok := strings.split_iterator(&expr, " ")
        if !snd_ok {
            // signal or wire
            sig, sig_ok := strconv.parse_int(fst)
            v := new(Val)
            if sig_ok {
                v^ = Signal(sig)
            } else {
                v^ = Wire(strings.clone(fst))
            }
            ast[wire] = v^
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
                v^ = Wire(strings.clone(snd))
            }
            ast[wire] = Not{v = v}
            continue
        }
        // binary
        lsig, lsig_ok := strconv.parse_int(fst)
        lv := new(Val)
        if lsig_ok {
            lv^ = Signal(lsig)
        } else {
            lv^ = Wire(strings.clone(fst))
        }
        rsig, rsig_ok := strconv.parse_int(thr)
        rv := new(Val)
        if rsig_ok {
            rv^ = Signal(rsig)
        } else {
            rv^ = Wire(strings.clone(thr))
        }
        v:=new(Val)
        switch snd {
        case "AND":
            v^=And{r=rv,l=lv}
        case "OR":
            v^=Or{r=rv,l=lv}
        case "RSHIFT":
            v^=RShift{r=rv,l=lv}
        case "LSHIFT":
            v^=LShift{r=rv,l=lv}
        }
        ast[wire]=v^
    }
}
