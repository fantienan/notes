# 使用 use 绑定模块成员

正常情况下当我们试图从模块内中访问其成员时, 需要输入完整的路径, 例如使用 std::fs::read 从磁盘上读取文件:

```rust
fn main() {
    let data = std::fs::read("src/main.rs").unwrap();
    println!("{}", String::from_utf8(data).unwrap());
}
```

可以使用 use 关键词将完整路径绑定到一个新的名称, 这可以减少重复代码:

```rust
use std::fs;

fn main() {
    let data = fs::read("src/main.rs").unwrap();
    println!("{}", String::from_utf8(data).unwrap());
}
```

可以使用 as 关键字将导入绑定到一个其他名称, 它通常用在有多个不同模块都定义了相同名字的成员时使用:

```rust
use std::fs as stdfs;

fn main() {
    let data = stdfs::read("src/main.rs").unwrap();
    println!("{}", String::from_utf8(data).unwrap());
}
```
