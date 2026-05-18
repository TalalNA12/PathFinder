---
description: # Workflow: Run DOS Assembly (MASM)
---

**Trigger Command:** `/run-dos-asm`

**Execution Protocol:**
1. Identify the currently active `.asm` file in the editor. Extract its base filename without the extension (referred to as `[FILENAME]`).
2. Generate a temporary DOSBox build sequence that executes the following commands sequentially:
   - `mount c .` (Mount the current workspace root as drive C)
   - `c:` (Switch to the mounted drive)
   - `masm [FILENAME].asm;` (Assemble the code into an object file, bypassing prompts)
   - `link [FILENAME].obj;` (Link the object file into an executable, bypassing prompts)
   - `[FILENAME].exe` (Execute the compiled binary)
   - `exit` (Terminate the DOSBox instance automatically)
3. Execute the DOSBox instance silently in the background via the integrated terminal.
4. Intercept the standard output and standard error logs.
5. Parse the logs: 
   - If `masm` or `link` generates syntax errors or warnings, print the exact error lines to this chat interface.
   - If compilation is successful, print the final execution output of `[FILENAME].exe` to this chat interface.