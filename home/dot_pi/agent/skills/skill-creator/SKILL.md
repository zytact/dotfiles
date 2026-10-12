---
name: skill-creator
description: Guide for creating effective Pi skills. Use when users want to create a new skill or update an existing one that extends Pi with specialized knowledge, workflows, helper scripts, or tool integrations.
metadata:
  short-description: Create or update a skill
---

# Skill Creator

This skill provides guidance for creating effective Pi skills.

## About Skills

Skills are modular, self-contained folders that extend Pi by providing specialized knowledge, workflows, and tools. Think of them as onboarding guides for specific domains or tasks - they help Pi act like a specialized agent with procedural knowledge, project conventions, and reusable helpers.

### What Skills Provide

1. Specialized workflows - Multi-step procedures for specific domains
2. Tool integrations - Instructions for working with specific file formats or APIs
3. Domain expertise - Company-specific knowledge, schemas, business logic
4. Bundled resources - Scripts, references, and assets for complex and repetitive tasks

## Core Principles

### Concise is Key

The context window is a public good. Skills share the context window with everything else Pi needs: system prompt, conversation history, other skills' metadata, and the actual user request.

**Default assumption: Pi is already very smart.** Only add context Pi does not already have. Challenge each piece of information: "Does Pi really need this explanation?" and "Does this paragraph justify its token cost?"

Prefer concise examples over verbose explanations.

### Set Appropriate Degrees of Freedom

Match the level of specificity to the task's fragility and variability:

**High freedom (text-based instructions)**: Use when multiple approaches are valid, decisions depend on context, or heuristics guide the approach.

**Medium freedom (pseudocode or scripts with parameters)**: Use when a preferred pattern exists, some variation is acceptable, or configuration affects behavior.

**Low freedom (specific scripts, few parameters)**: Use when operations are fragile and error-prone, consistency is critical, or a specific sequence must be followed.

Think of Pi as exploring a path: a narrow bridge with cliffs needs specific guardrails (low freedom), while an open field allows many routes (high freedom).

### Anatomy of a Skill

Every skill consists of a required `SKILL.md` file and optional bundled resources:

```
skill-name/
├── SKILL.md              # Required: frontmatter + instructions
├── scripts/              # Optional executable helpers
├── references/           # Optional docs to load on demand
└── assets/               # Optional files used in outputs
```

#### SKILL.md (required)

Every `SKILL.md` consists of:

- **Frontmatter** (YAML): Must contain `name` and `description`. Pi always reads these fields to decide when the skill should trigger, so make the description concrete and specific.
- **Body** (Markdown): Instructions and guidance for using the skill. Pi loads this only after the skill is selected.

Optional frontmatter fields supported by Pi include `license`, `compatibility`, `metadata`, `allowed-tools`, and `disable-model-invocation`. Only add them when they materially help.

#### Bundled Resources (optional)

##### Scripts (`scripts/`)

Executable code (Python/Bash/etc.) for tasks that require deterministic reliability or are repeatedly rewritten.

- **When to include**: When the same code is being rewritten repeatedly or deterministic reliability is needed
- **Example**: `scripts/rotate_pdf.py` for PDF rotation tasks
- **Benefits**: Token efficient, deterministic, may be executed without loading into context
- **Note**: Scripts may still need to be read by Pi for patching or environment-specific adjustments

##### References (`references/`)

Documentation and reference material intended to be loaded as needed into context to inform Pi's process and thinking.

- **When to include**: For documentation that Pi should reference while working
- **Examples**: `references/finance.md` for financial schemas, `references/mnda.md` for company NDA template, `references/policies.md` for company policies, `references/api_docs.md` for API specifications
- **Use cases**: Database schemas, API documentation, domain knowledge, company policies, detailed workflow guides
- **Benefits**: Keeps SKILL.md lean, loaded only when Pi determines it is needed
- **Best practice**: If files are large (>10k words), include grep or navigation hints in SKILL.md
- **Avoid duplication**: Information should live in either SKILL.md or references files, not both. Prefer references files for detailed information unless it is truly core to the skill - this keeps SKILL.md lean while making information discoverable without hogging the context window. Keep only essential procedural instructions and workflow guidance in SKILL.md; move detailed reference material, schemas, and examples to references files.

##### Assets (`assets/`)

Files not intended to be loaded into context, but rather used within the output Pi produces.

- **When to include**: When the skill needs files that will be used in the final output
- **Examples**: `assets/logo.png` for brand assets, `assets/slides.pptx` for PowerPoint templates, `assets/frontend-template/` for HTML/React boilerplate, `assets/font.ttf` for typography
- **Use cases**: Templates, images, icons, boilerplate code, fonts, sample documents that get copied or modified
- **Benefits**: Separates output resources from documentation, enables Pi to use files without loading them into context

#### What to Not Include in a Skill

A skill should only contain essential files that directly support its functionality. Do not create extraneous documentation or auxiliary files, including:

- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- etc.

The skill should only contain the information needed for an AI agent to do the job at hand. It should not contain auxiliary context about the process that went into creating it, setup and testing procedures unrelated to the task, user-facing documentation, etc. Creating additional documentation files just adds clutter and confusion.

### Progressive Disclosure Design Principle

Skills use a three-level loading system to manage context efficiently:

1. **Metadata (name + description)** - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<5k words)
3. **Bundled resources** - As needed by Pi

#### Progressive Disclosure Patterns

Keep SKILL.md body to the essentials and under 500 lines to minimize context bloat. Split content into separate files when approaching this limit. When splitting content into other files, reference them from SKILL.md and describe clearly when to read them.

**Key principle:** When a skill supports multiple variations, frameworks, or options, keep only the core workflow and selection guidance in SKILL.md. Move variant-specific details (patterns, examples, configuration) into separate reference files.

**Pattern 1: High-level guide with references**

```markdown
# PDF Processing

## Quick start

Extract text with pdfplumber:
[code example]

## Advanced features

- **Form filling**: See [FORMS.md](FORMS.md) for complete guide
- **API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
- **Examples**: See [EXAMPLES.md](EXAMPLES.md) for common patterns
```

Pi loads those extra files only when needed.

**Pattern 2: Domain-specific organization**

For skills with multiple domains, organize content by domain to avoid loading irrelevant context:

```
bigquery-skill/
├── SKILL.md
└── references/
    ├── finance.md
    ├── sales.md
    ├── product.md
    └── marketing.md
```

When a user asks about sales metrics, Pi only needs `sales.md`.

Similarly, for skills supporting multiple frameworks or variants, organize by variant:

```
cloud-deploy/
├── SKILL.md
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```

**Pattern 3: Conditional details**

Show basic content, link to advanced content:

```markdown
# DOCX Processing

## Creating documents

Use docx-js for new documents. See [DOCX-JS.md](DOCX-JS.md).

## Editing documents

For simple edits, modify the XML directly.

**For tracked changes**: See [REDLINING.md](REDLINING.md)
**For OOXML details**: See [OOXML.md](OOXML.md)
```

**Important guidelines:**

- **Avoid deeply nested references** - Keep references one level deep from SKILL.md. All reference files should link directly from SKILL.md.
- **Structure longer reference files** - For files longer than 100 lines, include a table of contents at the top so Pi can see the full scope when previewing.

## Skill Creation Process

Skill creation involves these steps:

1. Understand the skill with concrete examples
2. Plan reusable skill contents (scripts, references, assets)
3. Initialize the skill if needed (`scripts/init_skill.py`)
4. Edit the skill (implement resources and write `SKILL.md`)
5. Validate the skill (`scripts/quick_validate.py`)
6. Iterate based on real usage

Follow these steps in order, skipping only if there is a clear reason why they are not applicable.

### Skill Naming

- Use lowercase letters, digits, and hyphens only; normalize user-provided titles to hyphen-case (for example, `Plan Mode` -> `plan-mode`).
- Generate a name under 64 characters.
- Prefer short, verb-led phrases that describe the action.
- Name the skill folder after the skill name when practical, even though Pi does not require an exact match.

### Step 1: Understanding the Skill with Concrete Examples

Skip this step only when the skill's usage patterns are already clearly understood. It remains valuable even when working with an existing skill.

To create an effective skill, clearly understand concrete examples of how the skill will be used. This understanding can come from either direct user examples or generated examples that are validated with user feedback.

To avoid overwhelming users, avoid asking too many questions in a single message. Start with the most important questions and follow up as needed.

Conclude this step when there is a clear sense of the functionality the skill should support.

### Step 2: Planning the Reusable Skill Contents

To turn concrete examples into an effective skill, analyze each example by:

1. Considering how to execute on the example from scratch
2. Identifying what scripts, references, and assets would be helpful when executing these workflows repeatedly

Examples:

- A `pdf-editor` skill may need a `scripts/rotate_pdf.py` helper.
- A `frontend-webapp-builder` skill may need an `assets/hello-world/` template.
- A `big-query` skill may need a `references/schema.md` file.

### Step 3: Initializing the Skill

When creating a new skill from scratch, run `scripts/init_skill.py` if it is available in this skill. It generates a minimal Pi-friendly template skill directory.

Usage:

```bash
scripts/init_skill.py <skill-name> --path <output-directory> [--resources scripts,references,assets] [--examples]
```

Examples:

```bash
scripts/init_skill.py my-skill --path skills/public
scripts/init_skill.py my-skill --path skills/public --resources scripts,references
scripts/init_skill.py my-skill --path skills/public --resources scripts --examples
```

The script:

- Creates the skill directory at the specified path
- Generates a `SKILL.md` template with proper frontmatter and TODO placeholders
- Optionally creates resource directories based on `--resources`
- Optionally adds example files when `--examples` is set

After initialization, customize `SKILL.md` and add resources as needed. If you used `--examples`, replace or delete placeholder files.

### Step 4: Edit the Skill

Remember that the skill is being created for another Pi instance to use. Include information that would be beneficial and non-obvious to Pi. Consider what procedural knowledge, domain-specific details, or reusable assets would help another Pi instance execute these tasks more effectively.

#### Start with Reusable Skill Contents

Begin implementation with the reusable resources identified above: `scripts/`, `references/`, and `assets/` files. This may require user input.

Added scripts must be tested by actually running them to ensure there are no bugs and that the output matches what is expected. If there are many similar scripts, test a representative sample.

If you used `--examples`, delete any placeholder files that are not needed for the skill. Only create resource directories that are actually required.

#### Update SKILL.md

**Writing guideline:** Use imperative or infinitive form.

##### Frontmatter

Write YAML frontmatter with `name` and `description`:

- `name`: The skill name
- `description`: The primary triggering mechanism for the skill
  - Include both what the skill does and specific triggers or contexts for when to use it.
  - Include all when-to-use information here, not in the body.
  - Example: `Comprehensive document creation, editing, and analysis with support for tracked changes, comments, formatting preservation, and text extraction. Use when Pi needs to work with professional documents (.docx files) for creating new documents, modifying content, working with tracked changes, adding comments, or related document tasks.`

Keep frontmatter minimal by default. Add optional Pi fields only when they materially help.

##### Body

Write instructions for using the skill and its bundled resources.

### Step 5: Validate the Skill

Once development is complete, validate the skill folder to catch basic issues early:

```bash
scripts/quick_validate.py <path/to/skill-folder>
```

The validation script checks YAML frontmatter format, required fields, and naming rules. Pi itself is fairly lenient, but validation still catches common mistakes early.

### Step 6: Iterate

After testing the skill, users may request improvements.

1. Use the skill on real tasks
2. Notice struggles or inefficiencies
3. Identify how `SKILL.md` or bundled resources should be updated
4. Implement changes and test again
