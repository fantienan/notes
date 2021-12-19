# React.render 渲染流程

1. react-dom/src/client/ReactDOM.js

- 导出 render 方法

2. react-dom/src/client/ReactDOMLegacy.js

- 声明 render 方法，接受三个参数 element：ReactElement 根组件，container：要挂在到的根节点，callback：渲染完成后的回调
- render 调用 legacyRenderSubtreeIntoContainer 方法，将子树渲染到容器中
- legacyRenderSubtreeIntoContainer 函数中调用 updateContainer

3. react-reconciler/src/ReactFiberReconciler.old.js

- 声明 updateContainer 函数，并调用 createUpdate
- enqueueUpdate
- scheduleUpdateOnFiber
