# 实现 new 关键词的思路

# apply、call、bind 区别

# 实现 apply 或 bind 的思路

## new

### 原理介绍

- new 关键词的作用
  - 执行一个构造函数并且返回一个实例对象，根据构造函数的情况来确定是否接收参数
- 实例化过程描述
  - 创建一个新对象
  - 将构造函数的作用域赋给新对象（this 指向新对象）
  - 执行构造函数中的代码（为这个新对象添加属性）
  - 返回新对象
- new 关键词执行之后总会返回一个对象，要么是实例对象，要么是 return 语句指定的对象

- 去掉 new 执行构造函数，this 指向 window

```js
function Person() {
  this.name = "Jack";
}

const p = Person();

console.log(p); // undefined
console.log(name); // Jack
console.log(p.name); // 'name' of undefined
```

- 构造函数返回一个对象

```js
function Person() {
  this.name = "Jack";
  return {
    age: 8,
  };
}

const p = new Person();

console.log(p); // {age: 8}
console.log(name); // undefined
console.log(p.name); // undefined
```

- 构造函数返回字符串

```js
function Person() {
  this.name = "Jack";
  return "Tom";
}

const p = new Person();

console.log(p); // {name: "Jack"}
console.log(p.name); // Jack
```

### new 实现

#### new 被调用后大致做了几件事情

- 让实例可以访问到私有属性
- 让实例可以访问构造函数原型及原型链上的属性
- 构造函数返回的结构始终是引用类型

#### code

```js
function _new(ctor, ...args) {
  if (typeof ctor !== "function") {
    return "必须是一个函数";
  }
  const obj = new Object();
  obj.__proto__ = Object.create(ctor.prototype);
  const res = ctor.apply(obj, ...args);
  return (res !== null && typeof res === "function") || typeof res === "object"
    ? res
    : obj;
}

function Parent({ name } = {}) {
  this.name = name ?? "p";
}

Parent.prototype.getName = function () {
  return this.name;
};

const p = _new(Parent, { name: 1 });
const p1 = new Parent({ name: 1 });
```

## apply & call & bind

### 原理介绍

- call、apply 和 bind 都是 Function 对象的方法，调用者必须是函数。
- 作用都是改变 func 的 this 指向，区别如下：
  - call 第一个参数是 this，其余参数在 this 后一次传入，立即执行
  - apply 第一个参数是 this，第二个参数是数组， 立即执行
  - bind 第一个参数是 this，其余参数在 this 后一次传入，绑定 this 之后，再次调用执行

### 应用

- 判断数据类型：Object.prototype.toString.call(arg)，

```js
function getType(obj) {
  const type = typeof obj;

  if (type !== "object") {
    return type;
  }

  return Object.prototype.toString.call(obj);
}
```

- 借用方法：Array.prototype.push.call({}, 1,2)，类数组借用 Array 的 push 方法

```js
const arrayLike = {
  0: 1,
  1: 2
  length: 2
}

Array.prototype.push.call(arrayLike,3,4,5)

```

- 用 apply 判断数组中最大最小值，将数组作为第二个参数可以减少一步展开数组的步骤 Math.min.apply(Math, [1,2,3,4])

```js
const arr = [1, 2, 3, 4, 5];
Math.prototype.min.call(Math, arr);
```

- 继承

```js
function Parent() {
  this.name = "p";
  this.play = [1, 2, 3, 4];
}

Parent.prototype.getName = function () {
  return this.name;
};

function Child() {
  Parent.call(this);
  this.type = "c";
}

Child.prototype = new Parent();
Child.prototype.constructor = Child;
```
