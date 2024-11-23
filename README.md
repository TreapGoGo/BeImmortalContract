# BeImmortal

<center>
链接生死，
</center>

## 简介

**BeImmortalHospice** 是一个基于以太坊智能合约的纪念服务平台，用于记录逝者的个人信息、遗言、见证人信息以及用户的祝福与悼词。通过区块链技术，确保数据的透明性、安全性以及不可篡改性，让逝者的意志在区块链上永存。

## 合约功能

### 主要功能

1. **创建遗产信息**：
   - 添加逝者的姓名、钱包地址、出生日期、遗言和见证人信息。
   - 确保唯一性，不允许重复创建。

2. **更新遗言**：
   - 遗言可以由逝者本人或见证人更新。

3. **确认死亡**：
   - 仅允许见证人确认逝者是否已离世。

4. **评论功能**：
   - 用户可以为逝者添加评论，形成纪念留言墙。

5. **删除遗产记录**：
   - 逝者本人可以删除自己的记录。

6. **查询遗产信息**：
   - 提供多种查询接口，包括逝者的姓名、钱包地址、出生日期、遗言、见证人信息、生命状态和评论。

---

## 部署与使用说明

### 部署环境要求

- Solidity 版本：^0.8.28
- 以太坊钱包（如 MetaMask）连接测试网或主网。

### QuickStart

```bash
git clone https://github.com/TreapGoGo/BeImmortalContract.git
forge build
forge script script/DeployBeImmortalHospice.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $SEPOLIA_PRIVATE_KEY --broadcast --verify
```