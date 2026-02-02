
# Tasks: Tactics vs. Strategy

Imagine a general sitting in a command tent. They point to a map and say, "Capture that hill." That is **Strategy**. It's a high-level objective that might take days and involve thousands of individual moves.

Now imagine the sergeant on the field. They don't just yell "Capture the hill!" repeatedly. They yell, "Provide covering fire!", "Alpha squad, flank left!", "Reloading!", "Clear that bunker!" That is **Tactics**. These are immediate, concrete actions taken in the heat of the moment to achieve the strategic goal.

Ralph, being an autonomous agent, needs both. He needs to know *what* to build (Strategy) and *how* to execute the immediate steps (Tactics). To handle this, Ralph uses two distinct task systems.

## The Strategy: Code Tasks

**Code Tasks** are the General's orders. They are the software engineering goals provided by you, the user.

*   **Example**: "Implement User Authentication", "Refactor the payment gateway", "Fix the memory leak in the parser."
*   **Persistence**: These tasks are long-lived. They sit in the `tasks/` directory as Markdown files (e.g., `tasks/01-auth.code-task.md`). They persist across many sessions until the feature is fully implemented and merged.
*   **Audience**: Humans and Agents. You read them to know project status; Ralph reads them to know what he's supposed to be working on.

## The Tactics: Runtime Tasks

**Runtime Tasks** are the Sergeant's checklist. They are the ephemeral, granular steps Ralph creates for himself to keep track of his immediate work during a loop.

*   **Example**: "Read `src/auth.ts` to check imports", "Run `grep` to find usage of `login()`", "Create file `src/login_handler.ts`", "Run tests for auth module."
*   **Persistence**: These are short-lived. They live in a hidden file (`.agent/tasks.jsonl`) and are often created, completed, and cleared within a few iterations of the Loop.
*   **Audience**: Ralph only. You usually don't care that Ralph needs to "grep for imports" before he writes code; you just want the code written.

## Why Separate Them?

Why not just have one big list? Because **detail is the enemy of clarity**.

If your project roadmap (Strategy) was cluttered with thousands of entries like "fix typo in comment" or "rerun failed test," you'd never be able to see the big picture. Conversely, if Ralph only had the high-level instruction "Build Auth," he would lack the granular checklist needed to maintain focus while navigating complex codebases.

By separating **Code Tasks** (What we are building) from **Runtime Tasks** (Steps to build it), Ralph maintains a clean project board for you while keeping a rigorous, detailed checklist for himself.

*   **Code Tasks** = The Destination.
*   **Runtime Tasks** = The Steps to get there.
