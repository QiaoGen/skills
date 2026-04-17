# WeChat Command Examples

These are suggested remote command styles for a future WeChat gateway.

## Project selection
```text
项目 TorchVision
```

## Analysis only
```text
项目 TorchVision，只分析，不改代码
```

## Enter implementation stage
```text
项目 JiNanPack，进入实施阶段，继续当前计划
```

## Force adversarial review
```text
项目 TorchVision，先做对抗评审，再汇总给我审阅
```

## Ask for next-step summary
```text
项目 TorchVision，总结当前状态和下一步
```

## Suggested parser fields
A future parser can try to extract:
- `project`
- `phase`
- `task`
- `review_mode`
- `execution_boundary`
