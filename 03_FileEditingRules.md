# 03_FileEditingRules.md

- **Version:** 1.0.0
- **Status:** APPROVED & ENFORCED
- **Owner:** DevOps Architect & Platform Security Lead
- **Last Updated:** October 2023
- **Related Documents:**
  - `CODING_CONSTITUTION.md`
  - `01_AIDevelopmentGuide.md`
  - `02_FlutterCodingStandards.md`
  - `06_DefinitionOfDone.md`

---

## 1. Executive Summary

To prevent technical debt, layout decay, compilation errors, and security vulnerabilities inside the BankYar ecosystem, this document defines the governance rules regarding what source files an AI agent may read and modify, how file modifications must be structured, and the policies for deletes, renames, and workspace updates.

---

## 2. Purpose & Scope

### Purpose
To explicitly outline the file access permissions for autonomous or assisted AI agents inside the BankYar project.

### Scope
Applies to all read, write, rename, deletion, and folder creation commands executed by an AI agent on the repository.

---

## 3. Definitions

| Term | Definition |
| :--- | :--- |
| **Whitelisted File** | A file that AI agents are permitted to modify directly with standard tools. |
| **Blacklisted File** | A protected system configuration file that AI must never alter without explicit human overrides. |
| **Atomic Modification** | Small, target-specific changes isolated to a single layer or vertical feature directory. |
| **Breaking Change** | Alteration of a public interface, class signature, or DB schema that invalidates downstream code. |

---

## 4. Protected Ecosystem Boundaries

AI agents are restricted on which files they may modify. The governance matrix is as follows:

```
       +--------------------------------------------------------+
       |                  FILE ACCESS MATRIX                    |
       +--------------------------------------------------------+
       |   PERMITTED CHANGES       |    PROTECTED (READ ONLY)   |
       +---------------------------+----------------------------+
       |  - lib/features/*         |  - android/app/src/main/*  |
       |  - test/*                 |  - ios/*                   |
       |  - pubspec.yaml (docs)    |  - lib/core/database/*     |
       |  - lib/core/utils/*       |  - analysis_options.yaml   |
       +---------------------------+----------------------------+
```

### Whitelisted Directories (AI May Read & Edit)
- `lib/features/[any_feature]/data/`
- `lib/features/[any_feature]/domain/`
- `lib/features/[any_feature]/presentation/`
- `test/features/[any_feature]/`

### Blacklisted Areas (AI Must Never Modify Without Human Approval)
- `android/` (Specifically the core `AndroidManifest.xml` to prevent any injection of `android.permission.INTERNET`).
- `ios/` (Specifically target plist files or native storage sandboxes).
- `lib/core/database/` (Protected core migration and DB initialization scripts).
- `analysis_options.yaml` (Protected lint and compiler restriction configurations).

---

## 5. Maximum Scope of Change & Safe Editing Strategy

- **Atomic Changes Only:** A single prompt execution or automated commit must target only **one vertical slice or feature layer** at a time. AI must not refactor presentation layers while simultaneously updating database entities.
- **Lines of Change Gate:** AI code outputs must not exceed **200 modified lines** per file in a single action to prevent context degradation and maintain high quality.
- **Search-and-Replace Formatting:** When applying a change inside an existing file, the AI must use precise line-targeted replacements rather than overwriting entire files to avoid deleting surrounding comments or layout parameters.

---

## 6. Workspace Structural Policies

### Deletion & Rename Policy
- AI is **forbidden** from deleting any source file containing active production code unless explicitly requested by a human supervisor to remove legacy implementations.
- If a file needs to be renamed (e.g. to conform to the strict naming matrices in `02_FlutterCodingStandards.md`), the AI must update all downstream import statements across the workspace in the same step.

### Directory Scaffolding Policy
- Before creating a new feature folder hierarchy, the AI must check if the directory already exists to prevent duplicate file structure generation.
- All new features must contain the standard modular layout (`data`, `domain`, `presentation`).

---

## 7. Migration & Breaking Change Policies

- **Database Migrations:** Schema changes inside SQLCipher tables must follow strict version progression inside the localized DB manager. AI must write backward-compatible raw SQL scripts that guarantee zero local data loss for users.
- **Breaking API Changes:** If an abstract contract method is updated, the AI must immediately refactor all concrete classes implementing that interface inside the current branch to avoid broken compile cycles.

---

## 8. Best Practices & Examples

### Best Practices
- **Inspect Boundaries First:** Always read the corresponding abstract interface and package boundaries before proposing structural file updates.
- **Micro-Commits:** Apply changes incrementally, verifying compilation on each step.

### Example of Safe Change Proposal
```markdown
Change Scope: Modify only presentation layer of `notes` feature to support updated UI states.
Files Modified: `lib/features/notes/presentation/screens/notes_list_screen.dart`
Lines Altered: 24 lines (Targeted search-and-replace replacement)
```

---

## 9. Common Mistakes & Anti-patterns

- **The "Over-Sized Patch":** Attempting to modify UI files and database models within the same file-edit block.
- **The "Silent Delete":** Deleting unused model files without running full static validation, resulting in compiler breakages in surrounding features.
- **Anti-pattern - "Direct Configuration Override":** Overwriting gradle configurations to bypass compiler strict modes.

---

## 10. Recommendations & Implementation Notes

- **Git Branch Isolations:** Perform edits inside dedicated feature branches.
- **Local Dev Sandbox:** Use localized `run_in_bash_session` to test formatting compliance before requesting review.

---

## 11. Output Report Format

Upon executing any workspace modification, the AI agent must output a clean, formatted report detailing the action taken:

```markdown
### AI WORKSPACE MODIFICATION REPORT

- **Feature Affected:** [Feature Name]
- **Layer Targeted:** [Presentation | Domain | Data | Core]
- **Created Files:**
  - `path/to/created_file.dart`
- **Modified Files:**
  - `path/to/modified_file.dart`
- **Compiling Verification:** [Pass / Fail]
- **Tests Executed & Coverage achieved:** [Status & Coverage %]
```

---

## 12. Review Checklist

- [ ] Verify `AndroidManifest.xml` was not altered.
- [ ] Ensure `analysis_options.yaml` compiler overrides remain untouched.
- [ ] Check that no file exceeds the 300-line operational cap.

---

## 13. Future Improvements

- **Programmatic Pre-Commit Hooks:** Integrate script-based git hooks that reject commits if files exceeding whitelisted locations are modified by automated agents.

---
**End of Document**
