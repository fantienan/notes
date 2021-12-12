# react hooks 详解

[useState 的实现原理](https://juejin.cn/post/6844903975838285838)
[深入理解 React 高阶组件](https://www.jianshu.com/p/0aae7d4d9bc1)
[常用的 hooks](https://blog.csdn.net/chenzhizhuo/article/details/104159910)

面试中出现的关于 hooks 的题目

## 简单介绍下什么是 hooks，hooks 产生的背景？hooks 的优点？

- hooks 是针对在使用 react 时存在以下问题而产生的：
- 组件之间复用状态逻辑很难，在 hooks 之前，实现组件复用，一般采用高阶组件和 Render Props，它们本质是将复用逻辑提升到父组件中，很容易产生很多包装组件，带来嵌套地域。
- 组件逻辑变得越来越复杂，尤其是生命周期函数中常常包含一些不相关的逻辑，完全不相关的代码却在同一个方法中组合在一起。如此很容易产生 bug，并且导致逻辑不一致。
  复杂的 class 组件，使用 class 组件，需要理解 JavaScript 中 this 的工作方式，不能忘记绑定事件处理器等操作，代码复杂且冗余。除此之外，class 组件也会让一些 react 优化措施失效。

针对上面提到的问题，react 团队研发了 hooks，它主要有两方面作用：

- 用于在函数组件中引入状态管理和生命周期方法
- 取代高阶组件和 render props 来实现抽象和可重用性

优点也很明显：

- 避免在被广泛使用的函数组件在后期迭代过程中，需要承担一些副作用，而必须重构成类组件，它帮助函数组件引入状态管理和生命周期方法。
- Hooks 出现之后，我们将复用逻辑提取到组件顶层，而不是强行提升到父组件中。这样就能够避免 HOC 和 Render Props 带来的「嵌套地域」
- 避免上面陈述的 class 组件带来的那些问题

## 知道 hoc 和 render props 吗，它们有什么作用？有什么弊端？

Render Props 组件和高阶组件主要用来实现抽象和可重用性。
弊端就是高阶组件和 Render Props 本质上都是将复用逻辑提升到父组件中，很容易产生很多包装组件，带来的「嵌套地域」。由于所有抽象逻辑都被其他 React 组件所隐藏，应用变成了一棵没有可读性的组件树。而那些可见的组件也很难在浏览器的 DOM 中进行跟踪。

### Render Props

什么是 Render Props
render props 模式是一种非常灵活复用性非常高的模式，它可以把特定行为或功能封装成一个组件，提供给其他组件使用让其他组件拥有这样的能力。他把组件可以动态渲染的地方暴露给外部，你不用再关注组件的内部实现，只要把数据通过函数传出去就好。
使用场景：

通用业务逻辑的抽取
当两个平级组件之间需要单向依赖的时候，比如两个同级组件 A、B，A 组件需要跟随 B 组件的内部状态来改变自己的内部状态，我们就说 A 依赖 B；或者 B 依赖 A

[render props demo 参考](https://github.com/kellywang1314/react-render/blob/master/src/components/hooks/renderProps.js)

### Hoc

[hoc 的应用 demo](https://github.com/kellywang1314/react-demo-render/blob/master/src/components/hooks/hoc.js)
hoc 是 React 中用于重用组件逻辑的高级技术，它是一个函数，能够接受一个组件并返回一个新的组件。
实现高阶组件的两种方式：

- 属性代理。高阶组件通过包裹的 React 组件来操作 props
- 反向继承。高阶组件继承于被包裹的 React 组件

#### 属性代理

- 什么是属性代理

属性代理组件继承自 React.Component，通过传递给被包装的组件 props 得名

```ts
// 属性代理，把高阶组件接收到的属性传递给传进来的组件
function HOC(WrappedComponent) {
  return class PP extends React.Component {
    render() {
      return <WrappedComponent {...this.props} />;
    }
  };
}
```

- 属性代理的用途
  - 更改 props，可以对传递的包裹组件的 WrappedComponent 的 props 进行控制
  - 通过 refs 获取组件实例
  - 把 WrappedComponent 与其它 elements 包装在一起

```tsx
/*
可以通过 ref 获取关键词 this（WrappedComponent 的实例）
当 WrappedComponent 被渲染后，ref 上的回调函数 proc 将会执行，此时就有了这个 WrappedComponent 的实例的引用
*/
function refsHOC(WrappedComponent) {
  return class RefsHOC extends React.Component {
    proc(wrappedComponentInstance) {
      wrappedComponentInstance.method();
    }
    render() {
      const props = Object.assign({}, this.props, {
        ref: this.proc.bind(this),
      });
      return <WrappedComponent {...props} />;
    }
  };
}
```

#### 反向继承

反向继承是继承自传递过来的组件

```tsx
function iiHOC(WrappedComponent) {
  return class Enhancer extends WrappedComponent {
    render() {
      return super.render();
    }
  };
}
```

反向继承允许高阶组件通过 this 关键词获取 WrappedComponent，意味着它可以获取到 state，props，组件生命周期（component lifecycle）钩子，以及渲染方法（render），所以我们主要用它来做渲染劫持，比如在渲染方法中读取或更改 React Elements tree，或者有条件的渲染等。

#### 高阶组件相关的面试题

##### 这怎么在高阶组件里面访问组件实例

```tsx
function refsHOC(WrappedComponent) {
  return class RefsHOC extends React.Component {
    proc(wrappedComponentInstance) {
      wrappedComponentInstance.method();
    }
    render() {
      const props = Object.assign({}, this.props, {
        ref: this.proc.bind(this),
      });
      return <WrappedComponent {...props} />;
    }
  };
}
```

##### 你的项目中怎么使用的高阶组件

- 项目中经常存在在配置系统中配置开关/全局常量，然后在页面需要请求配置来做控制，如果在每个需要调用全局设置的地方都去请求一下接口，就会有一种不优雅的感觉，这个时候我就想到利用高阶组件抽象一下。
- 项目开发过程中，经常也会遇到需要对当前页面的一些事件的默认执行做阻止，我们也可以写一个高阶组件等。

#### hooks 和 hoc 和 render props 有什么不同？

它们之间最大的不同在于，后两者仅仅是一种开发模式，而自定义的 hooks 是 react 提供的 API 模式，它既能更加自然的融入到 react 的渲染过程也更加符合 react 的函数编程理念。

#### 介绍下常用的 hooks？

- useState()，状态钩子。为函数组建提供内部状态

```ts
// 我们实现一个简易版的 useState
let memoizedStates = []; // 多个 useState 时需要使用数组来存
let index = 0;
function useState(initialState) {
  memoizedStates[index] = memoizedStates[index] || initialState;
  let currentIndex = index;
  function setState(newState) {
    memoizedStates[currentIndex] = newState;
    render();
  }
  return [memoizedStates[index++], setState];
}
```

- useContext()，共享钩子。该钩子的作用是，在组件之间共享状态。 可以解决 react 逐层通过 Porps 传递数据，它接受 React.createContext()的返回结果作为参数，使用 useContext 将不再需要 Provider 和 Consumer。
- useReducer()，Action 钩子。useReducer() 提供了状态管理，其基本原理是通过用户在页面中发起 action, 从而通过 reducer 方法来改变 state, 从而实现页面和状态的通信。使用很像 redux
- useEffect()，副作用钩子。它接收两个参数， 第一个是进行的异步操作， 第二个是数组，用来给出 Effect 的依赖项
- useRef()，获取组件的实例；渲染周期之间共享数据的存储(state 不能存储跨渲染周期的数据，因为 state 的保存会触发组件重渲染）
  useRef 传入一个参数 initValue，并创建一个对象{ current: initValue }给函数组件使用，在整个生命周期中该对象保持不变。
- useMemo 和 useCallback：可缓存函数的引用或值，useMemo 用在计算值的缓存，注意不用滥用。经常用在下面两种场景（要保持引用相等；对于组件内部用到的 object、array、函数等，如果用在了其他 Hook 的依赖数组中，或者作为 props 传递给了下游组件，应该使用 useMemo/useCallback）
- useLayoutEffect：会在所有的 DOM 变更之后同步调用 effect，可以使用它来读取 DOM 布局并同步触发重渲染

#### 描述下 hooks 下怎么模拟生命周期函数，模拟的生命周期和 class 中的生命周期有什么区别吗？

```tsx
// componentDidMount，必须加[],不然会默认每次渲染都执行
useEffect(() => {}, []);

// componentDidUpdate
useEffect(() => {
  document.title = `You clicked ${count} times`;
  return () => {
    // 以及 componentWillUnmount 执行的内容
  };
}, [count]);

// shouldComponentUpdate, 只有 Parent 组件中的 count state 更新了，Child 才会重新渲染，否则不会。
function Parent() {
  const [count, setCount] = useState(0);
  const child = useMemo(() => <Child count={count} />, [count]);
  return <>{count}</>;
}

function Child(props) {
  return <div>Count:{props.count}</div>;
}
```

这里有一个点需要注意，就是默认的 useEffect（不带[]）中 return 的清理函数，它和 componentWillUnmount 有本质区别的，默认情况下 return，在每次 useEffect 执行前都会执行，并不是只有组件卸载的时候执行。
useEffect 在副作用结束之后，会延迟一段时间执行，并非同步执行，和 compontDidMount 有本质区别。遇到 dom 操作，最好使用 useLayoutEffect。

#### hooks 中的坑，以及为什么？

- 不要在循环，条件或嵌套函数中调用 Hook，必须始终在 React 函数的顶层使用 Hook。这是因为 React 需要利用调用顺序来正确更新相应的状态，以及调用相应的钩子函数。一旦在循环或条件分支语句中调用 Hook，就容易导致调用顺序的不一致性，从而产生难以预料到的后果。

- 使用 useState 时候，使用 push，pop，splice 等直接更改数组对象的坑，demo 中使用 push 直接更改数组无法获取到新值，应该采用析构方式，但是在 class 里面不会有这个问题。(这个的原因是 push，pop，splice 是直接修改原数组，react 会认为 state 并没有发生变化，无法更新)
  这里的坑很多的，经常出现的就是每次修改数组的时候：

```tsx
const [firstData, setFirstData]: any = useState([]);
const handleFirstAdd = () => {
  // let temp = firstData // 不要这么写，直接修改原数组相当于没有更新
  let temp = [...firstData]; // 必须这么写，多层数组也要这么写
  temp.push({ value: "" });
  setFirstData(temp);
};
```

```tsx
function Indicatorfilter() {
  let [num, setNums] = useState([0, 1, 2, 3]);
  const test = () => {
    // 这里坑是直接采用 push 去更新 num，setNums(num)是无法更新 num 的，必须使用 num = [...num ,1]
    num.push(1);
    // num = [...num ,1]
    setNums(num);
  };
  return (
    <div className="filter">
      <div onClick={test}>测试</div>
      <div>
        {num.map((item, index) => (
          <div key={index}>{item}</div>
        ))}
      </div>
    </div>
  );
}

class Indicatorfilter extends React.Component<any, any> {
  constructor(props: any) {
    super(props);
    this.state = {
      nums: [1, 2, 3],
    };
    this.test = this.test.bind(this);
  }

  test() {
    // class采用同样的方式是没有问题的
    this.state.nums.push(1);
    this.setState({
      nums: this.state.nums,
    });
  }

  render() {
    let { nums } = this.state;
    return (
      <div>
        <div onClick={this.test}>测试</div>
        <div>
          {nums.map((item: any, index: number) => (
            <div key={index}>{item}</div>
          ))}
        </div>
      </div>
    );
  }
}
```

- useState 设置状态的时候，只有第一次生效，后期需要更新状态，必须通过 useEffect

```tsx
// TableDeail 是一个公共组件，在调用它的父组件里面，我们通过 set 改变 columns 的值，以为传递给 TableDeail 的 columns 是最新的值，所以 tabColumn 每次也是最新的值，但是实际 tabColumn 是最开始的值，不会随着 columns 的更新而更新
const TableDeail = ({ columns }: TableData) => {
  const [tabColumn, setTabColumn] = useState(columns);
};

// 正确的做法是通过 useEffect 改变这个值
const TableDeail = ({ columns }: TableData) => {
  const [tabColumn, setTabColumn] = useState(columns);
  useEffect(() => {
    setTabColumn(columns);
  }, [columns]);
};
```

- 必包带来的坑，参考 demo 里面的 state 变量
  因为每次 render 都有一份新的状态，因此上述代码中的 setTimeout 使用产生了一个闭包，捕获了每次 render 后的 state，也就导致了输出了 0、1、2。如果你希望输出的内容是最新的 state 的话，可以通过 useRef 来保存 state。前文讲过 ref 在组件中只存在一份，无论何时使用它的引用都不会产生变化，因此可以来解决闭包引发的问题。
  滥用 useContent

#### useState 中的第二个参数更新状态和 class 中的 this.setState 区别？

- useState 通过数组第二个参数 Set 一个新值后，新值会形成一个新的引用，捕获当时渲染闭包里的数据 State
- setState 是通过 this.state 的读取 state,每次代码执行都会拿到最新的 state 引用

#### useEffect 和 useLayoutEffect 区别？

- useEffect 是 render 结束后，callback 函数执行，但是不会阻断浏览器的渲染，算是某种异步的方式吧。但是 class 的 componentDidMount 和 componentDidUpdate 是同步的,在 render 结束后就运行,useEffect 在大部分场景下都比 class 的方式性能更好.

- useLayoutEffect 里面的 callback 函数会在 DOM 更新完成后立即执行,但是会在浏览器进行任何绘制之前运行完成,阻塞了浏览器的绘制.
