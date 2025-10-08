use std::collections::HashMap;

fn solution1(input: &str) -> usize {
    let start_pos = (0, 0);
    let mut start_map = HashMap::new();
    start_map.insert(start_pos, 1);
    input
        .chars()
        .fold((start_pos, start_map), |((x, y), mut map), dir| {
            let new_pos = match dir {
                '>' => (x + 1, y),
                '<' => (x - 1, y),
                '^' => (x, y + 1),
                'v' => (x, y - 1),
                _ => (x, y),
            };
            map.entry(new_pos).and_modify(|e| *e += 1).or_insert(1);
            (new_pos, map)
        })
        .1
        .len()
}
fn main() {
    let input = std::fs::read_to_string("input").unwrap();
    println!("{}", solution1(&input));
}
