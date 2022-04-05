# 使用 super 与 self 简化模块路径

除了使用完整路径访问模块内的成员, 还可以使用 super 与 self 关键字相对路径对模块进行访问.

- super: 上层模块
- self: 当前模块

当上层模块, 当前模块或子模块中拥有相同名字的成员时, 使用 super 与 self 可以消除访问时的歧义.

```rust
fn function() {
    println!("function");
}

pub mod mod1 {
    pub fn function() {
        super::function();
    }

    pub mod mod2 {
        fn function() {
            println!("mod1::mod2::function");
        }

        pub fn call() {
            self::function();
        }
    }
}

fn main() {
    mod1::function();
    mod1::mod2::call();
}
```
