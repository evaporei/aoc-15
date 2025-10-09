use std::collections::{HashMap, HashSet};

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
fn solution2(input: &str) -> usize {
    let (santa, robo) = input.chars().enumerate().fold(
        (Santa::new(), Santa::new()),
        |(mut santa, mut robo), (i, dir)| {
            if i % 2 == 0 {
                santa.move_(dir);
            } else {
                robo.move_(dir);
            }
            (santa, robo)
        },
    );
    let s: HashSet<Position> = santa.map.keys().copied().collect();
    let r: HashSet<Position> = robo.map.keys().copied().collect();
    s.union(&r).count()
}
fn main() {
    let input = std::fs::read_to_string("input").unwrap();
    println!("{}", solution1(&input));
    println!("{}", solution2(&input));
}
