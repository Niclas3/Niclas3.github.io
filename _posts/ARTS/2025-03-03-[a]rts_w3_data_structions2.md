---
layout: post
title: "[A]RTS 数据结构的基石2"
date: 2025-03-03
categories: []
tags: [ARTS]
---

## 数据结构的基石2

我们在上一篇文章里探讨了一些以链表为主的线性表的算法，这周我们会继续探讨数组和树这
两个数据结构。

## 数组

数组和链表都是一种线性表，但是他们的静态表现不同。数组是紧密排列的内存区域，而链表
是随机排布的内存。【这里其实是有原因的，磁鼓存储】

关于数组的使用，关键在与其指针的运用。这里引入一个滑动窗口问题来介绍。

## 发现滑动窗口
在讨论滑动窗口之前，我们先看看，使用滑动窗口的场景有什么特点？
用一个leetcode的题目来看看。

## [leetcode 76 Minimum window Substring](https://leetcode.com/problems/minimum-window-substring/description/)
这题是从一个字符串里找到最短的包含指定字符的字符串。

比如目标字串 **s="ADOBECODEBANC"**, 指定的字符是 **t="ABC"**
那么答案就是 **BANC**

讨论这个问题的时候，很容易就想到使用两个指针来创造一个窗口来判断这个窗口的字符串是否符合要求。
我们先根据这个朴素的逻辑写一个代码。

```c
void set_key(int *map, char c)
{
        map[c - 'A'] += 1;
}

int get_key(int *map, char c)
{
        return map[c - 'A'];
}

bool has_target_char(int from, int to, char *s, char *t)
{
        int map[24] = {0};
        for (int n = from; n <= to; n++) {
                for (int i = 0; i < strlen(t); i++) {
                        if (s[n] == t[i]) {
                                set_key(map, s[n]);
                        }
                }
        }
        bool res = true;
        for (int i = 0; i < strlen(t); i++) {
                res = res && (map[t[i] - 'A'] ? true : false);
        }
        return res;
}

void print_range_str(int from, int to, char *s)
{
        for (int i = from; i <= to; i++) {
                printf("%c ", s[i]);
        }
}

char *minWindow(char *s, char *t)
{
        int s_len = strlen(s);
        int t_len = strlen(t);

        for (int i = 0; i < s_len; i++) {
                for (int j = i + 1; j < s_len; j++) {
                        bool find_string = has_target_char(i, j, s, t);
                        if (find_string) {
                                print_range_str(i, j, s);
                                printf("\n");
                        }
                }
        }
}
```

这样如上代码所演示的逻辑。我们挑一个来解释。
当s=ADOBECODEBANC
i=0,j=0
t=ABC

大概当j=5的时候ABC的target就都被满足了，这时候就找到了指定字符。这样就只要把所有字符串
挑短的留下来，这样就能找到最短的情况

来算一下这个函数的时间复杂度看看

`has_target_char(from,to,s,t)`
$ \mathcal{O}(w \times |t|) $

`minWindow(s,t)`
$\mathcal{O}(|s| \times |t|)\times \mathcal{O}(|s|^2)$
```
01. A D O B E C 
02. A D O B E C O 
03. A D O B E C O D 
04. A D O B E C O D E 
05. A D O B E C O D E B 
06. A D O B E C O D E B A 
07. A D O B E C O D E B A N 
08. A D O B E C O D E B A N C 
09.   D O B E C O D E B A 
10.   D O B E C O D E B A N 
11.   D O B E C O D E B A N C 
12.     O B E C O D E B A 
13.     O B E C O D E B A N 
14.     O B E C O D E B A N C 
15.       B E C O D E B A 
16.       B E C O D E B A N 
17.       B E C O D E B A N C 
18.         E C O D E B A 
19.         E C O D E B A N 
20.         E C O D E B A N C 
21.           C O D E B A 
22.           C O D E B A N 
23.           C O D E B A N C 
24.             O D E B A N C 
25.               D E B A N C 
26.                 E B A N C 
27.                   B A N C 
```
想想看这个思路重复计算了什么？比如如果我们需要的是最小的串那在我们发现
ADBEC后的所有串都是不需要的但是这个方法是必须把这些串都算完才能找下一组。
也就是说在发现一个串之后，应该立刻break当前循环，continue外层循环。
```c
char *minWindow(char *s, char *t)
{
        int s_len = strlen(s);
        int t_len = strlen(t);

        for (int i = 0; i < s_len; i++) {
                for (int j = i + 1; j < s_len; j++) {
                        bool find_string = has_target_char(i, j, s, t);
                        if (find_string) {
                                print_range_str(i, j, s);
                                printf("\n");
                                break;
                        }
                }
        }
}
```
修改之后得出的数据明显少了很多。这样相当于只调控右边的指针让右边指针及时退出，明显
还可以通过调整左边的指针来让数据变更少。
```
1. A D O B E C 
2.   D O B E C O D E B A
3.     O B E C O D E B A
4.       B E C O D E B A
5.         E C O D E B A
6.           C O D E B A
7.             O D E B A N C
8.               D E B A N C
9.                 E B A N C
10.                  B A N C
```
经过观察你可以发现第二次的数据的最右边都是target数组里的字符 。
2-6和7-10都是同一个字串的简化。所以其实同样的，在确定右边指针后就可以调整左边指针来寻找最好数据。
滑动窗口，几乎要被发明出来了。

## 滑动窗口
很自然的我们发现如果有一个既可以控制左边指针又能控制右边指针的算法，就能再一次简化搜索范围。

## 滑动窗口的算法
1. 首先需要left-right指针这两个指针构成我们需要的窗口。

2. 通过循环增加right指针从而扩大窗口，直到在窗口中看到所有目标元素。

3. 窗口包含所有目标元素后，right指针停止扩大，增加left指针，从而缩小窗口直到窗口中的字符串不符合要求

4. 重复2.3.步骤，直到right到达字符串的末尾

如下是我给出的一个C的方案。

```c
void set_key(int *map, char c)
{
        map[c - 'A'] += 1;
}

static inline bool has_target_char_map(int from, int to, char *s, char *t, int *map)
{
        /* int map[24] = {0}; */
        // test [from, to] range
        if (to < from)
                return false;
        if (((to - from) + 1) < strlen(t))
                return false;

        int t_len = strlen(t);

        int target_map[MAP_SIZE] = {0};
        for (int i = 0; i < t_len; i++) {
                set_key(target_map, t[i]);
        }

        memset(map, 0, sizeof(typeof(map[0])) * MAP_SIZE);

        for (int n = from; n <= to; n++) {
                for (int i = 0; i < strlen(t); i++) {
                        if (s[n] == t[i]) {
                                set_key(map, s[n]);
                                break;
                        }
                }
        }

        bool res = true;
        for (int i = 0; i < MAP_SIZE; i++) {
                if (target_map[i] <= map[i]) {
                        res = res && true;
                } else {
                        res = res && false;
                        break;
                }
        }
        return res;
}

char *range_str(int from, int to, char *s)
{
        int len = strlen(s);
        if (to == (len - 1)) {
                return s + from;
        }
        if (to+ 1 <= len - 1) {
                s[to + 1] = '\0';
                return s+from;
        }
        return "";
}

char *minWindow_opt(char *s, char *t)
{
        int s_len = strlen(s);
        int t_len = strlen(t);
        if (t_len > s_len)
                return "";
        // 这里的left和right构成了一个窗口
        int left = 0;
        int right = left;

        // map负责记录当前的窗口的字符串有没有满足字符串t要求
        int map[MAP_SIZE] = {0};
        // lastmap是为了记录上一个满足要求的字符串
        int last_map[MAP_SIZE] = {0};

        // 为了记录最短的窗口
        int shortest_left = 0;
        int shortest_right = s_len - 1;
        
        // 右边的指针从0的位置开始到目标s字符串结束为止
        // 大多数情况right会遍历完字符串
        for (; right < s_len;) {
                // hastargetcharmap函数判断当前的窗口是否满足字符串t的要求
                bool find = has_target_char_map(left, right, s, t, map);
                if (find) {
                // 如果满足要求，就需要缩小left的窗口，即left++
                        do {
                            // 保存这个满足要求的map到lastmap
                                memcpy(last_map, map, sizeof(int) * MAP_SIZE);
                            // 这里判断一下当前这个满足要求的窗口是不是最小的窗口
                            // 如果比最小的窗口还要小那么就记录下来
                                if (right - left <
                                    shortest_right - shortest_left) {
                                        shortest_left = left;
                                        shortest_right = right;
                                }
                            // 如果left==right且他们也是满足要求的字符串说明就是他们
                                if (left == right)
                                        return range_str(left, right, s);
                            // 缩小left窗口
                                left++;
                            // 判断缩小后的窗口是不是满足要求，如果满足就继续缩小
                        } while (has_target_char_map(left, right, s, t, map));
                }
                // left缩小窗口后没有满足要求，就需要扩大窗口，直到字符串末尾
                right++;
        }

        bool res = true;
        for (int i = 0; i < strlen(t); i++) {
                res = res && (last_map[t[i] - 'A'] ? true : false);
        }

        return res ? range_str(shortest_left, shortest_right, s) : "";

        return range_str(shortest_left, shortest_right, s);
}
```
下面修改过的方案，可以发现这个方案还是没法通过leetcode最后结构test case
这时候我们可以通过算函数的时间复杂度来判断如何修改策略。
```c
#define MAP_SIZE 128

#define set_key(map, c) map[c - 'A'] += 1;

int get_key(int *map, char c)
{
        return map[c - 'A'];
}

static inline bool has_target_char_map(int from,
                                       int to,
                                       char *s,
                                       char *t,
                                       int t_len,
                                       int *target_map)
{
        /* int map[24] = {0}; */
        // test [from, to] range
        int map[MAP_SIZE] = {0};
        if (to < from)
                return false;
        if (((to - from) + 1) < t_len)
                return false;

        for (int n = from; n <= to; n++) {
                for (int i = 0; i < t_len; i++) {
                        if (s[n] == t[i]) {
                                set_key(map, s[n]);
                                break;
                        }
                }
        }

        bool res = true;
        for (int i = 0; i < MAP_SIZE; i++) {
                if (target_map[i] <= map[i]) {
                        res = res && true;
                } else {
                        res = res && false;
                        break;
                }
        }
        return res;
}

char *range_str(int from, int to, char *s, int len)
{
        if (to == (len - 1)) {
                return s + from;
        }
        if (to + 1 <= len - 1) {
                s[to + 1] = '\0';
                return s + from;
        }
        return "";
}

char *minWindow_opt(char *s, char *t)
{
        int s_len = strlen(s);
        int t_len = strlen(t);
        if (t_len > s_len)
                return "";
        int left = 0;
        int right = left;


        int shortest_left = 0;
        int shortest_right = INT_MAX;

        int target_map[MAP_SIZE] = {0};
        for (int i = 0; i < t_len; i++) {
                set_key(target_map, t[i]);
        }

        for (; right < s_len;) {
                while (
                    has_target_char_map(left, right, s, t, t_len, target_map)) {
                        if (left == right)
                                return range_str(left, right, s, s_len);
                        if (right - left < shortest_right - shortest_left) {
                                shortest_left = left;
                                shortest_right = right;
                        }
                        left++;
                }
                right++;
        }

        if (shortest_right == INT_MAX) {
                return "";
        }
        printf("%d %d\n", shortest_left, shortest_right);
        return range_str(shortest_left, shortest_right, s, s_len);
}
```

`has_target_char_map(from,to,s,t,t_len,target_map)` $ \mathcal{O}( (to-from) \times tlen + mapsize)$
`minWindow_opt(s,t)` $\mathcal{O}(slen) \times \mathcal{O}( (to-from) \times tlen + mapsize) $

整体应该是  $\mathcal{O}(N \times K \times M)$


下面会给出一个更简单效率更高的方案，我通过分析他们的不同来写出滑动窗口需要关注的点。
```go
char *minWindow_opt_2(char *s, char *t)
{
        int need[128] = {0};
        int window[128] = {0};
        int m = strlen(s);
        int n = strlen(t);


        for (int i = 0; i < n; i++) {
                need[t[i]]++;
        }

        int k = -1;
        int mi = m + 1;
        // 这里有个关键就是怎么判断当前窗口的字符串已经是合适的字符串了
        // 这里使用了cnt变量来控制。
        // 假设 t=ABC 如果一个字符串str完全包含这三个字符，我只需要在str有相关
        // 字符出现的时候增加cnt的值就行了，即使存在t = AA两个字符相同，也可以通过
        // 判断need和window中实际字符对应的个数来判断。
        // 
        // cnt更像是一个检查记录，维护这个记录就不需要像上面那个代码一样遍历整个map
        // 
        int cnt = 0;

        int left = 0;
        int right = 0;

        for (; right < m; right++) {
                char c = s[right];

                window[c]++;
                if (window[c] <= need[c]) {
                        cnt++;
                }
                while (cnt == n) {
                        if ((right - left + 1) < mi) {
                                mi = right - left + 1;
                                k = left;
                        }

                        c = s[left];
                        if (window[c] <= need[c]) {
                                cnt--;
                        }
                        window[c]--;
                        left++;
                }
        }
        if (k < 0) {
                return "";
        }
        return range_str(k, k + mi-1, s, m);
}
```
整体应该是  $\mathcal{O}(N \times M)$ 因为只有两个嵌套循环。


