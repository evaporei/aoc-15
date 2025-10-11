fn solution1(input: &str) -> usize {
    fn is_nice(s: &str) -> bool {
        let mut it = s.chars().peekable();
        let mut vowels = 0;
        let mut twice = false;
        while let Some(ch) = it.next() {
            if let 'a' | 'e' | 'i' | 'o' | 'u' = ch {
                vowels += 1
            }
            if it.peek() == Some(&ch) {
                twice = true;
            }
            match (ch, it.peek()) {
                ('a', Some(&'b')) | ('c', Some(&'d')) | ('p', Some(&'q')) | ('x', Some(&'y')) => {
                    return false;
                }
                _ => {}
            }
        }
        vowels >= 3 && twice
    }
    input.lines().filter(|s| is_nice(s)).count()
}
fn main() {
    let input = std::fs::read_to_string("input").unwrap();
    println!("{}", solution1(&input.trim()));
}
