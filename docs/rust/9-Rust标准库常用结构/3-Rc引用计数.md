# Rc 引用计数

你可以将 Rc 看作 Box 的高级版本: 它是带引用计数的智能指针. 只有当它的引用计数为 0 时, 数据才会被清理.

考虑我们上节课讲的 ConsList 场景, 如果多个节点共享一个节点, 例如:

```bash
0 -> 1 \
        |-> 4
2 -> 3 /
```

节点 4 它所拥有的值会有多个所有者, 这个时候就需要使用 Rc 来进行包装.

```rust

use std::rc::Rc;

enum List {
    Cons(u32, Rc<List>),
    Nil,
}
// 要实现的数据结构
// 0 -> 1 \
//         |-> 4
// 2 -> 3 /
fn main() {
    // Rc引用计数 可以让一个值有多个所有者
    let four = Rc::new(List::Cons(4, Rc::new(List::Nil)));
    let zero_one = List::Cons(0, Rc::new(List::Cons(1, Rc::clone(&four))));
    let two_three = List::Cons(2, Rc::new(List::Cons(3, Rc::clone(&four))));
}
```
