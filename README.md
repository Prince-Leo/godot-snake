# 🐍 Godot 版贪吃蛇

经典贪吃蛇游戏的 **Godot 4** 实现。

## 🎮 玩法

- **WASD** 或**方向键**控制蛇的移动
- 吃到红色食物得分，蛇身变长
- 撞墙或撞到自己则游戏结束
- 按**回车键**重新开始

## 🚀 运行

1. 下载 [Godot 4.x](https://godotengine.org/)
2. 克隆本仓库
3. 用 Godot 打开 `project.godot`
4. 按 F5 运行

## 🏗️ 项目结构

```
├── project.godot      # 项目配置
├── scenes/
│   └── main.tscn      # 主场景
├── scripts/
│   ├── main.gd        # 主逻辑（分数、UI）
│   ├── snake.gd       # 蛇（移动、碰撞、增长）
│   └── food.gd        # 食物（随机生成）
└── .gitignore
```

## 📝 License

MIT
