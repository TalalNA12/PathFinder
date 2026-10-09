# PathFinder: 16-Bit Interactive DFS Traversal Engine


changes made here hehe a
## 🚀 Core Features
* **Flattened Memory Matrix:** Dynamically maps a 2D graph structure into a continuous 1D 25-byte memory space using low-level register math.
* **Hardware-Level Recursion:** Implements a recursive DFS engine utilizing the CPU hardware call stack.
* **Loop Mitigation Firewall:** Employs a dedicated tracking array (`visited`) to intercept cyclic paths and prevent stack overflows or infinite loops.
* **Interactive Terminal UI:** Pauses execution for single-keystroke hardware interrupts (`INT 21h / AH=01h`), performing instant ASCII-to-integer conversions and input validation (bounds: 0–4).

---

## 👥 Group 11: Division of Labor

To ensure structural clarity, the project architecture is split into three distinct operational vectors:

### 🟢 Operative 1: Memory Architect (Data & Graph Mapping)
* **Responsibilities:** Memory segment initialization, data allocation, and flat-matrix coordinate mapping.
* **Core Contributions:**
    * Designed the `.data` segment variables (`adj_matrix`, `visited`, and UI strings).
    * Developed the `ADD_EDGE` macro to calculate 2D-to-1D index offsets via register math:  
        $$\text{Offset} = (\text{Source} \times \text{MAX\_NODES}) + \text{Destination}$$
    * Protected register states across macro boundaries using `PUSH`/`POP` blocks to avoid data corruption.

### 🔴 Operative 2: Core Engine (DFS Algorithm)
* **Responsibilities:** Algorithm design, call-stack tracking, and traversal logic execution.
* **Core Contributions:**
    * Implemented the recursive `EXECUTE_DFS` procedure.
    * Structured the adjacent node lookup loop (`scan_loop`) by reading direct memory flags.
    * Enforced the `visited` array firewall to detect previously traversed nodes and terminate cyclic loops safely.

### 🔵 Operative 3: Terminal UI (Input & Control Flow)
* **Responsibilities:** User interface orchestration, hardware interrupts, and error boundaries.
* **Core Contributions:**
    * Structured the main entry point loop (`main proc`) and initialized the segment registers (`DS`).
    * Handled the keyboard input interrupt sequence and executed character-to-integer normalization (`SUB AL, 30h`).
    * Built the validation firewall to catch out-of-bounds node requests (e.g., input values $> 4$ or $< 0$) and halt the system with a `FATAL` error state.

---

## 🛠️ Compilation & Execution

The project is built to execute natively inside a 16-bit DOS environment using standard MASM utilities.

### Direct DOSBox Execution
1. Launch **DOSBox**.
2. Mount your local project workspace directory to drive `C`:
   ```console
   mount c "C:\Path\To\Your\New folder"
   c:
Assemble and compile the source code using MASM:

Shell
masm pathfind.asm;
Link the object code to produce the final executable:

Shell
link pathfind.obj;
Run the application:

Shell
pathfind.exe
📊 Graph Topology Setup
The application compiles with the following default directed graph configuration:

Plaintext
(0) ----> (1) ----> (3) [Dead End]
 |         ^
 |         |
 v         |
(2) ----> (4)
Cycle Handling: Node 4 links back to Node 1. When starting traversal from Node 0 or Node 2, the visited array firewall safely intercepts the cycle at Node 4 to prevent system crash or loop deadlocks.


This is ready to be committed and pushed to your GitHub repo alongside `pathfind.asm`. If you need any adjustments to the names or specific wording before you hand it in, just let me know!
