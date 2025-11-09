package nine

import "core:fmt"
import "core:strconv"
import "core:strings"

main :: proc() {
	part1(#load("example", string))
}
part1 :: proc(input: string) {
	input := input

	for line in strings.split_lines_iterator(&input) {
		line := line

		loc1, _ := strings.split_iterator(&line, " to ")
		loc2_dist, _ := strings.split_iterator(&line, " to ")
		loc2, _ := strings.split_iterator(&loc2_dist, " = ")
		dist_str, _ := strings.split_iterator(&loc2_dist, " = ")

		dist, _ := strconv.parse_int(dist_str)

		fmt.println(loc1, loc2, dist)
	}
}
