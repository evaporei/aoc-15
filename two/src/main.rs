#[test]
fn test_solution1() {
    assert_eq!(solution1("2x3x4"), 58);
}
struct Present {
    length: usize,
    width: usize,
    height: usize,
}

fn solution1(input: &str) -> usize {
    parse_presents(input).fold(
        0,
        |total,
         Present {
             length,
             width,
             height,
         }| {
            let area1 = length * width;
            let area2 = width * height;
            let area3 = height * length;
            let area = 2 * (area1 + area2 + area3);
            total + area + area1.min(area2).min(area3)
        },
    )
}

fn parse_presents(input: &str) -> impl Iterator<Item = Present> {
    input.lines().map(|line| {
        let mut dims = line.split('x');
        Present {
            length: dims.next().unwrap().parse::<usize>().unwrap(),
            width: dims.next().unwrap().parse::<usize>().unwrap(),
            height: dims.next().unwrap().parse::<usize>().unwrap(),
        }
    })
}
fn main() {
    let input = std::fs::read_to_string("input").unwrap();
    println!("{}", solution1(&input));
}
