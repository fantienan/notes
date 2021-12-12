# babel

- https://www.babeljs.cn/

## 环境搭建和基本配置

- babel 是通过 plugin 实现编译的，比如将 es6 编译为 es5
- presets 与 plugins 的区别
  - presets（预设）：将一些常用的 plugin 集成为一个 plugin 中
  - plugins：babel 插件

## babel 本身只解析语法，不处理 api，

- babel 会把不符合 es5 语法的代码解析为符合 es5 的语法，例如 `() => {}`解析为`function(){}`，解析新 API 交给 babel-polyfill 完成。
- babel 不处理模块化，模块化交给 webpack

.babelrc

```bash
{
  "presets": [
      [ "@babel/preset-env"] // 解析语法的插件集合
  ],
  "plugins": []
}
```

解析前

```js
import "@babel/polyfill";
// 解析前
const sum = (a, b) => a + b;

// 新的 API
Promise.resolve(100).then((data) => data);

// 新的 API
[10, 20, 30].includes(20);
```

解析后

```js
"use strict";

require("@babel/polyfill");

var sum = function sum(a, b) {
  return a + b;
};

// 新的 API
Promise.resolve(100).then(function (data) {
  return data;
});

// 新的 API
[10, 20, 30].includes(20); // 语法，符合 ES5 语法规范
```

## babel-polyfill

- 什么是 ployfill：补丁
- core-js 和 regenerator
  - core-js：除 generator 以外的所有 ployfill 的集合
  - regenerator：generator ployfill
- [babel-polyfill](https://www.babeljs.cn/docs/babel-polyfill) 是 [core-js](https://github.com/zloirock/core-js) 和 [regenerator](https://github.com/zloirock/core-js) 的集合
- babel 7.4 之后弃用 babel-polyfill，原因
  - babel-polyfill 配置按需引入后代码中会直接引入的是 core-js
- 推荐直接使用 core-js 和 regenerator
- babel-ployfill 会造成全局污染

### babel-polyfill 按需引入

.babelrc

```bash
{
  "presets": [
    [
      "@babel/preset-env",
      {
        "useBuiltIns": "usage",
        "corejs": 3 // 使用corejs version 3
      }
    ]
  ],
  "plugins": []
}

```

解析前

```js
const sum = (a, b) => a + b;

// 新的 API
Promise.resolve(100).then((data) => data);

// 新的 API
[10, 20, 30].includes(20);
```

解析后

```js
"use strict";
// 按需引入解析新API的polyfill
require("core-js/modules/es.object.to-string.js");

require("core-js/modules/es.promise.js");

require("core-js/modules/es.array.includes.js");

var sum = function sum(a, b) {
  return a + b;
};

// 新的 API
Promise.resolve(100).then(function (data) {
  return data;
});
// 新的 API
[10, 20, 30].includes(20); // 语法，符合 ES5 语法规范
```

## babel-runtime

babel-ployfill 会造成全局污染，而 babel-runtime 可以解决这个问题

.babelrc

```js
{
  "presets": [
    [
      "@babel/preset-env",
      {
        "useBuiltIns": "usage",
        "corejs": 3
      }
    ]
  ],
  "plugins": [
    [
      "@babel/plugin-transform-runtime",
      {
        "absoluteRuntime": false,
        "corejs": 3,
        "helpers": true,
        "regenerator": true,
        "useESModules": false
      }
    ]
  ]
}
```

解析前

```js
const sum = (a, b) => a + b;

// 新的 API
Promise.resolve(100).then((data) => data);

// 新的 API
[10, 20, 30].includes(20);
```

解析后

```js
"use strict";

var _interopRequireDefault = require("@babel/runtime-corejs3/helpers/interopRequireDefault");

var _promise = _interopRequireDefault(
  require("@babel/runtime-corejs3/core-js-stable/promise")
);

var _includes = _interopRequireDefault(
  require("@babel/runtime-corejs3/core-js-stable/instance/includes")
);

var _context;

var sum = function sum(a, b) {
  return a + b;
};

// 新的 API
_promise["default"].resolve(100).then(function (data) {
  return data;
});

// 新的 API
(0, _includes["default"])((_context = [10, 20, 30])).call(_context, 20); // 语法，符合 ES5 语法规范
```

## babel-runtime 和 babel-polyfill 的区别

- babel-polyfill 会造成全局污染
- babel-runtime 不会造成全局污染
