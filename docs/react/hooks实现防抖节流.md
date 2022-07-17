## 防抖

```ts
import { useRef, useEffect, useCallback } from "react";

export const useDebounce = <
  Fn extends (...args: any) => any,
  Delay extends number,
  Dep extends any[]
>(
  fn: Fn,
  delay: Delay,
  dep?: Dep
) => {
  const storeRef = useRef<{ fn: Fn; timer?: NodeJS.Timeout }>({ fn });

  useEffect(() => {
    storeRef.current.fn = fn;
  }, [fn]);

  return useCallback((...args: Parameters<Fn>) => {
    const { current } = storeRef;
    if (current.timer) {
      clearTimeout(current.timer);
    }
    current.timer = setTimeout(() => {
      current.timer = undefined;
      current.fn.call(null, ...args);
    }, delay);
  }, dep!);
};
```

## 节流

```ts
import { useRef, useEffect, useCallback } from "react";

export const useThrottle = <
  Fn extends (...args: any) => any,
  Delay extends number,
  Dep extends any[]
>(
  fn: Fn,
  delay: Delay,
  dep?: Dep
) => {
  const storeRef = useRef<{ fn: Fn; timer?: NodeJS.Timeout }>({ fn });
  useEffect(() => {
    storeRef.current.fn = fn;
  }, [fn]);

  return useCallback((...args: Parameters<Fn>) => {
    const { current } = storeRef;
    if (!current.timer) {
      current.timer = setTimeout(() => {
        current.timer = undefined;
      }, delay);
      current.fn.call(null, ...args);
    }
  }, dep!);
};
```
