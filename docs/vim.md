# 快捷键

- 保存并退出： :wq
- 强制退出：:q!
- normal 模式：esc / ctrl + [
- insert 模式：i
- 光标前插入：i
- 光标后插入：a
- 光标移动到行首插入：I
- 光标移动的行尾插入：A
- 光标移动到行首：H
- 光标移动到行尾：L
- 光标移动到行前：O
- 光标移动到行后：o
- 复制当前行：yy
- 删除或剪切当前行: dd
- 粘贴到行前：P
- 粘贴到行后：p

# 语法

> 操作符 + 动作(范围)

# 操作

- 操作符：
  - 删除: d
  - 删除并进入 insert 模式：c
  - 复制：y
- 从光标位置删除到行首：d + 0
- 从光标位置删除到行尾：d + g\_
- 删除光标后的一个字符：d + k
- 删除光标前的一个字符：d + h
- 删除光标前以及上一行：d + k
- 删除光标后以及下一行：d + j

# 基于单词和字串的移动

- 移动到单词的结尾：e
- 移动到上一个单词结尾：ge
- 移动到上一个单词开头：b
- 移动到下一个单词开头：w
- 删除光标右侧的单词并进入 insert 模式：c + e
- 删除光标右侧单词：d + e
- 在当前单词结尾处添加：e + a
- 在当前单词开头处添加：b + i