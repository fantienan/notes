# redux 的使用

## redux 基础知识

- 基本概念
- 单向数据流
- react-redux
- 异步 action
- 中间件

## redux 工作流程

- dispatch(action) 派发
- reducer -> newState
- subscribe 订阅

![image](../../images/redux数据流程.jpg)

## redux 中间件

![image](../../images/redux中间件.jpg)
![image](../../images/redux1中间件.jpg)

## redux 异步 action

- 常用的异步中间件有 redux-thunk、redux-promise、redux-sage

![image](../../images/redux异步action代码示例.jpg)

## react-redux 链接 react 与 redux 的高阶函数

- Provider：生产商用来注册 store
- connect：容器组件本质是高阶函数，store.subscribe 订阅 redux state，将 redux state 树中读取部分数据渲染到 react 组件 props 中，connect 做了很多性能优化，避免许多不必要的渲染。定义 mapStateToProps、mapDispatchToProps。
- mapStateToProps、mapDispatchToProps：将自定义后的 state、dispatch 映射到到 react 组件的 props 中
