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
    // TODO: use stack
    scratch: mem.Scratch
    mem.scratch_init(&scratch, size_of(rune) * MAX_LINE_SIZE * 2)
    for line in strings.split_lines_iterator(&input) {
        line2 := strings.clone(line, mem.scratch_allocator(&scratch))
        // all?
        defer free(&line2, mem.scratch_allocator(&scratch))

        expr, _ := strings.split_iterator(&line2, " -> ")
        wire, _ := strings.split_iterator(&line2, " -> ")
        fmt.println("wire:",wire,", expr:",expr)

        fst, _ := strings.split_iterator(&expr, " ")
        snd, snd_ok := strings.split_iterator(&expr, " ")
        if !snd_ok {
            // signal or wire
            sig, sig_ok := strconv.parse_int(fst)
            if sig_ok {
                fmt.println("just signal",sig)
            } else {
                fmt.println("just wire", fst)
            }
            continue
        }
        thr, thr_ok := strings.split_iterator(&expr, " ")
        if !thr_ok {
            // unary
            assert(fst == "NOT")
            sig, sig_ok := strconv.parse_int(snd)
            if sig_ok {
                fmt.println("~",sig)
            } else {
                fmt.println("~", snd)
            }
            continue
        }
        // binary
        lsig, lsig_ok := strconv.parse_int(fst)
        rsig, rsig_ok := strconv.parse_int(thr)
        if lsig_ok {
            fmt.print(lsig)
        } else {
            fmt.print( fst)
        }
        switch snd {
        case "AND":
            fmt.print(" & ")
        case "OR":
            fmt.print(" | ")
        case "RSHIFT":
            fmt.print(" >> ")
        case "LSHIFT":
            fmt.print(" << ")
        }
        if rsig_ok {
            fmt.println(rsig)
        } else {
            fmt.println( thr)
        }
    }
}
