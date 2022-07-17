## 什么是虚拟 dom

- 用 js 数据结构描述 dom 结构

## 作用

- js 的计算速度非常快，可以通过用 js 模拟的 DOM 结构，计算出最小的变更范围来操作 dom

## 虚拟 dom 的数据结构

```js
{
  type: 'div',
  props: {
    style: {},
    on: {click: () => {}}
  },
  children: [
    {
      type: 'div',
      props: {
        className: '',
      }
    }
  ]
}

```

## 虚拟 dom 第三方工具

- [snabbdom](https://github.com/snabbdom/snabbdom)
