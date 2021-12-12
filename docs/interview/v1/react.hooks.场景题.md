# React Hooks 场景题

## 使用 hooks 实现一个计时器？

```tsx
const Demo = () => {
  const [count, setCount] = useState(0);
  const timer = useRef<null>();
  const intervalRef = useRef<any>();
  intervalRef.current = useCallback(() => {
    setCount(count + 1);
  }, [count]);
  const handleStop = () => {
    clearInterval(timer);
  };
  useEffect(() => {
    timer = setInterval(() => intervalRef.current(), 1000);
    return () => {
      clearInterval(timer);
    };
  }, []);
  return (
    <>
      <div>{count}</div>
      <button onClick={handleStop}>停止计时</button>
    </>
  );
};
```

## 使用 hooks 实现自定义 hooks, 一个计算组件从挂载到卸载的时间？（demo，hooks 抽取公共逻辑的应用）

## 输出的值

```tsx
class Index extends React.Component<any, any> {
  constructor(props) {
    super(props);
    this.state = {
      number: 0,
    };
  }
  handerClick = () => {
    for (let i = 0; i < 5; i++) {
      setTimeout(() => {
        this.setState({ number: this.state.number + 1 });
        console.log(this.state.number);
      }, 1000);
    }
  };

  render() {
    return (
      <div>
        <button onClick={this.handerClick}>num++</button>
      </div>
    );
  }
}
```

```tsx
function Index() {
  const [num, setNumber] = React.useState(0);
  const handerClick = () => {
    for (let i = 0; i < 5; i++) {
      setTimeout(() => {
        setNumber(num + 1);
        console.log(num);
      }, 1000);
    }
  };
  return <button onClick={handerClick}>{num}</button>;
}
```
