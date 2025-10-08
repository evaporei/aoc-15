#[test]
fn test_solution1(){
    assert_eq!(solution1("2x3x4"),58);
}
fn solution1(input: &str) -> usize {
    input.lines().fold(0, |total, line| {
        let mut dims = line.split('x');
        let length = dims.next().unwrap().parse::<usize>().unwrap();
        let width = dims.next().unwrap().parse::<usize>().unwrap();
        let height = dims.next().unwrap().parse::<usize>().unwrap();
        let area1 = length * width;
        let area2 = width * height;
        let area3 = height * length;
        let area = 2 * (area1 + area2 + area3);
        total + area + area1.min(area2).min(area3)
    })
}
fn main() {
    let input = std::fs::read_to_string("input").unwrap();
    println!("{}", solution1(&input));
}
