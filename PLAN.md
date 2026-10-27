# Comprehensive Engineering Curriculum: Systems Foundations, Algorithms & Distributed Architecture

## Strategic Focus
Developing Staff/Senior-level engineering intuition at the intersection of:
- Operating system mechanics and machine architecture (**CS:APP**).
- Algorithmic foundations, discrete math, and computational models (**Skiena**).
- Systems programming in **Zig** (version: see `AGENTS.md` §7).
- Declarative infrastructure, multi-node homelab orchestration (2x Mac mini cluster), and cloud architecture (**OpenTofu, Kubernetes, Cilium eBPF, GitOps, AWS** — integrated with `[[23.00 DevOps - Table of contents]]`).
- Resilient, high-throughput distributed systems, observability, and System Design (**DDIA / SRE**).
- **Authorial Course Packaging**: Every sprint and session note is structured as a self-contained, battle-tested educational module (problem statement, first-principles theory, reference implementation, production gotchas, blitz self-check) suitable for future publication as a commercial engineering curriculum.

### How this plan works
- The plan is **chapter-driven**. Sprints are ordered by the books; the **Book Coverage Map** (§6) lists every chapter and its status at section level.
- One sprint ≈ one week ≈ 25-35 pages of theory (2 h). Big chapters are split across sprints.
- The **Saturday Engineering Lab (2.5 h)** adapts to the active stage:
  - **Stage 1**: **Infrastructure Track** (`I1`–`I12`, §5.1) — OpenTofu, container internals, Linux networking.
  - **Stage 2**: **Algo-Math Lab Track** (`M1`–`M9`, §3 & §5.2) — 100% algorithmic, mathematical proof, and data-structure engineering immersion.
  - **Stage 3**: **Distributed Homelab, Cloud & SRE Track** (`D0a`–`D13`, §4 & §5.3) — DDIA labs, Kubernetes/GitOps/Observability on the 2x Mac mini homelab cluster + AWS hybrid modules, and System Design interview cases.
- Status rules and the order guard: `AGENTS.md` §4.

---

## 1. Methodology & Time Allocation (6.5 h / week)

| Day | Time Window | Modality | Focus |
| :--- | :--- | :--- | :--- |
| **Monday** | 07:30 – 08:30 (1h) | Theory & Notes | Current book sprint + NEN reference notes (`42.02` / `42.03`) |
| **Wednesday** | 07:30 – 08:30 (1h) | Theory & Notes | Current book sprint (continuation) |
| **Tuesday** | 18:00 – 19:00 (1h) | Practical Coding | Core implementation task of the sprint (Zig / Systems) |
| **Thursday** | 18:00 – 19:00 (1h) | Practical Coding | Core implementation task of the sprint (continuation) |
| **Friday** | — | Rest | — |
| **Saturday** | 10:00 – 12:30 (2.5h) | Engineering Lab | Stage 1: Infra (`I1`–`I12`) / Stage 2: Algo-Math (`M1`–`M9`) / Stage 3: DDIA & SRE (`D0a`–`D13`) |
| **Sunday** | — | Offline | — |

---

## 2. Stage 1: Systems Foundation (CS:APP) — 17 sprints

**Book**: Bryant, O'Hallaron — *Computer Systems: A Programmer's Perspective* (RU translation of the 3rd ed.). Pages below are book pages from the table of contents.
**Goal**: The full path from source code to silicon and OS: data, machine code, CPU, memory, linking, processes, virtual memory, I/O, concurrency.

> Pace note: the schedule is a guide, not a deadline. The Coverage Map guards content, not dates.
>
> Order note: sprints 1-6 went Ch. 1 → 2 → 3 → 6 (Ch. 4-5 were moved after Ch. 6). This is acceptable: Ch. 6 depends only on Ch. 2-3. From S1W7 on, the plan follows book order.

### Done
- **S1W1** — Ch. 1 Tour of computer systems. Zig toolchain. — **Done**
- **S1W2** — Ch. 2.1-2.3 Bits, integers, integer arithmetic. Zig bitmasks, overflow, wrapping/saturating ops. — **Done** 
- **S1W3** — Ch. 3.1-3.5 x86-64 registers, operands, `leaq`, condition codes. Zig error sets, `switch`, tagged unions. — **Done**
- **S1W4** — Ch. 3.6 Control flow, `cmov`, loops, jump tables. Zig disassembly, pointers. — **Done**
- **S1W5** — Ch. 3.7-3.10 Procedures, ABI, arrays, structs, buffer overflow. Zig allocators, `defer`/`errdefer`. — **Done**
- **S1W6** — Ch. 6 Memory Hierarchy (storage, locality, caching S/E/B, write policies, blocking/tiling). Zig row/col & tiled matrix multiplication. — **Done**
- **S1W7** — Ch. 4 Processor Architecture & Hazards (Y86-64, PIPE, Forwarding, Load-Use). Zig decoder & hazard detector. — **Done**
- **S1W8** — Ch. 5.1-5.9 Optimizing Performance (Out-of-order, latency vs throughput, loop unrolling, multiple accumulators). Zig 4x4 benchmark. — **Done**
- **S1W9** — Ch. 5.10-5.14 + Ch. 2.4 Optimizing Performance II & Floating Point (Register spilling, non-associativity of float, SIMD `@Vector`, instruction decoding `vaddps`/`vaddss`). — **Done**

### Current
- **S1W10: Linking — Ch. 7** (pp. 634-673)
  - *Theory*: Static linking, ELF relocatable objects, symbols and resolution, relocation, executables and loading, shared libraries, PIC (GOT/PLT), interpositioning.
  - *Zig*: Multi-module `build.zig`, `@cImport`, static and dynamic library; inspect with `readelf`, `nm`, `objdump`.
  - *Status*: **In Progress**

### Next

- **S1W11: Exceptional Control Flow I — Ch. 8.1-8.4** (pp. 680-712)
  - *Theory*: Exceptions (interrupts, traps, faults, aborts), processes, system calls and error handling, `fork`, `execve`, `waitpid`, zombies.
  - *Zig*: Spawn and reap child processes via `std.posix`; watch with `strace -f`.
  - *Status*: Planned

- **S1W12: Exceptional Control Flow II — Ch. 8.5-8.8** (pp. 712-739)
  - *Theory*: Signals: sending, receiving, blocking, safe handlers, races; nonlocal jumps — overview.
  - *Zig*: Graceful shutdown on `SIGINT`/`SIGTERM` (async-signal-safe handler + flag).
  - *Status*: Planned

- **S1W13: Virtual Memory I — Ch. 9.1-9.8** (pp. 750-786)
  - *Theory*: Address spaces, VM as cache / memory management / protection tool, address translation, page tables, TLB, Core i7/Linux case study, memory mapping (`mmap`).
  - *Zig*: Read `/proc/self/maps`; `mmap` a file and compare with `read`; observe page faults (`/usr/bin/time -v`, `perf stat`).
  - *Status*: Planned

- **S1W14: Virtual Memory II — Ch. 9.9-9.12** (pp. 786-819)
  - *Theory*: Dynamic memory allocation: implicit/explicit free lists, fragmentation, coalescing, segregated fits; garbage collection — overview; common memory bugs.
  - *Zig*: Own allocator implementing the `std.mem.Allocator` interface (bump/arena first, then free list).
  - *Status*: Planned

- **S1W15: System-Level I/O — Ch. 10** (pp. 830-851)
  - *Theory*: Unix I/O, files, `open/read/write`, short counts, robust I/O (RIO), metadata, directories, file sharing (descriptor tables), redirection, standard I/O buffering.
  - *Zig*: Buffered reader/writer over raw file descriptors; compare syscall counts with `strace -c`.
  - *Status*: Planned

- **S1W16: Concurrent Programming — Ch. 12** (pp. 901-953)
  - *Theory*: Concurrency with processes, I/O multiplexing, threads; shared variables, semaphores, producer-consumer, readers-writers, thread safety, races, deadlocks.
  - *Zig*: `std.Thread`, `Mutex`, atomics; bounded producer-consumer ring buffer.
  - *Note*: Needed before the Stage 2 capstone (multi-threaded scheduler).
  - *Status*: Planned

- **S1W17: Stage 1 Capstone**
  - *Zig*: Production-grade CLI `hexdump`: argument parsing, error sets, buffered I/O (S1W15), signal-safe exit (S1W12).
  - *Status*: Planned

Ch. 11 (Network programming) is moved to the start of Stage 3 (S3W0), where it bridges into DDIA.

### Vacation 1 (1 week)
Note consolidation in Obsidian, no new topics.

---

## 3. Stage 2: Algorithms & Applied Math (Skiena) — 9 sprints (100% Algo-Math Immersion)

**Book**: S. Skiena — *The Algorithm Design Manual*, 3rd ed. Plus discrete math (logic, sets, proofs, combinatorics, probability).
**NEN Reference Base**: `40-79 Resources/42 Programming/42.02 Skiena - Algorithm Design/`.
**Goal**: Complexity and mathematical rigor from first principles, data structures from scratch in Zig, and Saturday 2.5h Algo-Math problem-solving labs (`M1`–`M9`). No infrastructure distraction during this stage.

- **S2W1: Analysis & Discrete Foundations — Ch. 1-2**
  - *Theory*: Correctness, counterexamples, mathematical induction, modeling (Ch. 1); RAM model, Big-O/Ω/Θ, dominance relations, summations, logarithms (Ch. 2). NEN: `[[Моделирование задачи (Combinatorial Objects)]]`, `[[Модель вычислений RAM]]`, `[[Математические суммы и логарифмы]]`.
  - *Math*: Propositional logic, predicates, sets, relations, functions (injective/surjective/bijective), closed-form summation proofs ($\sum i, \sum i^2, \sum r^i$).
  - *Zig (Tue/Thu)*: Statistical benchmarking harness with monotonic clock and allocation counter.
  - *Saturday Algo-Math Lab (`M1`)*: Induction proof worksheet + empirical curve fitting in Zig: measure runtime ratios across $2N$ inputs to distinguish $O(\log n), O(n), O(n \log n), O(n^2)$ and expose cache-boundary step functions.
  - *Status*: Planned

- **S2W2: Fundamental Data Structures — Ch. 3.1-3.3**
  - *Theory*: Contiguous vs linked structures, stacks, queues, dictionaries. NEN: `[[Массивы vs Связные списки]]`, `[[Стеки и Очереди]]`.
  - *Math*: Amortized analysis via aggregate, accounting, and potential ($\Phi$) methods (dynamic array geometric resizing, two-stack queue).
  - *Zig (Tue/Thu)*: Generic `Stack(T)`, `DoublyLinkedList(T)` with injected allocator and explicit `deinit`.
  - *Saturday Algo-Math Lab (`M2`)*: Potential-method proof exercises + implementing a power-of-two bitmask `RingBuffer(T)` and intrusive linked list in Zig; benchmark pointer-chasing vs contiguous traversal.
  - *Status*: Planned

- **S2W3: Trees & Priority Queues — Ch. 3.4-3.5, 4.3**
  - *Theory*: Binary search trees, balancing invariants, binary heaps, heapsort. NEN: `[[Бинарные деревья поиска (BST)]]`, `[[Очереди с приоритетом (Priority Queues)]]`, `[[Сортировка кучей (Heapsort)]]`.
  - *Math*: Tree height bounds ($\lceil \log_2(n+1) \rceil$ vs $O(n)$ degenerate chain), linear-time $O(n)$ `build_heap` convergence series proof ($\sum_{h=0}^{\lfloor \log n \rfloor} \frac{n}{2^{h+1}} O(h) = O(n)$).
  - *Zig (Tue/Thu)*: In-place `MinHeap(T)` on a flat array ($2i+1, 2i+2$) + in-place heapsort.
  - *Saturday Algo-Math Lab (`M3`)*: $d$-ary heap arithmetic ($d=4$ cache-line-aligned heap vs binary heap in Zig) + Top-$K$ streaming selection and $K$-way sorted stream merge problems.
  - *Status*: Planned

- **S2W4: Hashing & Probabilistic Structures — Ch. 3.7, Ch. 6**
  - *Theory*: Hash tables (chaining vs open addressing / linear probing / Robin Hood), string hashing, Rabin-Karp, Bloom filters. NEN: `[[Хеширование и Хеш-таблицы]]`.
  - *Math*: Combinatorics & probability: Birthday Paradox, Balls-and-Bins maximum load, Poisson approximation, deriving optimal Bloom filter hash count $k = \frac{m}{n} \ln 2$ and false-positive rate $p \approx (1 - e^{-kn/m})^k$.
  - *Zig (Tue/Thu)*: Open-addressing `HashMap(K, V)` with tombstone/backward-shift deletion; bit-packed `BloomFilter`.
  - *Saturday Algo-Math Lab (`M4`)*: Collision distribution experiment + Rabin-Karp rolling hash substring search ($O(n+m)$) and Count-Min Sketch frequency estimator in Zig.
  - *Status*: Planned

- **S2W5: Sorting & Divide-and-Conquer — Ch. 4, Ch. 5.1-5.4**
  - *Theory*: Quicksort, mergesort, stability, bucketing/radix; binary search and boundary invariants; divide-and-conquer recurrences. NEN: `[[Быстрая сортировка (Quicksort)]]`, `[[Сортировка слиянием (Mergesort)]]`, `[[Бинарный поиск и его вариации]]`, `[[Рекуррентные соотношения и Master Theorem]]`.
  - *Math*: Substitution method, recursion trees, and the Master Theorem ($T(n) = aT(n/b) + f(n)$); expected comparisons in randomized Quicksort ($2n \ln n$).
  - *Zig (Tue/Thu)*: In-place quicksort with median-of-three partitioning and insertion-sort cutoff.
  - *Saturday Algo-Math Lab (`M5`)*: Recurrence derivation set + Quickselect ($O(n)$ expected order statistics for $p50, p95, p99$) and monotonic predicate binary search problems in Zig.
  - *Status*: Planned

- **S2W6: Graph Traversal & Topology — Ch. 7**
  - *Theory*: Adjacency matrix vs adjacency list (CSR / flat arrays), BFS, DFS, articulation points, DFS on directed graphs, topological sorting, strongly connected components. NEN: `[[Обход в ширину (BFS)]]`, `[[Обход в глубину (DFS)]]`.
  - *Math*: Graph invariants ($\sum \deg(v) = 2|E|$), trees ($|E| = |V| - 1$), DAG partial orders, edge classification in DFS (tree, back, forward, cross edges).
  - *Zig (Tue/Thu)*: Cache-friendly Compressed Sparse Row (CSR) graph + Kahn's topological sort.
  - *Saturday Algo-Math Lab (`M6`)*: 2-coloring bipartiteness check, 3-color DFS cycle detector with exact cycle path reconstruction, and Tarjan's Strongly Connected Components (SCC) in Zig.
  - *Status*: Planned

- **S2W7: Weighted Graphs & Network Optimization — Ch. 8.1-8.3**
  - *Theory*: Minimum Spanning Trees (Prim, Kruskal), Disjoint-Set Union-Find, shortest paths (Dijkstra, Bellman-Ford, Floyd-Warshall). NEN: `[[Минимальное остовное дерево (Prim, Kruskal)]]`, `[[Кратчайшие пути (Dijkstra, Floyd-Warshall)]]`.
  - *Math*: Matroid / Cut Property proof of MST optimality, relaxation triangle inequality ($d[v] \le d[u] + w(u,v)$), Union-Find rank + path compression ($O(\alpha(n))$).
  - *Zig (Tue/Thu)*: Dijkstra shortest-path engine using the S2W3 `MinHeap`.
  - *Saturday Algo-Math Lab (`M7`)*: Union-Find with path compression + Kruskal MST + Bellman-Ford negative cycle detection (arbitrage / routing loop detection) in Zig.
  - *Status*: Planned

- **S2W8: Dynamic Programming — Ch. 10.1-10.3**
  - *Theory*: Optimal substructure, overlapping subproblems, memoization vs bottom-up tabulation, string edit distance, Longest Increasing Subsequence (LIS). NEN: `[[Принципы динамического программирования]]`.
  - *Math*: Formulating Bellman recurrence equations, state-space DAG dimensionality reduction ($O(n \cdot m)$ time $\to O(\min(n,m))$ memory).
  - *Zig (Tue/Thu)*: Levenshtein edit distance with $O(n)$ two-row memory + backpointer path reconstruction.
  - *Saturday Algo-Math Lab (`M8`)*: $O(n \log n)$ Patience-sorting LIS + Longest Common Subsequence (LCS) line-by-line `diff` utility in Zig.
  - *Status*: Planned

- **S2W9: Stage 2 Algo-Math Capstone**
  - *Math*: Critical Path Method (CPM) on weighted DAGs: earliest start ($ES$), latest start ($LS$), slack/float ($LS - ES$), and theoretical parallel speedup limit (Amdahl's / Brent's theorem: $T_p \ge \max(T_1/p, T_\infty)$).
  - *Zig (Tue/Thu & Saturday Lab `M9`)*: Multi-threaded DAG task scheduler & execution engine: parse task graph, validate acyclicity, compute critical path and slack, execute independent nodes across a bounded worker thread pool (`std.Thread`, `Mutex`, `Condition` from S1W16).
  - *Status*: Planned

### Vacation 2 (1 week)
Consolidation of Stage 2 notes into course modules in Obsidian; physical network & OS preparation of the 2x Mac mini nodes for Stage 3.

---

## 4. Stage 3: Distributed Systems, SRE & Platform Engineering (DDIA + Superman) — 15 sprints

**Book**: M. Kleppmann — *Designing Data-Intensive Applications* (RU translation of the 1st ed., 12 chapters).
**NEN Reference Bases**: `40-79 Resources/42 Programming/42.03 Kleppmann - DDIA/` and `[[23.00 DevOps - Table of contents]]`.
**Hardware & Cloud Testbed**:
- **Physical Homelab Cluster**: **2x Mac mini** nodes (Linux bare-metal/VMs) + workstation as 3rd quorum witness/client.
- **Cloud Burst / Portfolio Layer**: **AWS** (VPC, IAM, S3, EKS/EC2 via OpenTofu) for cloud-native competencies and international resume validation.
**Languages & Stack**: Zig, Go/Python, OpenTofu, Ansible, Kubernetes (K3s + Cilium eBPF), ArgoCD, Prometheus/Grafana/Loki/OpenTelemetry, PostgreSQL, Redpanda/Kafka.

> **Superman Symbiosis Rule**: Every sprint in Stage 3 produces:
> 1. **First-Principles Theory & Code** (DDIA + Zig/Go).
> 2. **Production Homelab / Cloud Lab** on Saturdays (`D0a`–`D13`), committed to a **Public GitHub Portfolio Repository** with English READMEs.
> 3. **System Design & $10k Interview Case** (`23.72`): architectural trade-off defense and failure-mode analysis recorded in the session note.

- **S3W0a: Network Programming, TLS & L4/L7 Balancing — CS:APP Ch. 11 + Superman `23.13`–`23.14`** (pp. 854-896)
  - *Theory*: Client-server model, IP, DNS, POSIX sockets, HTTP, TLS 1.3 handshake internals (`23.14.1`), L4 (TCP) vs L7 (HTTP) load balancing (`23.14.2`).
  - *Zig (Tue/Thu)*: TCP echo server, then a tiny concurrent HTTP server (`S1W11`Move/I/O).
  - *Saturday Lab (`D0a`)*: **2x Mac mini Homelab Bootstrap**: OS hardening (SSH keys, `nftables` `23.13.1`–`23.13.3`), automated node configuration with Ansible (`23.22`), deploying HAProxy/Nginx L4/L7 load balancer with TLS termination across the 2 nodes, packet inspection with `tcpdump` (`23.14.3`).
  - *System Design Case*: L4 (IPVS/Maglev) vs L7 (Envoy/Nginx) load balancers, TLS termination at edge vs mTLS passthrough.
  - *Status*: Planned

- **S3W0b: Kubernetes Internals, eBPF Networking & GitOps Platform — Superman `23.32`–`23.35`, `23.41`–`23.42`**
  - *Theory*: Kubernetes Control Plane (`etcd`, `kube-apiserver`, `scheduler`, `controller-manager`, `kubelet`), Pod lifecycle & probes (`23.32.1`), Services/Ingress/NetworkPolicy (`23.33`), Cilium eBPF datapath vs `iptables` (`23.33.4`), CSI storage & RBAC (`23.34`), GitOps reconciliation loop (`23.42`).
  - *Saturday Lab (`D0b`)*: Deploy multi-node Kubernetes (K3s) across the **2x Mac mini** cluster using OpenTofu + Ansible; install **Cilium (eBPF)**, configure RBAC & Helm/Kustomize (`23.35`), and bootstrap **ArgoCD** (`23.42.1`) + GitHub Actions CI (`23.41.1`) synced with the public portfolio repo.
  - *System Design Case*: Why `iptables` degrades at >10,000 Kubernetes Services ($O(n)$ rule list) vs Cilium eBPF hash maps ($O(1)$ lookup — direct link to S2W4!).
  - *Status*: Planned

- **S3W1: Reliability, Scalability, Maintainability & Observability — DDIA Ch. 1 + Superman `23.61`–`23.62`**
  - *Theory*: Faults vs failures, load parameters, latency percentiles ($p50, p95, p99, p99.9$), tail latency amplification, SLI/SLO/SLA and error budgets. NEN: `[[Reliability (Надежность)]]`, `[[Scalability (Масштабируемость)]]`, `[[Maintainability (Удобство сопровождения)]]`.
  - *Zig (Tue/Thu)*: Synthetic load generator computing exact/HDR latency histograms ($p50$–$p99.9$).
  - *Saturday Lab (`D1`)*: Deploy full Observability stack on the 2x Mac mini K8s cluster via GitOps: **Prometheus** (`23.61.1`), **Grafana** (`23.61.2`), **Alertmanager** (`23.61.3`), **Loki** (`23.62.1`), and **OpenTelemetry** (`23.62.2`); measure fan-out tail latency amplification under synthetic load.
  - *System Design Case*: Designing an SLO & Error Budget alerting policy (multi-window burn-rate alerts) for a high-throughput API.
  - *Status*: Planned

- **S3W2: Data Models, Query Languages & Cloud Foundations — DDIA Ch. 2 + Superman `23.51`**
  - *Theory*: Relational vs document vs graph models, impedance mismatch, declarative (SQL/Datalog) vs imperative queries. NEN: `[[Реляционная vs Документная модель]]`, `[[Языки запросов (Декларативные vs Императивные)]]`, `[[Графоподобные модели данных]]`.
  - *Tue/Thu Practice*: Schema design & query plan (`EXPLAIN ANALYZE`) comparison for hierarchical/graph workloads in PostgreSQL (relational vs `jsonb` vs recursive CTE).
  - *Saturday Lab (`D2`)*: **AWS Cloud Foundation (`23.51`)**: OpenTofu module for AWS VPC (Public/Private subnets, routing, Security Groups `23.51.1`), least-privilege IAM roles + GitHub OIDC (`23.51.2`, `23.41.3`), and S3 bucket with lifecycle/replication (`23.51.3`) for homelab off-site backups.
  - *System Design Case*: Choosing storage models (PostgreSQL vs Document DB vs Graph) + hybrid cloud topology (on-prem Mac mini compute + AWS S3 durable backup).
  - *Status*: Planned

- **S3W3: Storage Engines & Kernel I/O — DDIA Ch. 3 + Superman `23.12`**
  - *Theory*: Append-only logs, hash indexes, SSTables, LSM-trees (compaction, Bloom filters from S2W4), B-trees (WAL, page splits, latches), OLTP vs OLAP, column storage. NEN: `[[LSM-деревья vs B-деревья]]`, `[[OLTP vs OLAP]]`, `[[Столбцовое хранение (Column-oriented Storage)]]`.
  - *Zig (Tue/Thu)*: Bitcask-style append-only storage engine: Write-Ahead Log (WAL) + in-memory hash index (`key -> {file_offset, size}`) + crash recovery & compaction.
  - *Saturday Lab (`D3`)*: Linux disk & memory performance tuning (`23.12.1`–`23.12.3`): benchmark write amplification and IOPS of B-tree (PostgreSQL) vs LSM-tree on the Mac mini NVMe using `fio`, `iostat`, and **eBPF / BCC tools** (`biolatency`, `ext4slower`).
  - *System Design Case*: Write-heavy telemetry ingestion (LSM/RocksDB/ClickHouse) vs transactional financial ledger (B-tree/PostgreSQL); write vs read amplification trade-offs.
  - *Status*: Planned

- **S3W4: Encoding, Schema Evolution & Service Communication — DDIA Ch. 4**
  - *Theory*: Binary vs text encodings (JSON, MessagePack, Thrift, Protobuf, Avro), field tags, forward vs backward compatibility, dataflow via databases, REST/gRPC, and asynchronous message brokers. NEN: `[[Форматы кодирования (Binary vs Text)]]`, `[[Совместимость (Прямая и Обратная)]]`, `[[Режимы передачи данных (Dataflow)]]`.
  - *Zig / Go (Tue/Thu)*: Wire-level Varint + Tag-Length-Value (Protobuf wire format) encoder/decoder in Zig; verify zero-downtime forward/backward schema evolution.
  - *Saturday Lab (`D4`)*: Rolling Canary update in Kubernetes (`23.32.2`, `23.42.3`) across the 2 Mac mini nodes with simultaneous v1 and v2 microservices communicating over gRPC/Protobuf and OpenTelemetry distributed tracing (`23.62.2`).
  - *System Design Case*: Zero-downtime database & API schema migrations (expand-and-contract pattern) in a multi-service architecture.
  - *Status*: Planned

- **S3W5: Replication & High Availability — DDIA Ch. 5**
  - *Theory*: Single-leader (sync vs async, failover hazards), multi-leader (conflict resolution, CRDTs/LWW), leaderless (Dynamo-style sloppy quorums, hinted handoff, read repair, $W + R > N$). NEN: `[[Алгоритмы репликации (Leader-based, Multi-leader, Leaderless)]]`, `[[Проблемы задержки репликации]]`.
  - *Tue/Thu Practice*: Replication lag consistency anomalies simulation (read-your-writes, monotonic reads, consistent prefix reads).
  - *Saturday Lab (`D5`)*: Deploy High-Availability **PostgreSQL cluster** (Primary on Mac mini #1, Standby replica on Mac mini #2, WAL archiving to S3/MinIO); inject replication delay, observe stale reads, execute automated failover, and monitor lag in Grafana.
  - *System Design Case*: Designing multi-region read scaling and failover without data loss ($RPO = 0$ vs low $RTO$); Dynamo quorum math ($N=3, W=2, R=2$).
  - *Status*: Planned

- **S3W6: Partitioning (Sharding) & Routing — DDIA Ch. 6**
  - *Theory*: Key-range vs hash partitioning, hot spots / skew, local vs global secondary indexes (scatter-gather vs term-partitioned), dynamic rebalancing, request routing tiers. NEN: `[[Стратегии секционирования (Range vs Hash)]]`, `[[Секционирование и вторичные индексы]]`, `[[Перебалансировка секций]]`.
  - *Zig (Tue/Thu)*: Consistent Hashing Ring with virtual nodes ($O(\log M)$ binary search lookup from S2W5) + bounded-load rebalancing measurement when a node joins/leaves.
  - *Saturday Lab (`D6`)*: Partitioned data tier & L7 consistent-hash routing proxy (Envoy/HAProxy) across the 2 Mac mini nodes; benchmark hot-key mitigation and key migration impact.
  - *System Design Case*: Sharding a 100 TB multi-tenant database (choosing partition key, avoiding celebrity hot-spots, handling secondary index queries).
  - *Status*: Planned

- **S3W7: Transactions & Concurrency Control — DDIA Ch. 7**
  - *Theory*: ACID in practice, weak isolation levels (Read Committed, Snapshot Isolation / MVCC), dirty reads, lost updates (`SELECT FOR UPDATE`, atomic compare-and-set), write skew & phantoms, true Serializability (2PL vs Serializable Snapshot Isolation / SSI). NEN: `[[ACID и уровни изоляции]]`, `[[Асимметрия записи и фантомы]]`.
  - *Tue/Thu & Saturday Lab (`D7`)*: Concurrency anomaly laboratory on PostgreSQL: write concurrent transaction harness reproducing lost updates, write skew (on-call doctor / double-booking), and phantom reads under `READ COMMITTED` and `REPEATABLE READ`, then prove how `SERIALIZABLE` (SSI) or materializing conflicts eliminates them.
  - *System Design Case*: Designing an idempotent payment / inventory reservation engine without global locks.
  - *Status*: Planned

- **S3W8: The Trouble with Distributed Systems & Chaos Engineering — DDIA Ch. 8**
  - *Theory*: Unreliable networks, TCP congestion/queuing vs UDP, timeout tuning (Phi Accrual failure detector), unreliable clocks (Time-of-Day NTP jumps vs Monotonic clocks, Google TrueTime), process pauses (GC, VM steal, disk I/O), fencing tokens, Byzantine faults. NEN: `[[Ненадежные сети и детекторы сбоев]]`, `[[Ненадежные часы (Physical vs Logical)]]`, `[[Знание, истина и ложь (Quorums)]]`.
  - *Zig (Tue/Thu)*: Fencing-token lock verifier & monotonic heartbeat failure detector.
  - *Saturday Lab (`D8`)*: **Physical Chaos Engineering on 2x Mac mini**: use Linux `tc netem` and `nftables` to inject asymmetric network partitions, 200ms jitter, and packet loss between Mac mini #1 and Mac mini #2; demonstrate why Last-Write-Wins (LWW) with skewed wall-clock NTP silently drops data and how fencing tokens prevent split-brain storage corruption.
  - *System Design Case*: Distributed locking (why lock service without fencing tokens is unsafe under GC/network pauses).
  - *Status*: Planned

- **S3W9: Consistency & Consensus I (Linearizability & Ordering) — DDIA Ch. 9 (Part 1)**
  - *Theory*: Linearizability vs Serializability, CAP theorem critique (network partition forces choice between linearizability and availability), causal consistency, Lamport logical timestamps, version vectors, Total Order Broadcast. NEN: `[[Линеаризуемость]]`, `[[Событийная согласованность vs Причинность]]`.
  - *Zig (Tue/Thu)*: Lamport clocks & Vector Clocks causality tracker (detecting concurrent conflicting writes $A \parallel B$).
  - *Saturday Lab (`D9`)*: Linearizability verification (Jepsen/elle-style history checker concepts) and observing `etcd` linearizable reads (`quorum` vs `serializable` local reads) under network partition on the homelab cluster.
  - *System Design Case*: Linearizability vs Causal Consistency in distributed configuration stores, DNS, and collaborative systems.
  - *Status*: Planned

- **S3W10: Consistency & Consensus II (Raft, 2PC & Coordination) — DDIA Ch. 9 (Part 2)**
  - *Theory*: Atomic commit & Two-Phase Commit (2PC coordinator blocking problem), fault-tolerant consensus (Raft, Paxos, Zab: epoch/term numbers, leader election, log replication), ZooKeeper/etcd coordination primitives (ephemeral leases, watches, service discovery). NEN: `[[Алгоритмы консенсуса (Raft, Zab, Paxos)]]`.
  - *Zig / Go (Tue/Thu)*: Raft state-machine core (Term, RequestVote, AppendEntries log matching invariant).
  - *Saturday Lab (`D10`)*: **3-Node Quorum Lab (Mac mini #1 + Mac mini #2 + Workstation witness)**: inspect `etcd` Raft cluster internals, trigger hard power-off / network isolation of the leader, measure election timeout and quorum loss when 2 of 3 nodes fail.
  - *System Design Case*: Why Kubernetes `etcd` requires an odd number of nodes (3 or 5) and why stretching a single Raft cluster across 3 high-latency WAN regions hurts write latency.
  - *Status*: Planned

- **S3W11: Batch Processing & Cloud Cost/Platform Engineering — DDIA Ch. 10 + Superman `23.52`, `23.81`–`23.82`**
  - *Theory*: Unix philosophy (pipes, composable tools, uniform interfaces), MapReduce execution model, distributed joins (sort-merge, broadcast hash, partitioned hash), dataflow engines. NEN: `[[MapReduce и философия Unix]]`, `[[Join-ы в пакетной обработке]]`.
  - *Zig (Tue/Thu)*: High-speed multi-gigabyte log aggregator in Zig (mmap/buffered I/O + hash aggregation) benchmarked against a Unix `awk | sort | uniq -c` pipeline.
  - *Saturday Lab (`D11`)*: **AWS EKS & FinOps (`23.52`, `23.21.4`, `23.82`)**: write reusable OpenTofu blueprints for Amazon EKS (`23.52.1`–`23.52.2`) validated with **Infracost** (`23.21.4`) and resource cost attribution in the homelab via OpenCost/Kubecost (`23.82.1`).
  - *System Design Case*: Designing petabyte-scale batch analytics & log pipelines (S3 object storage lakehouse vs hot TSDB) + FinOps cost optimization.
  - *Status*: Planned

- **S3W12: Stream Processing & Event-Driven Architecture — DDIA Ch. 11**
  - *Theory*: Message brokers (AMQP/JMS) vs partitioned append-only log brokers (Kafka/Redpanda), consumer groups & offsets, Change Data Capture (CDC) & Transactional Outbox, Event Sourcing, stream joins & windowing (event time vs processing time, watermarks), fault tolerance & idempotency. NEN: `[[Брокеры сообщений (Logs vs Messaging)]]`, `[[Рассуждения о времени в потоках]]`.
  - *Tue/Thu & Saturday Lab (`D12`)*: Deploy **Redpanda (Kafka API)** on the 2x Mac mini cluster; configure **Change Data Capture (CDC)** / Outbox stream from PostgreSQL (`D5`) into Redpanda, consume events with a Zig/Go worker with idempotent deduplication, and monitor consumer lag in Prometheus/Grafana.
  - *System Design Case*: Event-Driven Microservices without dual-write bugs (Transactional Outbox + CDC vs 2PC) and handling backpressure/poison pills.
  - *Status*: Planned

- **S3W13: Future of Data Systems & Production Platform Capstone — DDIA Ch. 12 + Superman Portfolio (`23.71`–`23.83`)**
  - *Theory*: Data integration, unbundling the database, end-to-end correctness, idempotency, platform engineering / Golden Paths (`23.81`), AI-assisted IaC & CI review (`23.83`). NEN: `[[Интеграция данных и База данных наоборот]]`, `[[Корректность и этика данных]]`.
  - *Capstone (`D13` — Public GitHub Portfolio Project)*:
    - Assemble the complete **Multi-Node Distributed Platform** running on the **2x Mac mini Homelab + AWS Hybrid S3/IaC**:
      1. Declarative provisioning: OpenTofu + Ansible + Infracost + GitHub Actions CI (`I1`–`I9`, `D0a`, `D11`).
      2. Orchestration & Networking: Multi-node K3s + Cilium eBPF + ArgoCD GitOps (`D0b`).
      3. Stateful Data & Streaming Tier: HA PostgreSQL with failover + Redpanda CDC stream + Zig high-performance service (`D3`–`D12`).
      4. Observability & Chaos Proof: Prometheus, Grafana, Loki, OpenTelemetry + documented chaos test report (`D1`, `D8`, `D10`).
      5. **International Market Packaging (`23.71`–`23.72`)**: English README, Architecture Decision Records (ADRs), C4/Mermaid architecture diagrams, and recorded 60-second English architectural walkthrough.
  - *Status*: Planned

---

## 5. Saturday Engineering Lab Queues

Each stage has its own dedicated Saturday (2.5 h) queue. Take the next item in the active stage's queue and mark its status here.

### 5.1 Stage 1: Infrastructure Track (`I1`–`I12`)
Independent of CS:APP weekday sprints. Covers `[[23.00 DevOps - Table of contents]]` §1 (Linux Kernel/Networks) & §2 (OpenTofu/IaC).

| # | Topic | Superman Ref | Status |
| :--- | :--- | :--- | :--- |
| I1 | OpenTofu CLI, Docker/Podman provider, rootless containers | `23.21`, `23.31` | Done |
| I2 | State file, variables, outputs | `23.21.1` | Done |
| I3 | Local child modules, inputs/outputs scoping | `23.21.2` | Done |
| I4 | `count`, `for_each`, conditionals, dynamic expressions | `23.21.2` | Done |
| I5 | Remote S3 backend (MinIO), state locking, state migration | `23.21.1` | Done |
| I6 | `templatefile`, volumes, persistent storage | `23.21.2`, `23.31` | Done |
| I7 | CI pipeline for OpenTofu: fmt, validate, lint, drift detection | `23.41.1`, `23.83.1` | Done |
| I8 | Lifecycle (`create_before_destroy`, `prevent_destroy`), `-parallelism` | `23.21` | Next |
| I9 | Secrets: `TF_VAR_*`, sensitive values, state encryption | `23.21`, `23.41.3` | Planned |
| I10 | Container internals: namespaces, cgroups (pairs with CS:APP Ch. 8-9) | `23.11.1`, `23.11.2` | Planned |
| I11 | Network virtualization: netns, veth, bridges, iptables/nftables (pairs with CS:APP Ch. 8-10) | `23.13.1`, `23.31.3` | Planned |
| I12 | **Stage 1 Infra Capstone**: multi-tier testbed (reverse proxy, app, isolated networks) | `23.14.2`, `23.31` | Planned |

### 5.2 Stage 2: Algo-Math Lab Track (`M1`–`M9`)
100% algorithmic and discrete-math Saturdays paired with Stage 2 sprints (§3).

| # | Sprint | Lab Focus (Math Proof + Zig Algorithmic Implementation) | Status |
| :--- | :--- | :--- | :--- |
| M1 | S2W1 | Induction proofs, closed-form summations, empirical complexity curve-fitting in Zig | Planned |
| M2 | S2W2 | Potential-method ($\Phi$) amortized proofs, power-of-two `RingBuffer` & intrusive list benchmark | Planned |
| M3 | S2W3 | $O(n)$ heapify proof, cache-aligned 4-ary heap vs binary heap, Top-$K$ / $K$-way merge in Zig | Planned |
| M4 | S2W4 | Birthday paradox & Bloom filter math ($k = \frac{m}{n}\ln 2$), Rabin-Karp & Count-Min Sketch in Zig | Planned |
| M5 | S2W5 | Master Theorem & recursion trees, Quickselect ($p50/p99$) & predicate binary search in Zig | Planned |
| M6 | S2W6 | Graph invariants, 3-color DFS cycle path reconstruction, Tarjan's SCC in Zig | Planned |
| M7 | S2W7 | MST cut-property proof, Union-Find ($\alpha(n)$), Kruskal & Bellman-Ford negative cycles in Zig | Planned |
| M8 | S2W8 | Bellman recurrences, $O(n \log n)$ LIS, and LCS line-based `diff` engine in Zig | Planned |
| M9 | S2W9 | **Stage 2 Capstone**: Critical Path Method (CPM) math + multi-threaded DAG task scheduler in Zig | Planned |

### 5.3 Stage 3: Distributed Homelab (2x Mac mini), Cloud & SRE Lab Track (`D0a`–`D13`)
Paired with Stage 3 sprints (§4). Builds the public GitHub portfolio and covers the remaining sections of `[[23.00 DevOps - Table of contents]]`.

| # | Sprint | Lab Focus (2x Mac mini Homelab + AWS + DDIA + System Design) | Superman Ref | Status |
| :--- | :--- | :--- | :--- | :--- |
| D0a | S3W0a | 2x Mac mini bootstrap (SSH hardening, `nftables`, Ansible), HAProxy/Nginx L4/L7 + TLS, `tcpdump` | `23.13`, `23.14`, `23.22` | Planned |
| D0b | S3W0b | Multi-node K3s cluster on 2x Mac mini, Cilium eBPF CNI, RBAC, Helm/Kustomize, ArgoCD GitOps | `23.32`–`23.35`, `23.42` | Planned |
| D1 | S3W1 | Full Observability (Prometheus, Grafana, Alertmanager, Loki, OpenTelemetry), SLO burn-rate lab | `23.61`, `23.62` | Planned |
| D2 | S3W2 | PostgreSQL data models (`jsonb`/recursive CTE) + AWS VPC, IAM OIDC, S3 backup module in OpenTofu | `23.51`, `23.41.3` | Planned |
| D3 | S3W3 | Linux I/O tuning (`fio`, `iostat`, eBPF/BCC `biolatency`) comparing LSM vs B-tree + Zig Bitcask WAL | `23.12.1`, `23.12.3` | Planned |
| D4 | S3W4 | Protobuf wire evolution + zero-downtime Kubernetes Canary rollout with OpenTelemetry tracing | `23.32.2`, `23.42.3` | Planned |
| D5 | S3W5 | HA PostgreSQL across Mac mini #1 & #2, replication lag injection, automated failover, S3 WAL archive | `23.72.1` | Planned |
| D6 | S3W6 | Consistent hashing ring with virtual nodes in Zig + Envoy/HAProxy sharded routing lab | `23.14.2`, `23.72.1` | Planned |
| D7 | S3W7 | PostgreSQL MVCC & isolation anomalies lab (dirty read, lost update, write skew, SSI vs 2PL) | `23.72.1` | Planned |
| D8 | S3W8 | Physical Chaos Engineering between Mac minis (`tc netem`, `nftables` split-brain, clock skew, fencing) | `23.13.1`, `23.72.1` | Planned |
| D9 | S3W9 | Linearizability vs Causal consistency lab, Vector Clocks in Zig, `etcd` quorum vs local reads | `23.32`, `23.72.1` | Planned |
| D10 | S3W10 | 3-node Raft quorum (2x Mac mini + workstation witness), leader kill, election timeout & split-brain | `23.32`, `23.72.1` | Planned |
| D11 | S3W11 | Zig mmap log aggregator vs Unix pipes + AWS EKS OpenTofu blueprint, Infracost & Kubecost FinOps | `23.21.4`, `23.52`, `23.82` | Planned |
| D12 | S3W12 | Redpanda (Kafka) on 2x Mac mini, PostgreSQL CDC / Transactional Outbox, idempotent stream consumer | `23.72.1` | Planned |
| D13 | S3W13 | **Stage 3 Production Capstone**: Unified Public GitHub Portfolio (Homelab + AWS + ADRs + English pitch) | `23.71`, `23.72`, `23.81` | Planned |

---

## 6. Book Coverage Map (source of truth)

Statuses: `Done`, `In Progress`, `Planned (SxWy)`, `Deferred → SxWy`, `Skipped (reason)`, `Optional`. Rules: `AGENTS.md` §4.3.

### CS:APP (RU, 3rd ed.)
| Ch. | Sections | Pages | Sprint | Status |
| :--- | :--- | :--- | :--- | :--- |
| 1 | 1.1-1.10 Tour of computer systems | 36-61 | S1W1 | Done |
| 2 | 2.1-2.2 Storage, integer representations | 68-113 | S1W2 | Done |
| 2 | 2.3 Integer arithmetic | 113-135 | S1W2 | Done |
| 2 | 2.4 Floating point | 135-151 | S1W9 | Done |
| 3 | 3.1-3.5 Data formats, access, arithmetic | 187-218 | S1W3 | Done |
| 3 | 3.6 Control | 218-250 | S1W4 | Done |
| 3 | 3.7 Procedures | 250-264 | S1W5 | Done |
| 3 | 3.8-3.9 Arrays, structures, alignment | 264-282 | S1W5 | Done |
| 3 | 3.10 Pointers, gdb, buffer overflow, VLA | 282-298 | S1W5 | Done |
| 3 | 3.11 Floating-point code | 298-312 | S1W9 | Optional (with 2.4) |
| 4 | 4.1, 4.3.1, 4.4, 4.5 hazards — overview | 352-457 | S1W7 | Done |
| 4 | 4.2 HCL, SEQ/PIPE hardware details | 368-457 | — | Optional |
| 5 | 5.1-5.9 Optimization, ILP, unrolling | 478-524 | S1W8 | Done |
| 5 | 5.10-5.15 Limits, memory perf, profiling | 524-544 | S1W9 | Done |
| 6 | 6.1-6.3 Storage, locality, hierarchy | 554-586 | S1W6 | Done |
| 6 | 6.4-6.7 Caches, cache-friendly code, memory mountain | 586-616 | S1W6 | Done |
| 7 | 7.1-7.15 Linking | 634-673 | S1W10 | Planned |
| 8 | 8.1-8.4 Exceptions, processes, process control | 680-712 | S1W11 | Planned |
| 8 | 8.5-8.8 Signals, nonlocal jumps | 712-739 | S1W12 | Planned |
| 9 | 9.1-9.8 VM, translation, mmap | 750-786 | S1W13 | Planned |
| 9 | 9.9-9.12 Dynamic allocation, GC, memory bugs | 786-819 | S1W14 | Planned |
| 10 | 10.1-10.12 System-level I/O | 830-851 | S1W15 | Planned |
| 11 | 11.1-11.7 Network programming | 854-896 | S3W0a | Planned |
| 12 | 12.1-12.8 Concurrent programming | 901-953 | S1W16 | Planned |

### Skiena (3rd ed.)
| Ch. | Sections | Sprint | Status |
| :--- | :--- | :--- | :--- |
| 1 | Introduction to algorithm design | S2W1 | Planned |
| 2 | Algorithm analysis | S2W1 | Planned |
| 3 | 3.1-3.3 Arrays, lists, stacks, queues, dictionaries | S2W2 | Planned |
| 3 | 3.4-3.5 BST, priority queues | S2W3 | Planned |
| 3 | 3.7 Hashing | S2W4 | Planned |
| 3 | 3.6, 3.8-3.9 Specialized structures, war stories | — | Optional |
| 4 | Sorting (4.3 heapsort → S2W3) | S2W5 | Planned |
| 5 | 5.1-5.4 Binary search, recurrences | S2W5 | Planned |
| 5 | 5.5-5.9 Fast multiplication, parallel, convolution | — | Optional |
| 6 | Hashing and randomized algorithms | S2W4 | Planned |
| 7 | Graph traversal | S2W6 | Planned |
| 8 | 8.1-8.3 MST, shortest paths | S2W7 | Planned |
| 8 | 8.5-8.7 Network flows, min-cut | — | Optional |
| 9 | Combinatorial search, backtracking | — | Optional |
| 10 | 10.1-10.3 DP basics, edit distance, LIS | S2W8 | Planned |
| 10 | 10.4-10.9 Further DP | — | Optional |
| 11-12 | NP-completeness, hard problems | — | Optional |
| 13 | How to design algorithms | — | Optional |
| 14-22 | Catalog of algorithmic problems | — | Reference only |

### DDIA (RU, 1st ed.)
| Ch. | Topic | Pages | Sprint | Status |
| :--- | :--- | :--- | :--- | :--- |
| 1 | Reliable, scalable, maintainable | 23-53 | S3W1 | Planned |
| 2 | Data models and query languages | 53-97 | S3W2 | Planned |
| 3 | Storage and retrieval | 97-143 | S3W3 | Planned |
| 4 | Encoding and evolution | 143-185 | S3W4 | Planned |
| 5 | Replication | 185-239 | S3W5 | Planned |
| 6 | Partitioning | 239-265 | S3W6 | Planned |
| 7 | Transactions | 265-323 | S3W7 | Planned |
| 8 | Trouble with distributed systems | 323-375 | S3W8 | Planned |
| 9 | Consistency and consensus | 375-449 | S3W9-W10 | Planned |
| 10 | Batch processing | 449-505 | S3W11 | Planned |
| 11 | Stream processing | 505-563 | S3W12 | Planned |
| 12 | Future of data systems | 563-… | S3W13 | Planned |

---

## 7. Knowledge Management, Course Packaging & Portfolio

1. **Session notes in Obsidian as Course Modules** (`/var/home/bmo/Documents/NEN`):
   - One note per session topic, linked to its parent MOC (`[[Архитектура компьютеров]]`, `[[Skiena - Table of Contents]]`, `[[Kleppmann - Table of Contents]]`) and `[[23.00 DevOps - Table of contents]]`.
   - Schema (`AGENTS.md` §6.1) includes the explicit **Problem Statement (Постановка задачи)**, **First-Principles Theory**, **Reviewed Reference Implementation**, **Senior SRE / System Design Case**, and **Blitz Self-Check** — making every note a ready-to-publish chapter of a commercial engineering course.
2. **Practice code**: written by the user in `stage<N>/w<NN>-<topic>/` directories. Goal: reusable reference code — idiomatic Zig, explicit allocators, clear error sets.
3. **Public Portfolio Track**: Stage 3 Saturday labs (`D0a`–`D13`) on the 2x Mac mini homelab + AWS are progressively committed to a public GitHub repository with English documentation and Architecture Decision Records (ADRs).
4. **Spaced Repetition (Optional)**: Anki TSV cards (following `[[43.06 - Стандарт проектирования карточек Anki]]`) are generated on demand via `/superman-learning` from recorded `Weak Spots` in `WILT.md`.
