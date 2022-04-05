# println

`println!` 用于将数据打印到标准输出, 且在数据末尾自动带上换行符. 在所有平台上, 换行符都是换行符(没有额外的回车符).

使用 `println!` 用于程序的正常输出, 使用 `eprintln!` 打印错误或者进度条. 前者数据被写入 stdout, 后者则是 stderr. `println!` 宏常用的格式化语法如下所示:
```rust
fn main() {
    // `{}` 会被变量内容替换, 这是最常见的一种用法
    `println!`("{}", 42);

    // 可以使用额外的位置参数.
    `println!`("{0}{1}{0}", 4, 2);

    // 使用命名参数.
    `println!`("name={name} age={age}", name="jack", age=6);

    // 可以在 `:` 后面指定特殊的格式.
    `println!`("{} of {:b} people know binary, the other half don't", 1, 2);

    // 可以按指定宽度来右对齐文本.
    `println!`("{number:>width$}", number=1, width=6);

    // 在数字左边补 0.下面语句输出 "000001".
    `println!`("{number:>0width$}", number=1, width=6);

    // `println!` 会检查使用到的参数数量是否正确.
    `println!`("My name is {0}, {1} {0}", "Bond");
    // 编译将会报错, 请补上漏掉的参数："James"
}
```