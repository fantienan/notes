# webpack 面试题

## 前端代码为什么会进行构建和打包

从代码层面和研发流程方面阐述

### 代码层面

- 体积更小（Tree-Shaking、压缩、合并），加载更快
- 编译高级语言或语法（TS,ES6,模块化,scss）
- 兼容性和错误检查（Pollyfill、postcss、eslint）

### 研发流程方面

- 统一、高效的开发环境
- 统一的构建流程和产出标准
- 集成公司构建规范（提测、上线等）

## module chunk bundle 分别是什么、有何区别

- module：各个源码文件（除 index.html）文件，webpack 中一切皆模块
- chunk：多模块合并成的集合，能够产生 chunk 有
  - entry：每一个入口都会产生一个 chunk
  - import()：动态引入的文件会被 chunk
  - splitChunks：配置的 cacheGroups 会生成多个 chunk
- bundle：最终输出的文件，与 chunk 的区别是：chunk 是 webpack 解析的中间产物，存储在内存中，而 bundle 是 webpack 解析生成的最终文件

**左：module，中：chunks，右：bundle**
![images](../../images/webpack.png)

## loader 和 plugin 的区别

- loader 模块转换器，配置解析一类文件的规则，如 less 转 css
- plugin 扩展插件，经过 loader 解析后需要用到哪些插件，如 HtmlWebppackPlugin

## 常用的 loader 和 plugin

- https://www.webpackjs.com/loaders/
- https://www.webpackjs.com/plugins/

## babel 和 webpack 的区别

- babel-JS 新语法编译工具，不关心模块化
- webpack-打包构建工具，是多个 loader、plugin 的集合

## 为何 Proxy 不能被 Polyfill

- class 可以用 function 模拟
- promise 可以哦那个 callback 模拟
- Proxy 不能用 Object.defineProperty 无法模拟

## webpack 基础配置

### 拆分配置和 merge

一般会根据环境拆分成四个配置文件

- webpack.common.js：公共配置
- webpack.dev.js：开发环境配置
- webpack.prod.js：生产环境配置
- webpack.test.js：测试环境配置

### 启动本地服务

- 配置 devServer 本地开发服务
- mode:development 配置开发模式

### 处理 ES6

`webpack` 通过 `module.rules` 配置 `loader`，`babel-loader`处理 js 文件，ES6 做兼容处理，通过 `.babelrc`配置 babel

- `module.rules[x].test` 正则匹配文件类型
- `module.rules[x].loader`配置使用的 loader，**注意 loader 的执行顺序是从后往前执行**
- `module.rules[x].include` 配置处理范围
- `module.rules[x].exclude` 配置排除范围，一般会配置 node_modules

```js
 {
    test: /\.js$/,
    loader: ['babel-loader'],
    include: srcPath,
    exclude: /node_modules/
  }
```

### 处理样式

`webpack` 通过 `module.rules` 配置 `loader`, 配置如下

```js

 {
    test: /\.css$/,
    // loader 的执行顺序是：从后往前
    // loader: ['style-loader', 'css-loader', 'postcss-loader']
    loader: ['style-loader/url', 'file-loader', 'postcss-loader']
  }
```

- postcss-loader：兼容处理，添加前缀，通过 postcss.config.js 进行配置
- css-loader：运行在 js 中引入 css 文件，会将 css 文件当成一个模块引入到 js 中
- style-loader：创建 style 标签，不能单独使用，因为它不负责解析 css 文件
- style-loader/url：将 css 样式以 link 标签引入

### 处理图片

- file-loader：处理图片，打包后会生成单独的图片文件，**存在缺陷：每个图片在加载是都会发送一个 http 请求，当图片过多会严重拖慢页面加载速度**。
- url-loader：内部封装了 file-loader 但不依赖 file-loader，将小于 limit 的图片打包成 base64 的形式，

### 模块化

## webpack 高级配置

### 如何支持多页面应用

- entry 要配置多个入口

```js
{
  entry: {
    index: path.join(srcPath, 'index.js'),
    other: path.join(srcPath, 'other.js')
  },
}
```

- output.filename 要以字符串模板的形式声明，name 即多入口 entry key

```js
{
  output: {
    filename: "[name].[contenthash:8].js";
    path: distPath;
  }
}
```

- plugins 配置多个 HtmlWebpackPlugin 实例，用以生成多入口 html 文件

```js
{
  // 多入口 - 生成 index.html
  new HtmlWebpackPlugin({
    template: path.join(srcPath, "index.html"),
    filename: "index.html",
    // chunks 表示该页面要引用哪些 chunk （即上面的 index 和 other），默认全部引用
    chunks: ["index"], // 只引用 index.js
  }),
    // 多入口 - 生成 other.html
    new HtmlWebpackPlugin({
      template: path.join(srcPath, "other.html"),
      filename: "other.html",
      chunks: ["other"], // 只引用 other.js
    });
}
```

### css 的抽离及压缩

一般在生产环境会对 css 进行抽离及压缩

- 在生产环境会用`mini-css-extract-plugin`代替`style-loader`抽离 css 文件，以 link 标签引入，
- 用`terser-webpack-plugin`、`optimize-css-assets-webpack-plugin`压缩 css

```js
{
  module: {
    rules: [
      {
        test: /\.css$/,
        loader: [
          MiniCssExtractPlugin.loader, // 注意，这里不再用 style-loader
          "css-loader",
          "postcss-loader",
        ],
      },
      // 抽离 less --> css
      {
        test: /\.less$/,
        loader: [
          MiniCssExtractPlugin.loader, // 注意，这里不再用 style-loader
          "css-loader",
          "less-loader",
          "postcss-loader",
        ],
      },
    ];
  },
  plugins: [
    // 抽离 css 文件
    new MiniCssExtractPlugin({
      filename: 'css/main.[contentHash:8].css'
    })
  ],
  optimization: {
    // 压缩 css
    minimizer: [new TerserJSPlugin({}), new OptimizeCSSAssetsPlugin({})],
  }
}
```

### 抽离公共代码

解决打包后文件过大问题，例如抽离第三方库、抽离公共引用，注意在多页面应用中，需要在 HtmlWebpackPlugins 配置 chunk 引用

- chunks: 通过引入方式的不同进行拆分，all 全部 chunks，initial 只对同步直接引入的文件 chunks，async 只对异步引入的文件 chunks
- cacheGroups：缓存分组
- name：chunk 名称
- priority：权重
- test：正则匹配命中规则，
- minSize：文件大小限制
- minChunks：最少复用次数

```js
{
  entry: {
    index: path.join(srcPath, 'index.js'),
    other: path.join(srcPath, 'other.js')
  },
  optimization: {
    splitChunks: {
      // initial 入口 chunk，对于异步导入的文件不处理
      // async 异步 chunk，只对异步导入的文件处理
      // all 全部 chunk
      chunks: 'all',
      // 缓存分组
      cacheGroups: {
          // 第三方模块
          vendor: {
              name: 'vendor', // chunk 名称
              priority: 1, // 权限更高，优先抽离，重要！！！
              test: /node_modules/,
              minSize: 0,  // 大小限制
              minChunks: 1  // 最少复用过几次
          },
          // 公共的模块
          common: {
              name: 'common', // chunk 名称
              priority: 0, // 优先级
              minSize: 0,  // 公共模块的大小限制
              minChunks: 2  // 公共模块最少复用过几次
          }
      }
    }
  },
  // 多入口 - 生成 index.html
  new HtmlWebpackPlugin({
    template: path.join(srcPath, 'index.html'),
    filename: 'index.html',
    // chunks 表示该页面要引用哪些 chunk （即上面的 index 和 other），默认全部引用
    chunks: ['index', 'vendor', 'common']  // 要考虑代码分割
  }),
  // 多入口 - 生成 other.html
  new HtmlWebpackPlugin({
    template: path.join(srcPath, 'other.html'),
    filename: 'other.html',
    chunks: ['other', 'common']  // 考虑代码分割
  })
}
```

### 懒加载

webpack 原生支持 import()实现懒加载，import()会被单独 chunk

```js
import("xxx").then((res) => console.log(res.default));
```

### 处理 React、Vue

- react 通过 @babel/preset-env，vue 通过 vue-loader

```js
{
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        use: ["babel-loader"],
        include: srcPath,
        exclude: /node_modules/,
      },
      {
        test: /\.vue$/,
        use: ["vue-loader"],
        inclued: srcPatch,
        exclude: /node_modules/,
      },
    ];
  }
}
```

- .babelrc

```
{
  "presets": ["@babel/preset-env"],
  "plugins": []
}

```

## webpack 性能优化

### 优化打包构建速度-开发体验和效率

#### 优化 babel-loader

- 开启 babel-loader 缓存
- 明确范围：include、exclude 二选一

```js
{
  module: {
    rules: [
      {
        test: /\.js$/,
        use: ["babel-loader?cacheDirectory"], // 开启缓存
        include: path.resolve(__dirname, "src"), // 明确范围
        // include、exclude二选一
        // exclude: path.resolve(__dirname, /node_moudles/) // 排除范围
      },
    ];
  }
}
```

#### IgnorePlugin

避免引入无用模块，例如`import moment form 'moment'`引入 moment 库，默认会引入所有语言包，通过一下操作去除无用模块。

- webpack 添加 IgnorePlugin 插件，忽略 moment 下的/locale 目录
- 手动引入 moment 中文语言包

webpack.config.js

```js
const webpack = require("webpack");

{
  plugins: [
    // 忽略 moment 下的 /locale 目录
    new webpack.IgnorePlugin(/\.\/locale/, /moment/),
  ];
}
```

index.js

```js
import moment form 'moment';
import 'moment/local/zh-cn'; // 手动引入中文语言包
moment.locale('zh-cn') // 设置语言为中文
```

#### noParse

避免重复打包，配置 `modules.noParse` 精准过滤不需要解析的文件，类型正则表达式或函数。

```js
{
  modules: {
    noParse: /jquery|lodash/,
    noParse: (contentPath) =>{
      return /jquery|lodash/.test(contentPath);
    }
  }
}
```

#### IgnorePlugin 与 noParse 的区别

- IgnorePlugin：打包时忽略命中的内容，代码中没有
- noParse：对命中的内容不打包，代码中有

#### happyPack

多进程打包，JS 是单线程，开启多进程打包，提高构建速度（特别是多核 CPU）。

- 配置 happypack loader 替代 babel-loader，**注意要设置唯一标识 id**：`use: ["happypack/loader?id=babel"]`
- 添加 HappyPack 插件开启多进程打包，配置 id 与 rules 中 happypack loader 匹配，处理一类特定文件

```js
const HappyPack = require('happypack')

{
  module: {
    rules: [
      {
        test: /\.js$/,
        // loader: ['babel-loader?cacheDirectory'],
        // 把对 .js 文件的处理转交给 id 为 babel 的 HappyPack 实例
        use: ["happypack/loader?id=babel"],
        include: srcPath,
        // exclude: /node_modules/
      },
    ];
  },
  plugins: [
    // happyPack 开启多进程打包
    new HappyPack({
      // 用唯一的标识符 id 来代表当前的 HappyPack 是用来处理一类特定的文件
      id: 'babel',
      // 如何处理 .js 文件，用法和 Loader 配置中一样
      loaders: ['babel-loader?cacheDirectory']
    }),
  ]
}
```

#### ParallelUglifyPlugin

多进程压缩 JS，webpack 内置 Uglify 工具压缩 JS，开启多进程压缩更快，和 happyPack 同理

- 还是使用 UglifyJS，只不过开启了多进程

```js
const ParallelUglifyPlugin = require("webpack-parallel-uglify-plugin");

{
  plugins: [
    // 使用 ParallelUglifyPlugin 并行压缩输出的 JS 代码
    new ParallelUglifyPlugin({
      // 传递给 UglifyJS 的参数
      // （还是使用 UglifyJS 压缩，只不过帮助开启了多进程）
      uglifyJS: {
        output: {
          beautify: false, // 最紧凑的输出
          comments: false, // 删除所有的注释
        },
        compress: {
          // 删除所有的 `console` 语句，可以兼容ie浏览器
          drop_console: true,
          // 内嵌定义了但是只用到一次的变量
          collapse_vars: true,
          // 提取出出现多次但是没有定义成变量去引用的静态值
          reduce_vars: true,
        },
      },
    }),
  ];
}
```

#### 关于多进程

多进程打包、压缩要根据项目情况按需使用

- 项目较大打包较慢，打开多进程能提供速度
- 项目较小打包很快，开启多进程反而降低速度（进程开销）
- 按需使用

#### 自动刷新

开发环境配置 devServer，watch 设置为 true

```js
{
  watch: true, // 开启监听，默认为 false
  watchOptions: {
    ignored: /node_modules/, // 忽略哪些
    // 监听到变化发生后会等300ms再去执行动作，防止文件更新太快导致重新编译频率太高
    // 默认为 300ms
    aggregateTimeout: 300,
    // 判断文件是否发生变化是通过不停的去询问系统指定文件有没有变化实现的
    // 默认每隔1000毫秒询问一次
    poll: 1000
  }
}

```

#### 热更新

- 修改入口配置
- 添加热更新插件
- devServer 中开启热更新
- 需要注册热更新范围，命中范围内的文件则热更新

```js
const HotModuleReplacementPlugin = require('webpack/lib/HotModuleReplacementPlugin');

{
 entry: {
    // index: path.join(srcPath, 'index.js'),
    index: [
        'webpack-dev-server/client?http://localhost:8080/',
        'webpack/hot/dev-server',
        path.join(srcPath, 'index.js')
    ],
    other: path.join(srcPath, 'other.js')
  },
  plugins: [
    new HotModuleReplacementPlugin()
  ],
  devServer: {
    hot: true
  }
}

```

```js
// index.js
// 增加，开启热更新之后的代码逻辑
// 命中范围内的文件则热更新
if (module.hot) {
  module.hot.accept(["./math"], () => {
    const sumRes = sum(10, 30);
    console.log("sumRes in hot", sumRes);
  });
}
```

#### 自动刷新和热更新的区别

- 自动刷新：整个网页全部刷新，速度较慢
- 自动刷新：整个网页全部刷新，状态会丢失
- 热更新：新代码生效，网页不刷新，状态不会丢失

#### DllPlugin

- 前端框架如 vue react，体积大、构建慢
- 较稳定，不常升级版本
- 同一个版本只构建一次即可，不用每次都重新构建
- webpack 已经内置 DllPlugin 支持
- DllPlugin - 打包出 dll 文件
- DllReferencePlugin - 使用 dll 文件

用法如下

```json
"scripts": {
  "dll": "webpack --config build/webpack.dll.js"
}
```

build/webpack.dll.js 构建动态链接库

```js
const path = require("path");
const DllPlugin = require("webpack/lib/DllPlugin");
const { srcPath, distPath } = require("./paths");

module.exports = {
  mode: "development",
  // JS 执行入口文件
  entry: {
    // 把 React 相关模块的放到一个单独的动态链接库
    react: ["react", "react-dom"],
  },
  output: {
    // 输出的动态链接库的文件名称，[name] 代表当前动态链接库的名称，
    // 也就是 entry 中配置的 react 和 polyfill
    filename: "[name].dll.js",
    // 输出的文件都放到 dist 目录下
    path: distPath,
    // 存放动态链接库的全局变量名称，例如对应 react 来说就是 _dll_react
    // 之所以在前面加上 _dll_ 是为了防止全局变量冲突
    library: "_dll_[name]",
  },
  plugins: [
    // 接入 DllPlugin
    new DllPlugin({
      // 动态链接库的全局变量名称，需要和 output.library 中保持一致
      // 该字段的值也就是输出的 manifest.json 文件 中 name 字段的值
      // 例如 react.manifest.json 中就有 "name": "_dll_react"
      name: "_dll_[name]",
      // 描述动态链接库的 manifest.json 文件输出时的文件名称
      path: path.join(distPath, "[name].manifest.json"),
    }),
  ],
};
```

build/webpack.dev.js 使用动态链接库

```js
const path = require("path");
const webpack = require("webpack");
const { merge } = require("webpack-merge");
const webpackCommonConf = require("./webpack.common.js");
const { srcPath, distPath } = require("./paths");

// 第一，引入 DllReferencePlugin
const DllReferencePlugin = require("webpack/lib/DllReferencePlugin");

module.exports = merge(webpackCommonConf, {
  mode: "development",
  module: {
    rules: [
      {
        test: /\.js$/,
        use: ["babel-loader"],
        include: srcPath,
        exclude: /node_modules/, // 第二，不要再转换 node_modules 的代码
      },
    ],
  },
  plugins: [
    new webpack.DefinePlugin({
      // window.ENV = 'production'
      ENV: JSON.stringify("development"),
    }),
    // 第三，告诉 Webpack 使用了哪些动态链接库
    new DllReferencePlugin({
      // 描述 react 动态链接库的文件内容
      manifest: require(path.join(distPath, "react.manifest.json")),
    }),
  ],
});
```

在入口文件引入动态链接库

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Document</title>
  </head>
  <body>
    <div id="root"></div>
    <script src="./react.dll.js"></script>
  </body>
</html>
```

```tsx
// 通过react.manifest.json描述文件找到react;
import React from "react";

class App extends React.Component {
  constructor(props) {
    super(props);
  }
  render() {
    return <p>This is App Component.</p>;
  }
}

export default App;
```

#### webpack 优化构建速度（可用于生产环境）

- 优化 babel-loader
- IgnorePlugin
- noParse
- HappyPack
- ParallelUglifyPlugin

#### webpack 优化构建速度（不可用于生产环境）

- 自动刷新
- 热更新
- DllPlugin

### 优化产出代码-产品代码

- 体积更小
- 合理分包，不重复加载
- 速度更快内存使用更少

#### 小图片 base64

```js
{
  module: {
    rules: [
      {
        test: /\.(png|jpg|jpeg|gif)$/,
        use: {
          loader: 'url-loader'.
          options: {
            // 小于limit的图片会以base64格式产出，否则依然延用file-loader的形式产出url格式，以http请求的形式加载图片
            limit: 5 * 1024
            // 打包到img目录下
            outputPath: '/img1/'
          }
        }
      }
    ]
  }
}

```

#### bundle hash

使用 contentHash 文件内容 hash 缓存文件

```js
{
  output: {
    filename: "bundle.[contenthash:8].js";
  }
}
```

#### 懒加载

使用 import()引入的文件，会生成独立的 chunk

#### 提取公共代码

[抽离公共代码](#抽离公共代码)

#### IgnorePlugin

[使用 IgnorePlugin 忽略命中文件](#IgnorePlugin)

#### 使用 CND 加速

使用 CDN 加速

- 配置 publicPath
- 将静态资源部署到 CDN 服务器

```js
const CDN_PATH = 'http://cdn.adc.com'
{
  output: {
    // 修改所有打包出来的静态文件url前缀
    publicPath: CDN_PATH
  },
  module: {
    rules: [
      {
        test: /\.(png|jpg|jpeg|gif)$/,
        use: {
          loader: 'url-loader',
          options: {
            limit: 5 * 1024,
            //  设置图片的 cdn 地址
            outputPath: CDN_PATH
          }
        }
      }
    ]
  }
}

```

#### 使用 production

- 自动开启代码压缩，
  - 启用[多进程代码压缩](#ParallelUglifyPlugin)可以提高压缩速度
- Vue React 等自动删除调试代码
- 启动 Tree-Shaking：
  - webpack production 自动开启，
  - ES6 Module 才能让 tree shaking 生效，commonjs 就不行

为什么只有 EX6 module 才能 tree shaking？ES6 Module 和 Commonjs 区别如下

二者都是模块化的解决方案，前端使用 ES6 Module，node 使用 comminjs，通过 webpack 配置，前端代码也能使用 commonjs 规则

- ES6 Module 静态引入，编译时引入
- Commonjs 动态引入，执行时引入
- 只有 ES6 Module 才能静态分析，实现 Tree Shaking

#### Scope hoisting

https://segmentfault.com/a/1190000018220850

- 代码体积更小
- 创建函数作用域更少
- 代码可读性更好

```js
const ModuleConcatenationPlugin = require("webpack/lib/optimize/ModuleConcatenationPlugin");

module.exports = {
  resolve: {
    // 针对npm中的第三方模块优化采用jsnext:main 中只想的ES6模块化语法的文件
    mainFields: ["jsnext:main", "browser", "main"],
  },
  plugins: [
    // 开启Scope hoisting
    new ModuleConcatenationPlugin(),
  ],
};
```
