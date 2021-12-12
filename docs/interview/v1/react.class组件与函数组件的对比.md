# react class 组件与函数组件的对比

## class 组件存在的问题

- 大型组件很难拆分和重构，很难测试（即 class 不易拆分）
- 相同业务逻辑分攒到各个方法中，逻辑混乱
- 服用逻辑变得赋值，如 Mixins（react 已弃用）、HOC、Render Props

## React 组件更易用函数表达

- React 提倡函数式编程
- 函数更灵活更易拆分更易测试
- 但函数组件太简单，需要增强 -- Hooks
