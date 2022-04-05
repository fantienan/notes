1. [使用变量存储值](https://kaisery.github.io/trpl-zh-cn/ch02-00-guessing-game-tutorial.html#%E4%BD%BF%E7%94%A8%E5%8F%98%E9%87%8F%E5%82%A8%E5%AD%98%E5%80%BC)

```rs
let mut guess = String::new();
```

声明字符串类型的可变变量，等号的右边是 guess 所绑定的值，它是 String::new 的结果，这个函数会返回一个 String 的新实例。String 是一个标准库提供的字符串类型，它是 UTF-8 编码的可增长文本块。

::new 那一行的 :: 语法表明 new 是 String 类型的一个关联函数。关联函数（associated function）是实现一种特定类型的函数，在这个例子中类型是 String。

new 函数创建了一个新的空字符串，你会发现很多类型上有 new 函数，因为它是创建类型实例的惯用函数名。

总的来说，let mut guess = String::new(); 这一行创建了一个可变变量，当前它绑定到一个新的 String 空实例上。

2. 范围表达式`start..end`， 它包含下限但不包含上限，所以需要指定 `1..101` 来请求一个 `1` 和 `100` 之间的数。另外，我们也可以传递 `1..=100`，这是等价的，获得 1 至 100 间的随机数示例：

```rs
let secret_number = rand::thread_rng().gen_range(1..101)
```
3. Rust有四种基本标量类型： 整型、浮点型、布尔类型和字符类型。
4. Rust有两个原生的复合类型：元组和数组
5. 语句和表达式
- 语句没有返回值，`let x = 5`这是一个语句
- 表达式会计算出一个值，