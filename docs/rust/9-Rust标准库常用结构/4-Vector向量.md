# Vector

Vector 是动态大小的数组. 与切片一样, 它们的大小在编译时是未知的, 但它们可以随时增长或收缩, 向量使用 3 个参数表示:

- 指向数据的指针
- 长度
- 容量

容量表示为向量预留了多少内存. 一旦长度大于容量, 向量将申请更大的内存进行重新分配.

```rust
fn main() {
    // 声明向量的两种方法
    let mut v_1 = Vec::new();
    for i in 0..10 {
        v_1.push(i);
    }
    println!("{:?}", v_1);
    let mut v_2 = vec![0,1,2,3,4,5,6,7,8,9];
    println!("{:?}", v_2);
    println!("{:?}", v_2.pop());
    println!("{:?}", v_2.len());
    println!("{:?}", v_2.capacity()); // 容量
    for i in v_2.iter() {
        println!("{:?}", i)
    }
    for e in v_2.iter_mut() {
        *e *= 2;
    }
    println!("{:?}", v_2);
}

```
