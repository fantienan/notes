# SystemTime

在程序中处理时间是一个常见的需求, 我们来看下如何在 Rust 中处理时间相关的功能.

```rust
use std::thread::sleep;
use std::time::{Duration, SystemTime};

fn main() {
    // 获取当前时间
    let mut now = SystemTime::now();
    println!("{:?}", now);

    // 获取 UNIX TIMESTAMP
    let timestamp = now.duration_since(SystemTime::UNIX_EPOCH);
    println!("{:?}", timestamp);

    sleep(Duration::from_secs(4));

    // 获取流逝的时间
    println!("{:?}", now.elapsed());

    // 时刻的增减
    now.checked_add(Duration::from_secs(60))
}
```

如果你需要处理日期, 可以使用第三方库 [chrono](https://github.com/chronotope/chrono).
