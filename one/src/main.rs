#[test]
fn first_test() {
    assert_eq!(solution1("(())"), 0);
    assert_eq!(solution1("()()"), 0);
}

fn solution1(input: &str) -> isize {
    let chars: Vec<_> = input.chars().collect();
    // println!("{chars:?}");
    let mut floor=0;
    for ch in chars {
        match ch {
            '(' => floor+=1,
            ')' => floor-=1,
            _=>{}
        };
    }
    floor
}
fn solution2(input: &str) -> usize {
    let mut floor:isize=0;
    for (i, ch) in 
    input.chars()
.enumerate() {
        match ch {
            '(' => floor+=1,
            ')' => floor-=1,
            _=>{}
        };
        if floor == -1 {
            return i+1;
        }
    }
    unreachable!("incorrect input")
}
fn main() {
    let input = std::fs::read_to_string("input").unwrap();

    //println!("{input}");

    println!("{}", solution2(&input));
}




 