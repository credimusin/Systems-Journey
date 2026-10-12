# Comprehensive Engineering Curriculum: Systems Foundations, Algorithms & Distributed Architecture

## Strategic Focus
Developing high-leverage engineering intuition at the intersection of:
- Low-level operating system mechanics and machine architecture.
- Algorithmic foundations and computational models.
- Production-grade systems programming in **Zig** (Target: v0.17).
- Declarative infrastructure as code (**OpenTofu / Terraform**).
- Resilient, high-throughput distributed systems (**DDIA / SRE**).

---

## 1. Methodology & Time Allocation (6.5 hrs / week)

| Day | Time Window | Modality | Focus Discipline |
| :--- | :--- | :--- | :--- |
| **Monday** | 07:30 – 08:30 (1h) | Deep Work (Theory & Notes) | Core Literature (CS:APP / Skiena / Kleppmann) |
| **Tuesday** | 18:00 – 19:00 (1h) | Practical Coding | Zig: Syntax, Algorithms, Memory Mechanics |
| **Wednesday**| 07:30 – 08:30 (1h) | Deep Work (Theory & Notes) | Core Literature (Topic continuation) |
| **Thursday** | 18:00 – 19:00 (1h) | Practical Coding | Zig: Data Structures, Linux System Calls |
| **Friday** | — | Rest Day | Cognitive Recovery |
| **Saturday** | 10:00 – 12:30 (2.5h) | Engineering Lab | Infrastructure: OpenTofu, Containers, Networks |
| **Sunday** | — | Complete Offline | Deep Recovery |

---

## 2. Stage 1: Systems Foundation & Declarative Infrastructure (10 Weeks)

**Primary References**:
- R. Bryant, D. O'Hallaron — *Computer Systems: A Programmer's Perspective* (CS:APP, 3rd Ed.)
- Language: **Zig** (Target: v0.17)
- Infrastructure: **OpenTofu / Terraform** & Docker / Linux containers
- **Goal**: Understand the complete execution journey from source code to silicon, master manual memory management and calling conventions, and establish solid declarative IaC practices.

### Sprints

- **Week 1: Computer Systems Tour & Execution Environment**
  - *Theory (CS:APP Ch. 1)*: Tour of computer systems, compilation pipeline, bus architecture, hardware organization, memory hierarchy introduction.
  - *Zig*: Toolchain setup, `zig build-exe`, primitive data types, basic formatted I/O.
  - *Infrastructure*: OpenTofu CLI setup, Docker provider configuration, rootless container deployment.
  - *Status*: **Done**

- **Week 2: Data Representations & Bit-Level Manipulation**
  - *Theory (CS:APP Ch. 2.1–2.2)*: Information representation, bytes, hex, bitwise boolean algebra, two's complement integer arithmetic.
  - *Zig*: Bitmasks, bit shifts, integer overflow detection, wrapping and saturating operators.
  - *Infrastructure*: State file mechanics (`terraform.tfstate`), input variables (`variables.tf`), outputs (`outputs.tf`).
  - *Status*: **Done**

- **Week 3: Machine-Level Representation: Registers & Arithmetic**
  - *Theory (CS:APP Ch. 3.1–3.5)*: x86-64 ISA architecture, 16 GPR registers, operand forms `Imm(rb, ri, s)`, `leaq` arithmetic vs load, condition codes.
  - *Zig*: Strict error sets (`!T`), `switch` expressions, tagged unions.
  - *Infrastructure*: Reusable local child modules, module inputs/outputs scoping.
  - *Status*: **Done**

- **Week 4: Control Flow, Branches & Jump Tables**
  - *Theory (CS:APP Ch. 3.6)*: Assembly control flow, conditional jumps vs conditional moves (`cmov`), loop translations (guarded-do), switch jump tables.
  - *Zig*: Disassembly inspection (`zig build-obj`), single pointers (`*T`), branchless logic patterns.
  - *Infrastructure*: HCL control flow primitives: `count`, `for_each`, ternary conditions, dynamic expressions.
  - *Status*: **Done**

- **Week 5: Call Stack, Procedures & Memory Allocation**
  - *Theory (CS:APP Ch. 3.7–3.10)*: System V AMD64 ABI, stack frames, register preservation contracts (Caller vs Callee-saved), 16-byte alignment, Red Zone, buffer overflow vulnerabilities.
  - *Zig*: Explicit allocators (`std.mem.Allocator`, `GPA`, `PageAllocator`), `defer` and `errdefer`, memory leak diagnostics.
  - *Infrastructure*: Remote S3 backend (MinIO), state locking mechanisms (`.tflock`), state migration.
  - *Status*: **Done**

- **Week 6: Memory Hierarchy, Caching & Locality**
  - *Theory (CS:APP Ch. 6.1–6.3)*: Storage technologies (SRAM 6T vs DRAM 1T-1C, SSD NAND, HDD), memory latency gap, principle of locality (temporal vs spatial), 64-byte cache lines, cache misses (Cold, Conflict, Capacity).
  - *Zig*: 2D matrix traversal benchmark (row-major stride-1 vs column-major stride-N, 20x latency gap), Linux vDSO `clock_gettime`.
  - *Infrastructure*: Configuration templating (`templatefile`), dynamic volumes, persistent container storage.
  - *Status*: **In Progress** (Theory & Matrix Benchmark complete)

- **Week 7: Processor Architecture & Pipelining (CS:APP Ch. 4)**
  - *Theory (CS:APP Ch. 4)*: Y86-64 instruction set architecture, sequential execution (SEQ stages: Fetch, Decode, Execute, Memory, Write-back, PC update), pipelining principles, hazard handling (data hazards, control hazards, pipeline stalls, forwarding).
  - *Zig*: Implementation of an instruction decoding state machine and sequential execution pipeline model in Zig.
  - *Infrastructure*: Multi-environment CI/CD deployment pipelines for OpenTofu, automated linting, drift detection.
  - *Status*: **Next Sprint**

- **Week 8: Optimizing Program Performance (CS:APP Ch. 5)**
  - *Theory (CS:APP Ch. 5)*: Compiler capabilities and limits, loop unrolling (by 2, by 4, by 8), instruction-level parallelism, CPU out-of-order execution, latency vs throughput bounds of functional units, branch prediction penalty.
  - *Zig*: SIMD vectorization in Zig (`@Vector`), loop unrolling experiments, instruction-level latency benchmarking against scalar loops.
  - *Infrastructure*: Performance and parallelism optimization in OpenTofu (`-parallelism`), resource lifecycle management (`create_before_destroy`).
  - *Status*: Planned

- **Week 9: Linking & Object Files (CS:APP Ch. 7)**
  - *Theory (CS:APP Ch. 7)*: Static linking, ELF relocatable object files, symbol resolution, relocations (`.text`, `.data`, `.bss`), static libraries (`.a`), shared libraries (`.so`), Position-Independent Code (PIC), library interpositioning.
  - *Zig*: Multi-module project architecture with `build.zig`, C-Interop (`@cImport`, linking against libc), static and dynamic library compilation.
  - *Infrastructure*: Secrets management in infrastructure, `TF_VAR_*` environment variable cascades, state encryption.
  - *Status*: Planned

- **Week 10: Exceptional Control Flow & Systems Programming (CS:APP Ch. 8)**
  - *Theory (CS:APP Ch. 8)*: Hardware exceptions (interrupts, traps, faults, aborts), Linux process lifecycle (`fork`, `execve`, `waitpid`), Unix signals (`SIGINT`, `SIGTERM`), POSIX system call mechanics.
  - *Zig*: **Stage 1 Capstone**: Production-grade CLI `hexdump` utility in Zig with argument parsing, error sets, and buffered I/O.
  - *Infrastructure*: **Stage 1 Capstone**: End-to-end multi-tier infrastructure testbed (reverse proxy, application service, isolated networking).
  - *Status*: Planned

### Vacation 1 (1 Week)
Cognitive decompression, personal note consolidation in Obsidian, zero new topics.

---

## 3. Stage 2: Algorithmic Thinking & Applied Mathematics (8 Weeks)

**Primary References**:
- S. Skiena — *The Algorithm Design Manual*
- Discrete Mathematics (Logic, Sets, Combinatorics, Matrix Algebra)
- Language: **Zig** (Target: v0.17)
- **Goal**: Master algorithmic complexity ($O, \Omega, \Theta$) from first principles, build fundamental data structures from scratch without standard library crutches, and understand graph algorithms powering schedulers and networks.

### Sprints

- **Week 1: Algorithmic Analysis & Discrete Foundations**
  - *Theory*: Asymptotic complexity ($O, \Omega, \Theta$), best/worst/average cases. Propositional and predicate logic.
  - *Zig*: Algorithmic benchmarking suite with high-precision monotonic timing (`clock_gettime`).
  - *Math*: Set theory, binary relations, cartesian products, mappings (injective, surjective, bijective).
  - *Infrastructure Context*: Complexity analysis of cloud scheduler algorithms.
  - *Status*: Planned

- **Week 2: Fundamental Data Structures**
  - *Theory*: Contiguous vs linked memory layout. Singly and doubly linked lists, FIFO queues, LIFO stacks.
  - *Zig*: Generic `Stack(T)` and `DoublyLinkedList(T)` with explicit allocator injection.
  - *Math*: Amortized complexity analysis (dynamic array capacity doubling strategy).
  - *Infrastructure Context*: Modeling message queues and network packet ring buffers.
  - *Status*: Planned

- **Week 3: Trees & Priority Queues**
  - *Theory*: Binary Search Trees (BST), tree balancing concepts, binary heaps (Min-Heap / Max-Heap).
  - *Zig*: In-place `MinHeap(T)` on a flat contiguous array with index arithmetic ($2i+1, 2i+2$).
  - *Math*: Tree height bounds, logarithmic depth, recurrence relations.
  - *Infrastructure Context*: Priority scheduling in worker pools.
  - *Status*: Planned

- **Week 4: Sorting & Divide-and-Conquer**
  - *Theory*: QuickSort, MergeSort, HeapSort. In-place partitioning, algorithmic stability.
  - *Zig*: In-place QuickSort implementation with median-of-three pivot selection.
  - *Math*: Master Theorem for recurrences ($T(n) = aT(n/b) + f(n)$).
  - *Infrastructure Context*: Sorting large log datasets in memory.
  - *Status*: Planned

- **Week 5: Graph Fundamentals & Traversals**
  - *Theory*: Graph representations (Adjacency Matrix vs Adjacency Lists). Breadth-First Search (BFS) and Depth-First Search (DFS).
  - *Zig*: Package dependency graph modeling, Kahn's Topological Sort algorithm.
  - *Math*: Graph connectivity, cyclic vs acyclic properties.
  - *Infrastructure Context*: How Terraform resolves resource dependency Directed Acyclic Graphs (DAG).
  - *Status*: Planned

- **Week 6: Weighted Graphs & Shortest Paths**
  - *Theory*: Dijkstra's algorithm, Bellman-Ford, Minimum Spanning Trees (Kruskal, Prim).
  - *Zig*: Dijkstra implementation backed by the priority queue from Week 3.
  - *Math*: Adjacency matrix exponentiation for path counts of length $k$.
  - *Infrastructure Context*: Network routing protocols (OSPF, BGP).
  - *Status*: Planned

- **Week 7: Dynamic Programming (DP)**
  - *Theory*: Overlapping subproblems, optimal substructure, memoization (top-down) vs tabulation (bottom-up). Knapsack problem, Longest Common Subsequence (LCS).
  - *Zig*: Memory-efficient Levenshtein distance calculation with minimal buffer allocation.
  - *Math*: State transition equations and combinatorial recurrence models.
  - *Infrastructure Context*: Optimal resource packing algorithms.
  - *Status*: Planned

- **Week 8: Stage 2 Capstone Project**
  - *Theory*: Synthesis of graph models, topological sorting, and concurrent task orchestration.
  - *Zig*: **Stage 2 Capstone**: Multi-threaded DAG Task Scheduler in Zig (dependency graph parsing, topological execution ordering, concurrent execution of independent nodes).
  - *Math*: Critical path analysis and scheduling bounds.
  - *Infrastructure Context*: Building the execution engine of an orchestration tool (like Tofu/Airflow).
  - *Status*: Planned

### Vacation 2 (1 Week)
Assimilation of algorithmic paradigms, rest, pattern consolidation.

---

## 4. Stage 3: Distributed Systems & Resilient Operations (10 Weeks)

**Primary References**:
- M. Kleppmann — *Designing Data-Intensive Applications* (DDIA)
- Google SRE Principles, Linux networking, container internals
- Language: **Zig** & Go / Python for tooling
- **Goal**: Master the architecture of scalable, fault-tolerant distributed systems, internalize replication, sharding, and consensus trade-offs, and master real-world chaos engineering.

### Sprints

- **Week 1: Reliability, Scalability & Maintainability**
  - *Theory (DDIA Ch. 1)*: Faults vs failures, reliability metrics, load parameters, latency percentiles ($p50, p95, p99, p99.9$), tail latency amplification.
  - *Engineering Lab*: Prometheus + Grafana testbed, measuring tail latencies under synthetic load.
  - *Architectural Insight*: Service Level Objectives (SLO), SLI measurement, and error budgets in SRE.
  - *Status*: Planned

- **Week 2: Data Models & Query Languages**
  - *Theory (DDIA Ch. 2)*: Relational vs Document vs Graph models. Declarative vs imperative query languages. Many-to-one and many-to-many relationships.
  - *Engineering Lab*: Workload schema design, write/read amplification benchmarking.
  - *Architectural Insight*: Schema evolution and impedance mismatch between application domain and storage layout.
  - *Status*: Planned

- **Week 3: Storage Engines & Retrieval**
  - *Theory (DDIA Ch. 3)*: Log-Structured Merge-Trees (LSM-trees) and SSTables vs B-Trees. OLTP vs OLAP workloads. Column-oriented storage (Parquet, ClickHouse).
  - *Engineering Lab*: Write-Ahead Log (WAL) mechanics; implementing an append-only log in Zig.
  - *Architectural Insight*: Trade-offs between write amplification, read amplification, and compaction strategies.
  - *Status*: Planned

- **Week 4: Encoding & Evolution**
  - *Theory (DDIA Ch. 4)*: Binary encoding formats (Protocol Buffers, Apache Thrift, Avro). Backward and forward schema compatibility contracts. RPC vs asynchronous message passing.
  - *Engineering Lab*: Protocol Buffers schema validation, binary encoding analysis.
  - *Architectural Insight*: Zero-downtime rolling upgrades with evolving data schemas.
  - *Status*: Planned

- **Week 5: Replication**
  - *Theory (DDIA Ch. 5)*: Single-leader, multi-leader, and leaderless replication. Synchronous vs asynchronous replication. Replication lag anomalies: Read-after-write, Monotonic reads, Consistent prefix reads.
  - *Engineering Lab*: PostgreSQL replicated cluster; network delay injection, reproducing stale read anomalies.
  - *Architectural Insight*: Quorum reads and writes ($W + R > N$) in leaderless systems.
  - *Status*: Planned

- **Week 6: Partitioning & Sharding**
  - *Theory (DDIA Ch. 6)*: Key-range partitioning vs Hash partitioning. Secondary indexes in partitioned databases (document-partitioned vs term-partitioned). Rebalancing partitions and mitigating hotspots.
  - *Engineering Lab*: Implementing Consistent Hashing with virtual nodes in Zig.
  - *Architectural Insight*: Partition rebalancing strategies without cluster downtime.
  - *Status*: Planned

- **Week 7: Transactions & Isolation Levels**
  - *Theory (DDIA Ch. 7)*: ACID guarantees. Isolation levels: Read Committed, Repeatable Read, Snapshot Isolation (MVCC), Serializable (2PL, SSI).
  - *Engineering Lab*: Testbed reproducing race conditions: dirty reads, non-repeatable reads, phantom reads, and write skew.
  - *Architectural Insight*: Pessimistic locking vs optimistic concurrency control in high-concurrency systems.
  - *Status*: Planned

- **Week 8: The Trouble with Distributed Systems**
  - *Theory (DDIA Ch. 8)*: Unreliable networks, packet loss, unbounded delays. Clock drift, NTP synchronization limits, monotonicity vs time-of-day. GC pauses and process pauses. Byzantine faults.
  - *Engineering Lab*: Chaos Engineering: Network packet loss and Split-Brain emulation via `iptables`/`tc`.
  - *Architectural Insight*: Designing systems assuming network partitions will occur (PACELC / CAP theorem).
  - *Status*: Planned

- **Week 9: Consistency & Consensus**
  - *Theory (DDIA Ch. 9)*: Linearizability vs serializability. Total order broadcast. Distributed transactions (Two-Phase Commit, 2PC) vs fault-tolerant consensus (Paxos, Raft).
  - *Engineering Lab*: Raft consensus simulation: Leader Election and Log Replication state machines.
  - *Architectural Insight*: Split-brain prevention, epoch numbers, and quorum leases.
  - *Status*: Planned

- **Week 10: Batch & Stream Processing & Capstone Synthesis**
  - *Theory (DDIA Ch. 10–12)*: MapReduce, stream processing, event sourcing, CQRS, unifying batch and stream architectures.
  - *Engineering Lab*: **Stage 3 Capstone**: Comprehensive Distributed Architecture Blueprint: designing a fault-tolerant, high-throughput service with reasoned storage, consensus, and IaC manifests.
  - *Architectural Insight*: End-to-end correctness and verifiable idempotency in distributed workflows.
  - *Status*: Planned

---

## 5. Knowledge Management & Artifact Standards

1. **Atomic Notes in Obsidian (`~/Documents/NEN`)**:
   - One concept per note (`[[Title]]`).
   - Objective third-person Russian, strictly no emojis.
2. **Reusable Code Templates**:
   - Each session generates structured, production-grade templates placed in dedicated directories (`week-XX-.../`).
   - Zero-allocation patterns, idiomatic error sets, explicit allocators.
