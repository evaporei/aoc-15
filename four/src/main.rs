#[test]
fn first() {
    assert_eq!(solution1("abcdef"), 609043);
}
fn solution1(input: &str) -> usize {
    for n in 0..std::usize::MAX {
        if hash(format!("{input}{n}")).starts_with("00000") {
            return n;
        }
    }
    unreachable!("not found")
}

fn hash(s: String) -> String {
    let digest = md5::compute(s);
    format!("{digest:x}")
}
fn main() {
    let input = std::fs::read_to_string("input").unwrap();
    println!("{}", solution1(&input.trim()));
}
