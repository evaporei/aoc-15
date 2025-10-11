#[test]
fn first() {
    assert_eq!(solution1("abcdef"), 609043);
}
fn solution1(input: &str) -> usize {
    for n in 0..std::usize::MAX {
        let attempt = md5::compute(format!("{input}{n}"));
        let result = format!("{attempt:x}");
        if result.starts_with("00000") {
            return n;
        }
    }
    unreachable!("not found")
}
fn main() {
    let input = std::fs::read_to_string("input").unwrap();
    println!("{}", solution1(&input.trim()));
}
