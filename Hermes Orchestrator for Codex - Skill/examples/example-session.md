# Example Session

## Scenario 1: analysis only

```text
@Hermes 项目 TorchVision，只分析模型加载失败问题，先不要改代码。
```

Expected behavior:
- load workspace state
- classify phase as analysis
- extract constraints: no code changes
- optionally run adversarial review if cross-cutting
- write CURRENT_PLAN.md
- stop at analysis output

---

## Scenario 2: review first, then implementation

```text
@Hermes 项目 JiNanPack，先组织对抗角色评审，再决定是否实施 PLC 绑定修复。
```

Expected behavior:
- run role panel
- summarize consensus and disagreements
- ask for approval or record a gated next step
- do not jump straight into implementation

---

## Scenario 3: resume from a new thread

```text
@Hermes 项目 TorchVision，读取当前状态并继续上一轮计划。
```

Expected behavior:
- do not depend on old thread chat context
- read `PROJECT_STATE.md` and `CURRENT_PLAN.md`
- continue from disk-persisted workspace state
