# Rust 中的模块化编程

自上个世纪 90 年代以来, 软件工程的复杂性越来越高, 程序渐渐从一个人的独狼开发转为多人团队协作开发. 在今天, 通过 Github 或中心化的代码分发网站, 我们可以轻松的在一个软件工程中同时引入世界各地的开发者开发的代码, 我们与同事在同一个工程目录下并行开发不同的程序功能, 或者在不拷贝代码的前提下将一个工程中的代码在另一个工程中复用… 这一切都是因为模块化编程.

模块化编程, 是强调将计算机程序的功能分离成独立的和可相互改变的"模块"的软件设计技术, 它使得每个模块都包含着执行预期功能的一个唯一方面所必需的所有东西. 复杂的系统被分割为小块的独立代码块.

Rust 项目的代码组织包含以下三个基本概念:

- Package(包)
- Crate(箱)
- Module(模块)

我们在以下分别进行说明.

## Package

Package 用于管理一个或多个 Crate. 创建一个 Package 的方式是使用 cargo new, 我们来看看一个 Package 包含哪些文件.

```bash
$ cargo new my-project
Created binary (application) `my-project` package
$ ls my-project
Cargo.toml
src
$ ls my-project/src
main.rs
```

当我们输入命令时, Cargo 创建了一个目录以及一个 Cargo.toml 文件, 这就是一个 Package. 默认情况下, src/main.rs 是与 Package 同名的二进制 Crate 的入口文件, 因此我们可以说我们现在有一个 my-project Package 以及一个二进制 my-project Crate. 同样, 如果在创建 Package 的时候带上 --lib, 那么 src/lib.rs 将是它的 Crate 入口文件, 且它是一个库 Crate.
如果我们的 src 目录中同时包含 main.rs 和 lib.rs, 那么我们将在这个 Package 中同时得到一个二进制 Crate 和一个库 Crate, 这在开发一些基础库时非常有用, 例如你使用 Rust 中实现了一个 MD5 函数, 你既希望这个 MD5 函数能作为库被别人引用, 又希望你能获得一个可以进行 MD5 计算的命令行工具: 那就同时添加 main.rs 和 lib.rs 吧!

## Crate

Crate 是 Rust 的最小编译单元, 即 Rust 编译器是以 Crate 为最小单元进行编译的. Crate 在一个范围内将相关的功能组合在一起, 并最终通过编译生成一个二进制或库文件. 例如, 我们在上一章中实现的猜数字游戏就使用了 rand 依赖, 这个 rand 就是一个 Crate.

## Module

Module 允许我们将一个 Crate 中的代码组织成独立的代码块, 以便于增强可读性和代码复用. 同时, Module 还控制代码的可见性, 即将代码分为公开代码和私有代码. 公开代码可以在项目外被使用, 私有代码则只有项目内部的代码才可以访问. 定义一个模块最基本的方式是使用 mod 关键字:

```rust
mod mod1 {
  pub mod mod2 {
    pub const MESSAGE: &str = "Hello World!"
    // ...
  }
  // ...
}
fn main() {
  println!(mod1::mod2::MESSAGE);
}
```
