---
layout: post
title: "[A]RTS 数据结构的基石3"
date: 2025-03-08
categories: []
tags: [ARTS]
---
## 树与递归

我们在[基石1](/a-rts_w2_data_structions)和[基石2](a-rts_w3_data_structions2)中探讨了线性结构链表和数组，这周开始讨论一种非线性结构**树**。

树结构是结点之间的“分支”关系，就像树🌲从芽点发出新的枝干一样。

树的**形式化定义**是具有**一个或多个**结点的有限集合$T$，使得
* 有一个作为树根的特定结点$root$。
* 剩下的结点，被划分结点$m \gt =0$个不相交的集合$T_i...T_m$，并且这个集合中的每一个都是树，并且这些
结点$T_i...T_m$被称为根的子树。

上述定义可以得到一些关于**树的性质**。
1. 树的每一个结点都是包含在树中的某棵子树的根
2. 一个结点的子树个数称之为这个结点的**度（degree）**
3. **度为零**的结点是这个树的**叶子结点（leaf）**或者**终端结点（terminal node）**
4. **非叶子结点**的被称之为**分支结点（branch node）**
5. 一颗树的**层**，**root结点为第0层**，其他结点都比包含它的结点的root子树对应的层大一

树的表达方式有很多，这篇文章会使用传统**根在上叶子在下**的方式绘制图像，也会提出一种**嵌套括号**的代码表示方式。

<pre class="mermaid" style="text-align: center;">
graph TD
    A ---> B
    A ---> C
    B --> E
    B --> D
    C --> F
    C --> G
    C --> H
    G --> I

    class C,D blueNode;
    class E,F greenNode
    classDef blueNode fill:#aaaaff,stroke:#0000ff,stroke-width:2px;
    classDef greenNode fill:#aaccff,stroke:#00ffff,stroke-width:2px;
</pre>

## 二叉树
**二叉树**是我们主要关注的树结构。在二叉树中，每个结点最多有两颗子树，在只有一颗子树的时候需要区分左右子树。
二叉树的结点可以是一个**有限集合**，这个集合可以是**空集**。二叉树由一个根结点和两棵作为该根结点的左右子树的二叉树（这两个二叉树不相交）

二叉树并不是树的特殊情况，而是一种完全不同的概念。

二叉树的一些**性质**
1. 二叉树可以是一个空集
2. 二叉树同样的集合，也可以因为左右子树位置不同而不是同样的二叉树

如下使用一种字符串表达方式来表示二叉树，之后我会在代码中使用这样的方式创建实验数据
```c
char *str = "5(4(2,3),7(0,9(8,10)))";
```
## 二叉树遍历
非常多的算法都需要走遍一棵树，不多不少的遍历树的每一个结点有3种方案，前、中、后序遍历,
遍历方案让我们可以在谈论一棵树的结点的时候可以通过上一个和下一个结点来讨论。

这里有个可以强调的地方二叉树的x序遍历的x代表的是**根结点**被遍历的顺序，前则是先遍历根，依次是中间遍历根和最后遍历根。左右子树的遍历从来都是先左后右。
## 前序遍历（preorder）

先访问根结点，遍历左子树，遍历右子树
## 中序遍历（inorder）
先访问左子树，访问根，遍历右子树
## 后序遍历（postorder）
先访问左子树，遍历右边子树，访问根

## 层序遍历
层序遍历是通过一个队列或者栈的数据结构来跟踪每层的结点，我在下面的题目里也会用到类似的手段

---

大概了解树和二叉树后我们来通过几个题目看看怎么处理树的问题
===

## [leetcode 226 反转二叉树](https://leetcode.com/problems/invert-binary-tree/)
这代码非常简单，只是在后序遍历的基础上递归的替换左右子树的位置。
```c
node_t *invertTree(node_t *root)
{
        if (!root) {
                return NULL;
        }

        node_t *left  = invertTree(root->left);

        node_t *right = invertTree(root->right);

        root->left = right;
        root->right = left;

        return root;
}
```
如果你对这个代码有疑惑你可能需要了解一下关于递归的事情。

## [leetcode 116 Populating Net Right Pointers in Each Node](https://leetcode.com/problems/populating-next-right-pointers-in-each-node/description/)
我们继续解这个问题。
这个题目的难度也不是很大，题目要求我们保持前序遍历的顺序。自然可以想到使用前序遍历的逻辑先遍历整个树。
![tree](/assets/20250314_leetcode116.jpg)
题目要求构造一棵新的树，很自然的就能注意到，给出的函数签名是没法使用的。这时候可以思考一下这个问题是不是一个递归子问题，
一棵树想要flatten，就等于这个棵树的左子树的flatten连接右子树的flatten就好了。

所以这个问题是有递归子问题的，当碰到叶子结点的时候就返回结点本身并停止递归。
我如下代码就是基于如此概念写下来的。
```c
node_t *connect(node_t *node1, node_t *node2)
{
        if (!node1) {
                return node2;
        } else if (!node2) {
                return node1;
        }
        if (node1 && node2) {
                node_t *curr = node1;
                while (curr->right)
                        curr = curr->right;
                curr->right = node2;
                return node1;
        }
        return NULL;
}

node_t *flatten_tree(node_t *root)
{
        if (!root) {
                return NULL;
        }
        node_t *left = root->left;
        node_t *right = root->right;
        if (left || right) {
                root->right = connect(flatten_tree(left), flatten_tree(right));
                root->left = NULL;
        }
        return root;
}

void flatten(node_t *root)
{
        if (!root)
                return;
        flatten_tree(root);
}
```
了解了这一种解法，我们一起看一下别的解法

```c
void flatten(struct TreeNode* root) {
    if (root) {
        /* Move the left node to the right node */
        struct TreeNode* temp = root->right;
        root->right = root->left;
        root->left = NULL;
        struct TreeNode* node = root;
        
        /* Move to the end of the prev left node which is the new right node */
        while (node->right) {
            node = node->right;
        }
        
        /* Append the right node to its end */
        node->right = temp;
        
        flatten(root->right); 
    }
    return;
}
```
这个解法的逻辑和我上文的写法差不多，我上文的写法很清楚。

下一个解法
```c
struct Stack
{
    struct TreeNode* arr[2000];
    int top;
};

void push(struct Stack* s, struct TreeNode* node)
{
    s->arr[++(s->top)] = node;
}

struct TreeNode* pop(struct Stack* s)
{
    return s->arr[(s->top)--];
}

void stackNodes(struct Stack* s, struct TreeNode* root)
{
    if(root==NULL)
        return;
    push(s, root);
    stackNodes(s, root->left);
    stackNodes(s, root->right);
}

void flatten(struct TreeNode* root) {
    if(root==NULL)
        return;
    struct Stack s;
    s.top = -1;
    stackNodes(&s, root);
    struct TreeNode* curr = pop(&s);
    struct TreeNode* temp = NULL;
    curr->left = NULL;
    curr->right = temp;
    while((s.top)>-1)
    {
        temp = curr;
        curr = pop(&s);
        curr->left = NULL;
        curr->right = temp;
    }
}
```
这个逻辑简单说就是使用前序遍历把树的结点放入栈中，然后压出栈来处理。其实无论是第一种还是第二种情况都是一种隐式的使用
栈的，他们使用的是调用栈来保存信息。所以这三者看似不同其实核心逻辑几乎相同。

## [leetcode 654 Maximum Binary tree](https://leetcode.com/problems/maximum-binary-tree/description/) 
这个很简单，没什么需要聊的，处理好左右子树就可以递归的解决了。
```c
int find_bigest(int *nums, int numsSize)
{
        int big_index = 0;
        int i = 0;
        for (; i < numsSize; i++) {
                if (nums[i] > nums[big_index]) {
                        big_index = i;
                }
        }
        return big_index;
}

node_t *constructMaximumBinaryTree(int *nums, int numsSize)
{
        if (numsSize == 0) {
                return NULL;
        }
        int index = find_bigest(nums, numsSize);
        node_t *res = malloc(sizeof(node_t));
        int *val = malloc(sizeof(int));
        *val = (int) nums[index];

        if (numsSize <= 1) {
                res->value = val;
                return res;
        } else {
                int *left_nums = nums;
                int left_size = index;
                int *right_nums = nums + index + 1;
                int right_size = numsSize - left_size - 1;

                res->value = val;
                res->left = constructMaximumBinaryTree(left_nums, left_size);
                res->right = constructMaximumBinaryTree(right_nums, right_size);

                return res;
        }
}
```

下面是更快的算法。我们试着分析一下，

```c
struct TreeNode* constructMaximumBinaryTree(int* nums, int numsSize) {
    struct TreeNode* root = calloc(1, sizeof(struct TreeNode));
    struct TreeNode* curr = root ;

    root->val = *nums;
    root->left = NULL;
    root->right = NULL;

    for (int i = 1; i < numsSize; i++) {
        int val = *(nums + i);
        if (val > root->val) {
            struct TreeNode* node = calloc(1, sizeof(struct TreeNode));
            node->val = val;
            node->left = root;
            node->right = NULL;
            root = node;
        } else {
            bool updated = false;
            curr = root;
            while (curr->right != NULL) {
                if (val > curr->right->val) {
                    struct TreeNode* node = calloc(1, sizeof(struct TreeNode));
                    node->val = val;
                    node->left = curr->right;
                    node->right = NULL;
                    curr->right = node;
                    updated = true;
                    break;
                } else {
                    curr = curr->right;
                }
            }
            if (!updated) {
                struct TreeNode* node = calloc(1, sizeof(struct TreeNode));
                node->val = val;
                node->left = NULL;
                node->right = NULL;
                curr->right = node;
            }
        }
    }

    return root;

}
```
## [leetcode 105 Construct Binary Tree from Preorder and Inorder Traversal](https://leetcode.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/)
这题很有趣，通过前序遍历和中序遍历，感受不同种遍历的位置关系存储的不同。
1. 为什么单一遍历的串没法唯一的返回一个树?
2. 前序遍历和中序遍历有什么特点?

```c
node_t *buildTree(int *preorder,
                  int preorderSize,
                  int *inorder,
                  int inorderSize)
{
        if (preorderSize <= 0) {
                return NULL;
        }
        node_t *last_node = NULL;
        node_t *root = calloc(1, sizeof(node_t));
        int *rval = malloc(sizeof(int));
        *rval = preorder[0];
        root->value = rval;

        int index = 0;
        for (int i = 0; i < inorderSize; i++) {
                if (inorder[i] == *rval) {
                        index = i;
                        break;
                }
        }
        int *l_preo = preorder + 1;
        int l_preo_sz = index;

        int *r_preo = preorder + index + 1;
        int r_preo_sz = preorderSize - index - 1;

        int *r_inordero = inorder + index + 1;
        int r_inorder_sz = inorderSize - index - 1;

        root->left = buildTree(l_preo, l_preo_sz, inorder, index);
        root->right = buildTree(r_preo, r_preo_sz, r_inordero, r_inorder_sz);
        return root;
}
```

## [leetcode_106 Construct Binary Tree from Inorder and Postorder Traversal][](https://leetcode.com/problems/construct-binary-tree-from-inorder-and-postorder-traversal/)
这道题是用后序遍历和中序遍历来构造，逻辑差不多，三种遍历构造结束之后会一起说。
```c
node_t *buildTree(int *inorder,
                  int inorderSize,
                  int *postorder,
                  int postorderSize)
{
        if (inorderSize == 0)
                return NULL;
        node_t *root = calloc(1, sizeof(node_t));
        int *valp = malloc(sizeof(int));
        *valp = postorder[postorderSize - 1];
        root->value = valp;

        int index = 0;
        for (int i = 0; i < inorderSize; i++) {
                if (inorder[i] == *valp) {
                        index = i;
                        break;
                }
        }
        int *r_in = inorder + (index + 1);
        int r_insz = inorderSize - index - 1;

        int *r_post = postorder + index ;
        int r_postsz = postorderSize - index - 1;

        int *l_in = inorder;
        int l_insz = index;

        int *l_post = postorder;
        int l_postsz = index;
        root->right = buildTree(r_in, r_insz, r_post, r_postsz);
        root->left = buildTree(l_in, l_insz, l_post, l_postsz);
        return root;
}
```
## [leetcode 889 Construct Binary Tree from Preorder and postorder Traversal](https://leetcode.com/problems/construct-binary-tree-from-preorder-and-postorder-traversal/)

```c
node_t *constructFromPrePost(int *preorder,
                             int preorderSize,
                             int *postorder,
                             int postorderSize)
{
        if (postorderSize == 0)
                return NULL;
        node_t *root = calloc(1, sizeof(node_t));
        int *valp = malloc(sizeof(int));
        *valp = postorder[postorderSize - 1];
        root->value = valp;

        if (postorderSize == 1) {
                root->left = NULL;
                root->right = NULL;
                return root;
        }
        int right_val = postorder[postorderSize - 2];
        int index = 0;
        for (int i = 0; i < preorderSize; i++) {
                if (preorder[i] == right_val) {
                        index = i;
                        break;
                }
        }
        int *l_pre = preorder + 1;
        int l_pre_sz = index - 1;
        int *l_post = postorder;
        int l_post_sz = index - 1;

        int *r_pre = preorder + index;
        int r_pre_sz = preorderSize - index;
        int *r_post = postorder + (index - 1);
        int r_post_sz = postorderSize - index;

        root->left = constructFromPrePost(l_pre, l_pre_sz, l_post, l_post_sz);
        root->right = constructFromPrePost(r_pre, r_pre_sz, r_post, r_post_sz);
        return root;
}
```
以上三个题目分别使用遍历信息得出一棵树，前序+中序、后序+中序都是可以得到唯一的树，
但前序+后序是没法得出唯一的树。
前序和后序遍历是没法把确认左右子树的，唯有中序遍历可以分辨左右子树。所以前序和后序遍历没法唯一确定一个树。



## [leetcode_912 sort an array](https://leetcode.com/problems/sort-an-array/description/)
这题的难点是使用时间复杂度小于$\mathcal{O}(nlog(n))$的排序算法
这题我使用merge sort来演示，merge sort本质上是在问题域中使用缩小问题的方式，把待处理的数据以树的结构分解，之后再依次合并，这样可以有效的控制时间复杂度再目标以内。

```c
int *sort(int *left, int left_sz, int *right, int right_sz)
{
        int res_sz = left_sz + right_sz;
        int *res = calloc(res_sz, sizeof(int));
        int res_count = 0;

        int i = 0;
        int j = 0;

        while (i < left_sz || j < right_sz) {
                if (i == left_sz) {
                        while (j < right_sz) {
                                res[res_count] = right[j];
                                res_count++;
                                j++;
                        }
                        return res;
                } else if (j == right_sz) {
                        while (i < left_sz) {
                                res[res_count] = left[i];
                                res_count++;
                                i++;
                        }
                        return res;
                }

                if (left[i] < right[j]) {
                        res[res_count] = left[i];
                        res_count++;
                        i++;
                } else {
                        res[res_count] = right[j];
                        res_count++;
                        j++;
                }
        }

        return res;
}

int *merge_sort(int *nums, int size)
{
        if (size == 0)
                return NULL;
        int *res = NULL;
        if (size == 1) {
                /* int *res = calloc(1, sizeof(int)); */
                /* *res = *nums; */
                /* return res; */
                return nums;
        }
        int mid = size / 2;

        int left_sz = mid;
        int right_sz = size - mid;
        int *left = merge_sort(nums, left_sz);
        int *right = merge_sort(nums + mid, right_sz);

        res = sort(left, left_sz, right, right_sz);

        return res;
}

int *sortArray(int *nums, int numsSize, int *returnSize)
{
        int *res = merge_sort(nums, numsSize);
        *returnSize = numsSize;
        return res;
}
```
merge sort没有什么难点，从代码形式上看merge sort是一种对问题树的后序遍历。这个算法的关键是有序数组的合并。

## 二叉搜索树
二叉搜索树（binary search tree）也就是**二叉查找树**。这个树类型是在二叉树性质的基础上
增加了3个新性质。
1. 若任意结点的左子树不空，则左子树的所有结点的值均小于它的根结点的值；
2. 若任意结点的右子树不空，则右子树的所有结点的值均大于它的根结点的值；
3. 任意机电的左右子树都分别是二叉查找树。

这三个性质为了让数据的查找和插入时间为$\mathcal{O}(log_n)$。与之前我们聊过的[二分搜索](/a-rts_w3_data_structions2#binary_search)类似
二叉搜索树是把二分搜索的逻辑显式的嵌入了数据结构中，如此这样大幅下降了查找和插入的时间。值的一提的是一些抽象数据结构也是由这个基本数据结构
所构成的比如集合、multiset、dictionary。

<div style="background-color:#d0e7f9; color:#4d4d4d; padding:10px; border-radius:5px;">
这里可以给我一些想法，我对数据结构的理解有了不同的角度，数据结构如果从性质入手来实现也许不是很直观，但把数据结构再解构，从数据解构的查找，插入，删除，修改这几个方面
来想很多数据结构就很容易处理了。比如如果我需要实现dictionary，也许一个hash
table就可以处理，但是把字典这个数据解构分解，其实只是需要找到一种方案插入和查找字典中的元素就可以了
</div>
二叉查找树性质非常完美，但如果你需要对这个数据结构进行修改(比如插入或者删除某些数据)，那就有可能会让这个特征消失从而增加各项操作的时间，它的最坏情况也很好理解，通过一系列运算让整个
数据结构变成一个链表所以最差的情况是$\mathcal{O}(n)$。为了对抗这个衰变之后又出现了[AVL树](#avl_tree)、[红黑树](#red_black_tree)、 [跳表](#jump_table)、 [B树](#b_tree)一系列的数据解构来解决.


## AVL树 {#avl_tree}
## 红黑树 {#red_black_tree}
## 跳表 {#jump_table}
## B tree {#b_tree}

## 引用
[数据结构的网站](https://epaperpress.com/sortsearch/has.html)

## 后
这周有些不舒服，没有完成树的很多背景知识，二叉搜索树和别的树的介绍得下周才行了。
这周只是介绍了二叉树的遍历方式，如果让我一句话概括一下，树和递归有很强的联系，从某种程度上说，递归本身就是一种树。
树相关的题目难度很低，基本上可以通过遍历树的方式和建立递归，这两种方式解决。下周会详细介绍更多的树的类型，他们各自有各自的
性质，这些性质保证了算法的性质。需要的是理解这些性质。

Sun Mar 16 10:26:58 PM CST 2025
