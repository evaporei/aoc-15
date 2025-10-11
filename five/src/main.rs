use std::collections::HashMap;

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
fn solution2(input: &str) -> usize {
    fn is_nice(s: &str) -> bool {
        let mut m = HashMap::new();
        let mut one_letter = false;
        let bytes = s.as_bytes();
        for (i, triple) in bytes.windows(3).enumerate() {
            if triple[0] == triple[2] {
                one_letter = true;
            }
            m.entry((triple[0], triple[1]))
                .and_modify(|e: &mut Vec<_>| e.push(i))
                .or_insert(vec![i]);
        }
        let penultimate = bytes.len() - 2;
        m.entry((bytes[penultimate], bytes[penultimate + 1]))
            .and_modify(|e: &mut Vec<_>| e.push(penultimate))
            .or_insert(vec![penultimate]);
        let has_pair = m
            .values()
            .flat_map(|indices| indices.windows(2))
            .any(|pair| pair[1] - pair[0] > 1);
        has_pair && one_letter
    }
    input.lines().filter(|s| is_nice(s)).count()
}
fn main() {
    let input = std::fs::read_to_string("input").unwrap();
    println!("{}", solution1(&input));
    println!("{}", solution2(&input));
}
