## diff 算法概述

- diff 即对比，是一个广泛的概念，日 linux diff 命令，git diff 等
- 两个 js 对象可以做 diff，如[jiff](https://github.com/cujojs/jiff)
- 两棵树做 diff， 如 vdom diff

## diff 时间复杂度

> 树 diff 的时间复杂度从 O(n^3)（是不可用的），优化时间复杂度到 O(n)（是可用的）

- 只比较同一级别，不跨级比较
- tag 不相同则直接删除重建，不做深度比较
- tag 和 key，两者都相同，则认为是相同节点，不做深度比较
