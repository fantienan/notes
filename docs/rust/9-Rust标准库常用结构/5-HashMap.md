# HashMap

HashMap 是一种从 Key 映射到 Value 的数据结构.

与 Vector 一样, HashMap 也是可以动态调整大小的, 可以使用以下方法创建一个 HashMap.

```rust
use std::collections::HashMap;

fn main() {
    let mut transcript: HashMap<&str, u32> = HashMap::new();
    transcript.insert("alice", 99);
    transcript.insert("jack", 97);
    transcript.insert("bob", 95);

    match transcript.get(&"alice") {
        Some(data) => println!("{:?}", data),
        None => println!("alice not found")
    }

    transcript.remove(&"alice");

    match transcript.get(&"alice") {
        Some(data) => println!("{:?}", data),
        None => println!("alice not found")
    }
    // 迭代HashMap，HashMap中存储的数据是没有顺序的
    for (name, source) in transcript.iter() {
        println!("{:?} {:?}", name, source)
    }
}

```

大多数数据类型都可以作为 HashMap 的 Key, 只要它们实现了 Eq 和 Hash traits.
