# 使用 Traits 定义共同的行为

某一类数据可能含有一些共同的行为: 例如它们能被显示在屏幕上, 或者能相互之间比较大小… 我们将这种共同的行为称作 Traits. 我们使用标准库 std::fmt::Display 这个 traits 举例, 这个 traits 实现了在 Formatter 中使用空白格式 {} 的功能.

```rust
pub trait Display {
    pub fn fmt(&self, f: &mut Formatter<'_>) -> Result<(), Error>;
}

```

```rust
use std::fmt;

struct Point {
    x: i32,
    y: i32,
}

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

let origin = Point { x: 0, y: 0 };

assert_eq!(format!("The origin is: {}", origin), "The origin is: (0, 0)");
```

## 使用 Traits 作为参数类型

在知道如何定义和实现 Traits 后, 我们就可以探索如何使用 Traits 来定义接受许多不同类型的函数. 这一切都与 Java 中的接口概念类似, 也就是所谓的鸭子类型. 事实上它们的使用场景也基本上是类似的.

我们定义一个 display 函数, 它接收一个实现了 Display Traits 的参数 item.

```rust
pub fn display(item: &impl std::fmt::Display) {
    println!("My display item is {}", item);
}
```

item 的参数类型是 impl std::fmt::Display 而不是某个具体的类型(例如 Point), 这样, 任何实现了 Display Traits 的数据类型都可以作为参数传入该函数.
