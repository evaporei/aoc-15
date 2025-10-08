use std::collections::HashMap;

type Position = (isize, isize);

struct Santa {
    pos: Position,
    map: HashMap<Position, usize>,
}
impl Santa {
    fn new() -> Self {
        let pos = (0, 0);
        let mut map = HashMap::new();
        map.insert(pos, 1);
        Self { pos, map }
    }
    fn move_(&mut self, dir: char) {
        let (x, y) = self.pos;
        let new_pos = match dir {
            '>' => (x + 1, y),
            '<' => (x - 1, y),
            '^' => (x, y + 1),
            'v' => (x, y - 1),
            _ => (x, y),
        };
        self.map.entry(new_pos).and_modify(|e| *e += 1).or_insert(1);
        self.pos = new_pos;
    }
}
fn solution1(input: &str) -> usize {
    input
        .chars()
        .fold(Santa::new(), |mut santa, dir| {
            santa.move_(dir);
            santa
        })
        .map
        .len()
}
fn main() {
    let input = std::fs::read_to_string("input").unwrap();
    println!("{}", solution1(&input));
}
