Cargo 里面有许多有用的命令, 一些常用的命令包括:

- cargo new 生成新的项目模板
- cargo build 构建项目, 生成可执行文件或依赖
- cargo run 构建并运行项目
- cargo test 运行测试用例
- cargo check 检查项目代码, 由于 Rust 编译较慢, 因此在开发中常用 check 代替 build 命令
- cargo doc 生成项目文档
- cargo publish 将库发布到 crates.io

除了以上 cargo 自带的命令外, cargo 还支持安装额外的扩展命令, 例如格式化工具. rustfmt 是一个可以自定义风格的 rust 代码格式化工具, 使用如下命令安装它:

```bash
$ rustup component add rustfmt
```

在项目根目录输入以下命令, 会自动格式化项目内的全部 Rust 源文件.

```bash
$ cargo fmt
```

- 请自己动手使用 `cargo new hello --lib` 创建项目, 并看看 `--bin` 与 `--lib` 两个不同参数创建出的项目有什么不同.
- 请自己动手打乱 `main.rs` 中的代码, 并使用 `cargo fmt` 命令重新格式化它!
