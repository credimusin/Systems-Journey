# Comprehensive Engineering Curriculum: Systems Foundations, Algorithms & Distributed Architecture

## Strategic Focus
Developing engineering intuition at the intersection of:
- Operating system mechanics and machine architecture.
- Algorithmic foundations and computational models.
- Systems programming in **Zig** (version: see `AGENTS.md` §7).
- Declarative infrastructure as code (**OpenTofu**).
- Resilient, high-throughput distributed systems (**DDIA / SRE**).

### How this plan works
- The plan is **chapter-driven**. Sprints are ordered by the books; the **Book Coverage Map** (§6) lists every chapter and its status at section level.
- One sprint ≈ one week ≈ 25-35 pages of theory (2 h). Big chapters are split across sprints.
- The **Infrastructure track** (Saturdays) is an ordered queue (§5), independent of book sprints. A book sprint slipping does not shift infra, and vice versa.
- Status rules and the order guard: `AGENTS.md` §4.

---

## 1. Methodology & Time Allocation (6.5 h / week)

| Day | Time Window | Modality | Focus |
| :--- | :--- | :--- | :--- |
| **Monday** | 07:30 – 08:30 (1h) | Theory & Notes | Current book sprint |
| **Tuesday** | 18:00 – 19:00 (1h) | Practical Coding | Zig task of the sprint |
| **Wednesday** | 07:30 – 08:30 (1h) | Theory & Notes | Current book sprint (continuation) |
| **Thursday** | 18:00 – 19:00 (1h) | Practical Coding | Zig task of the sprint |
| **Friday** | — | Rest | — |
| **Saturday** | 10:00 – 12:30 (2.5h) | Engineering Lab | Infrastructure track (§5) |
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
- **S1W7** — Ch. 4 Processor Architecture & Hazards (Y86-64, PIPE, Forwarding, Load-Use). Zig decoder & hazard detector. — **Done**
- **S1W8** — Ch. 5.1-5.9 Optimizing Performance (Out-of-order, latency vs throughput, loop unrolling, multiple accumulators). Zig 4x4 benchmark. — **Done**

### Current
- **S1W6: Memory Hierarchy — finish Ch. 6** (pp. 553-616)
  - *Done*: 6.1 Storage technologies, 6.2 Locality, 6.3 Memory hierarchy. Matrix row/column benchmark.
  - *Remaining*: 6.4 Cache memories (S, E, B; direct-mapped, set-associative, fully associative; write policies), 6.5 Cache-friendly code, 6.6 Memory mountain, blocking.
  - *Zig*: Blocked (tiled) matrix multiplication vs naive; stride/size benchmark ("memory mountain" lite).
  - *Status*: **In Progress**

### Next
- **S1W9: Optimizing Performance II — Ch. 5.10-5.14 + Ch. 2.4 Floating point** (pp. 524-544, 135-151)
  - *Theory*: Register spilling, branch prediction penalty, memory performance, profiling (5.14). IEEE 754: format, rounding, why float addition is not associative (explains why compilers cannot reassociate float loops from 5.9).
  - *Zig*: SIMD with `@Vector`; float vs int reassociation experiment; profiling with `perf`.
  - *Status*: Planned

- **S1W10: Linking — Ch. 7** (pp. 634-673)
  - *Theory*: Static linking, ELF relocatable objects, symbols and resolution, relocation, executables and loading, shared libraries, PIC (GOT/PLT), interpositioning.
  - *Zig*: Multi-module `build.zig`, `@cImport`, static and dynamic library; inspect with `readelf`, `nm`, `objdump`.
  - *Status*: Planned

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

## 3. Stage 2: Algorithms & Applied Math (Skiena) — 9 sprints

**Book**: S. Skiena — *The Algorithm Design Manual*, 3rd ed. Plus discrete math (logic, sets, combinatorics).
**Goal**: Complexity from first principles, data structures from scratch in Zig, graph algorithms behind schedulers and networks.

- **S2W1: Analysis & Discrete Foundations — Ch. 1-2**
  - *Theory*: Correctness, induction, modeling (Ch. 1); RAM model, Big-O/Ω/Θ, growth rates, summations, logarithms (Ch. 2).
  - *Math*: Propositional logic, sets, relations, functions (injective/surjective/bijective).
  - *Zig*: Benchmarking harness with monotonic clock.
  - *Status*: Planned

- **S2W2: Fundamental Data Structures — Ch. 3.1-3.3**
  - *Theory*: Contiguous vs linked, stacks, queues, dictionaries.
  - *Math*: Amortized analysis (dynamic array doubling).
  - *Zig*: Generic `Stack(T)`, `DoublyLinkedList(T)` with injected allocator.
  - *Status*: Planned

- **S2W3: Trees & Priority Queues — Ch. 3.4-3.5, 4.3**
  - *Theory*: BST, balancing — concepts, binary heaps, heapsort.
  - *Zig*: In-place `MinHeap(T)` on a flat array ($2i+1$, $2i+2$).
  - *Status*: Planned

- **S2W4: Hashing — Ch. 3.7, Ch. 6**
  - *Theory*: Hash tables (chaining, open addressing), probability review, balls and bins, Bloom filters, birthday paradox, Rabin-Karp.
  - *Zig*: Open-addressing `HashMap(K, V)`; Bloom filter.
  - *Infra context*: Bloom filters in LSM-trees (DDIA Ch. 3), hash partitioning (DDIA Ch. 6).
  - *Status*: Planned

- **S2W5: Sorting & Divide-and-Conquer — Ch. 4, Ch. 5.1-5.4**
  - *Theory*: Quicksort, mergesort, stability; binary search; recurrences, Master Theorem ($T(n) = aT(n/b) + f(n)$).
  - *Zig*: In-place quicksort with median-of-three.
  - *Status*: Planned

- **S2W6: Graph Traversal — Ch. 7**
  - *Theory*: Representations, BFS, DFS, DFS on directed graphs, topological sort.
  - *Zig*: Dependency graph + Kahn's topological sort.
  - *Infra context*: How OpenTofu builds its resource DAG.
  - *Status*: Planned

- **S2W7: Weighted Graphs — Ch. 8.1-8.3**
  - *Theory*: MST (Prim, Kruskal, union-find), shortest paths (Dijkstra, Floyd-Warshall).
  - *Zig*: Dijkstra on the S2W3 heap.
  - *Infra context*: OSPF/BGP routing.
  - *Status*: Planned

- **S2W8: Dynamic Programming — Ch. 10.1-10.3**
  - *Theory*: Memoization vs tabulation, edit distance, LIS.
  - *Zig*: Levenshtein distance with O(n) memory.
  - *Status*: Planned

- **S2W9: Stage 2 Capstone**
  - *Zig*: Multi-threaded DAG task scheduler: parse dependencies, topological order, run independent nodes in parallel (uses S1W16 concurrency).
  - *Math*: Critical path analysis.
  - *Status*: Planned

### Vacation 2 (1 week)

---

## 4. Stage 3: Distributed Systems (DDIA) — 14 sprints

**Book**: M. Kleppmann — *Designing Data-Intensive Applications* (RU translation of the 1st ed., 12 chapters). Plus SRE principles, Linux networking.
**Language**: Zig, Go/Python for tooling.

- **S3W0: Network Programming bridge — CS:APP Ch. 11** (pp. 854-896)
  - *Theory*: Client-server model, IP, DNS, sockets interface, HTTP, TINY web server.
  - *Zig*: TCP echo server, then a tiny HTTP server.
  - *Status*: Planned

- **S3W1: Reliability, Scalability, Maintainability — DDIA Ch. 1**
  - *Theory*: Faults vs failures, load parameters, percentiles ($p50$-$p99.9$), tail latency amplification.
  - *Lab*: Prometheus + Grafana, tail latency under synthetic load. SLO/SLI, error budgets.
  - *Status*: Planned

- **S3W2: Data Models & Query Languages — DDIA Ch. 2**
  - *Theory*: Relational vs document vs graph, declarative vs imperative queries.
  - *Lab*: Schema design for one workload in two models.
  - *Status*: Planned

- **S3W3: Storage & Retrieval — DDIA Ch. 3**
  - *Theory*: Hash indexes, SSTables, LSM-trees, B-trees, OLTP vs OLAP, column storage.
  - *Zig*: Append-only log with a hash index (WAL mechanics).
  - *Status*: Planned

- **S3W4: Encoding & Evolution — DDIA Ch. 4**
  - *Theory*: JSON/binary encodings, Protobuf, Thrift, Avro, schema compatibility, RPC vs messaging.
  - *Lab*: Protobuf schema evolution experiment.
  - *Status*: Planned

- **S3W5: Replication — DDIA Ch. 5**
  - *Theory*: Single-leader, multi-leader, leaderless; replication lag anomalies; quorums ($W + R > N$).
  - *Lab*: PostgreSQL replica, delay injection, stale reads.
  - *Status*: Planned

- **S3W6: Partitioning — DDIA Ch. 6**
  - *Theory*: Key-range vs hash partitioning, secondary indexes, rebalancing, request routing.
  - *Zig*: Consistent hashing with virtual nodes.
  - *Status*: Planned

- **S3W7: Transactions — DDIA Ch. 7**
  - *Theory*: ACID, read committed, snapshot isolation (MVCC), serializability (2PL, SSI), write skew.
  - *Lab*: Reproduce dirty reads, lost updates, write skew in PostgreSQL.
  - *Status*: Planned

- **S3W8: Trouble with Distributed Systems — DDIA Ch. 8**
  - *Theory*: Unreliable networks, clocks, process pauses, knowledge and truth, Byzantine faults.
  - *Lab*: Packet loss and split-brain via `tc` / `iptables`.
  - *Status*: Planned

- **S3W9: Consistency & Consensus I — DDIA Ch. 9 (first half)**
  - *Theory*: Linearizability, CAP, ordering guarantees, total order broadcast.
  - *Status*: Planned

- **S3W10: Consistency & Consensus II — DDIA Ch. 9 (second half)**
  - *Theory*: Distributed transactions (2PC), fault-tolerant consensus, membership and coordination services.
  - *Lab*: Raft simulation: leader election and log replication.
  - *Status*: Planned

- **S3W11: Batch Processing — DDIA Ch. 10**
  - *Theory*: Unix philosophy, MapReduce, joins, dataflow engines.
  - *Lab*: Unix-pipeline log analysis vs a small MapReduce.
  - *Status*: Planned

- **S3W12: Stream Processing — DDIA Ch. 11**
  - *Theory*: Message brokers, logs, CDC, event sourcing, stream joins, fault tolerance.
  - *Lab*: Kafka/Redpanda testbed, CDC from PostgreSQL.
  - *Status*: Planned

- **S3W13: Future of Data Systems + Capstone — DDIA Ch. 12**
  - *Theory*: Data integration, unbundling databases, end-to-end correctness, idempotency.
  - *Capstone*: Architecture blueprint of a fault-tolerant service: storage, replication, consensus choices, IaC manifests.
  - *Status*: Planned

---

## 5. Infrastructure Track (Saturdays, ordered queue)

Independent of book sprints. Take the next item; mark status here.

| # | Topic | Status |
| :--- | :--- | :--- |
| I1 | OpenTofu CLI, Docker/Podman provider, rootless containers | Done |
| I2 | State file, variables, outputs | Done |
| I3 | Local child modules, inputs/outputs scoping | Done |
| I4 | `count`, `for_each`, conditionals, dynamic expressions | Done |
| I5 | Remote S3 backend (MinIO), state locking, state migration | Done |
| I6 | `templatefile`, volumes, persistent storage | Done |
| I7 | CI pipeline for OpenTofu: fmt, validate, lint, drift detection | Next |
| I8 | Lifecycle (`create_before_destroy`, `prevent_destroy`), `-parallelism` | Planned |
| I9 | Secrets: `TF_VAR_*`, sensitive values, state encryption | Planned |
| I10 | Container internals: namespaces, cgroups (pairs with CS:APP Ch. 8-9) | Planned |
| I11 | Network virtualization: netns, veth, bridges, iptables (pairs with CS:APP Ch. 11) | Planned |
| I12 | **Stage 1 Infra Capstone**: multi-tier testbed (reverse proxy, app, isolated networks) | Planned |
| I13+ | Stage 3 labs (Prometheus/Grafana, PostgreSQL replication, chaos) take over the Saturday slot | Planned |

---

## 6. Book Coverage Map (source of truth)

Statuses: `Done`, `In Progress`, `Planned (SxWy)`, `Deferred → SxWy`, `Skipped (reason)`, `Optional`. Rules: `AGENTS.md` §4.3.

### CS:APP (RU, 3rd ed.)
| Ch. | Sections | Pages | Sprint | Status |
| :--- | :--- | :--- | :--- | :--- |
| 1 | 1.1-1.10 Tour of computer systems | 36-61 | S1W1 | Done |
| 2 | 2.1-2.2 Storage, integer representations | 68-113 | S1W2 | Done |
| 2 | 2.3 Integer arithmetic | 113-135 | S1W2 | Done |
| 2 | 2.4 Floating point | 135-151 | S1W9 | Deferred → S1W9 |
| 3 | 3.1-3.5 Data formats, access, arithmetic | 187-218 | S1W3 | Done |
| 3 | 3.6 Control | 218-250 | S1W4 | Done |
| 3 | 3.7 Procedures | 250-264 | S1W5 | Done |
| 3 | 3.8-3.9 Arrays, structures, alignment | 264-282 | S1W5 | Done |
| 3 | 3.10 Pointers, gdb, buffer overflow, VLA | 282-298 | S1W5 | Done |
| 3 | 3.11 Floating-point code | 298-312 | S1W9 | Optional (with 2.4) |
| 4 | 4.1, 4.3.1, 4.4, 4.5 hazards — overview | 352-457 | S1W7 | Done |
| 4 | 4.2 HCL, SEQ/PIPE hardware details | 368-457 | — | Optional |
| 5 | 5.1-5.9 Optimization, ILP, unrolling | 478-524 | S1W8 | Done |
| 5 | 5.10-5.15 Limits, memory perf, profiling | 524-544 | S1W9 | Planned |
| 6 | 6.1-6.3 Storage, locality, hierarchy | 554-586 | S1W6 | Done |
| 6 | 6.4-6.7 Caches, cache-friendly code, memory mountain | 586-616 | S1W6 | In Progress |
| 7 | 7.1-7.15 Linking | 634-673 | S1W10 | Planned |
| 8 | 8.1-8.4 Exceptions, processes, process control | 680-712 | S1W11 | Planned |
| 8 | 8.5-8.8 Signals, nonlocal jumps | 712-739 | S1W12 | Planned |
| 9 | 9.1-9.8 VM, translation, mmap | 750-786 | S1W13 | Planned |
| 9 | 9.9-9.12 Dynamic allocation, GC, memory bugs | 786-819 | S1W14 | Planned |
| 10 | 10.1-10.12 System-level I/O | 830-851 | S1W15 | Planned |
| 11 | 11.1-11.7 Network programming | 854-896 | S3W0 | Planned |
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

## 7. Knowledge Management

1. **Session notes in Obsidian** (`/var/home/bmo/Documents/NEN`): one note per session topic, linked to a MOC (e.g. `[[Архитектура компьютеров]]`). Schema: `AGENTS.md` §6.1. Russian text, no emojis.
2. **Practice code**: written by the user in `stage<N>/w<NN>-<topic>/` directories. Goal: reusable reference code — idiomatic Zig, explicit allocators, clear error sets.
