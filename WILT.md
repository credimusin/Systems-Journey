# What I Learned Today (WILT)

## Agent Instruction: Session Wrap-Up Protocol

At the conclusion of each learning sprint or topic review, automatically compile and write a detailed reference note to the NEN Inbox directory without waiting for user prompting.

### Destination
- Directory: `/var/home/bmo/Documents/NEN/00-09 System & Inbox/00 Inbox/`
- Filename pattern: `<Technology> & <Topic>.md`

### Note Specification
Every note must adhere to the following schema:

```yaml
---
created: "YYYY-MM-DD HH:MM"
tags:
  - learning
  - devops
  - <relevant-topic-tags>
parent: "[[<Parent Note or MOC>]]"
source: "Sprint YYYY-MM-DD"
---
```

Required sections:
1. `# <Title>`
2. `## Concept & Purpose (ELI5)`: High-level rationale, problem solved, core mental model.
3. `## Under the Hood (How it works)`: Internal mechanics, state structure, engine behavior, design trade-offs.
4. `## Practice & Implementation`: Project directory layout, full reproducible code, configuration manifests.
5. `## Senior / DevOps Insights & Pro Tips`: Pitfalls, real-world gotchas, zero-downtime refactoring, production patterns.
6. `## Relations`: Obsidian wikilinks (`[[Note Name]]`) connecting to relevant notes and parent MOCs.

Tone and depth: Exhaustive, technically rigorous, production-grade explanation without superficial abbreviations.

---

## Learning Log

| Date | Topic | Note Link | Core Concepts |
| :--- | :--- | :--- | :--- |
| **2026-09-20** | OpenTofu & IaC with Podman | `[[OpenTofu & IaC с Podman]]` | Declarative IaC, tfstate, rootless Podman socket, first deploy |
| **2026-09-26** | OpenTofu: Modular Architecture | `[[OpenTofu & Модульная архитектура IaC]]` | Child modules, required_providers scoping, dev/test environments, map outputs, moved block |
| **2026-09-29** | x86-64 Architecture & Branching (CS:APP & Zig) | `[[x86-64 & Архитектура, адресация и ветвления (CSAPP & Zig)]]` | 16 GPR registers, System V ABI, memory addressing Imm(rb, ri, s), leaq arithmetic, condition codes (ZF, SF, OF, CF), integer overflow in Zig, cmp/j* vs cmov branchless optimization |
| **2026-10-02** | x86-64 Loops & Jump Tables (CS:APP & Zig) | `[[x86-64 & Циклы и таблицы переходов (CSAPP & Zig)]]` | Bottom-tested do-while, jump-to-middle vs guarded-do, loop unrolling by 8, unsigned range trick, LUT vs Jump Table, indirect jmp *scale8 |
| **2026-10-03** | OpenTofu: Loops & Conditions (count and for_each) | `[[OpenTofu & Циклы и условия (count и for_each)]]` | count index shift, for_each on map/set, ternary operator, filter comprehension if with lookup, dynamic outputs, moved block refactor |
| **2026-10-09** | x86-64 Call Stack, Structures & Memory Allocation (CS:APP & Zig) | `[[x86-64 & Стек вызовов, структуры и аллокация памяти (CSAPP & Zig)]]` | System V ABI (6 args, %rax, stack), Caller vs Callee-saved, 16-byte stack alignment, Red Zone, struct padding & alignment, Buffer Overflow & canary/NX/ASLR, explicit allocators in Zig (DebugAllocator), ArrayList unmanaged, defer/errdefer, Linux mmap/munmap demand paging & strace |
| **2026-10-10** | OpenTofu: Remote Backend & State Locking (S3 & MinIO) | `[[OpenTofu & Remote Backend и State Locking (S3 и MinIO)]]` | S3 backend, MinIO S3 API, path-style addressing, S3 conditional writes, state migration (-migrate-state), state locking (.tflock, HTTP 412), disaster recovery (force-unlock) |
| **2026-10-12** | x86-64 Memory Hierarchy, Caching & Locality (CS:APP & Zig) | `[[x86-64 & Иерархия памяти, кэширование и локальность (CSAPP & Zig)]]` | SRAM vs DRAM physical cells, Memory Latency Gap, Principle of Locality (temporal vs spatial), 64-byte Cache Line, Row-Major Order $(i \cdot M + j) \cdot \text{size}$, Row vs Column traversal 20x gap, Zig 0.16 Linux vDSO monotonic clock, False Sharing & align(64) |



