# 宏任务、微任务、事件循环

参考：https://www.cnblogs.com/wangziye/p/9566454.html
场景题：写出控制台输出结果

```js
(() => {
  //主线程直接执行
  console.log("1");
  //丢到宏事件队列中
  setTimeout(() => {
    console.log("2");
    Promise.resolve().then(() => console.log("3"));
    new Promise(function (resolve) {
      console.log("4");
      resolve();
    }).then(() => {
      console.log("5");
    });
  });
  //微事件1
  Promise.resolve().then(() => console.log("6"));
  //主线程直接执行
  new Promise(function (resolve) {
    console.log("7");
    resolve();
  }).then(() => {
    //微事件2
    console.log("8");
  });
  //丢到宏事件队列中
  setTimeout(() => {
    console.log("9");
    Promise.resolve().then(() => console.log("10"));
    new Promise(function (resolve) {
      console.log("11");
      resolve();
    }).then(() => {
      console.log("12");
    });
  });
})();
```
