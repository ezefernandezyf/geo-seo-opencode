# GEO-SEO for opencode

> **GEO-first, SEO-supported.** Optimize websites for AI-powered search engines — ChatGPT, Claude, Perplexity, Gemini, and Google AI Overviews.

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

This is an **opencode adaptation** of [geo-seo-claude](https://github.com/zubair-trabzada/geo-seo-claude) by Zubair Trabzada — the leading open-source GEO (Generative Engine Optimization) toolkit. It provides the same comprehensive GEO analysis capabilities, refactored to work natively inside **opencode** instead of Claude Code.

---

## Table of Contents

- [What is GEO?](#what-is-geo)
- [How is this different from the Claude Code original?](#how-is-this-different-from-the-claude-code-original)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
- [Command Reference](#command-reference)
- [Architecture](#architecture)
- [How It Works](#how-it-works)
- [Data Storage](#data-storage)
- [Uninstall](#uninstall)
- [License & Attribution](#license--attribution)
- [Contributing](#contributing)

---

## What is GEO?

**Generative Engine Optimization (GEO)** is the practice of optimizing web content so that AI systems can discover, understand, cite, and recommend it. While traditional SEO optimizes for search engine rankings, GEO optimizes for AI citation and recommendation.

| Metric | Impact |
|--------|--------|
| GEO-optimized content visibility | 30–115% higher in AI responses |
| AI-referred traffic growth | +527% year-over-year |
| AI traffic conversion vs organic | 4.4x higher |
| Brand mentions vs backlinks for AI | 3x stronger correlation |

---

## How is this different from the Claude Code original?

The original [geo-seo-claude](https://github.com/zubair-trabzada/geo-seo-claude) is designed for **Claude Code** and uses its CLI slash commands (`/geo audit`) and agent system. This adaptation:

| Feature | Claude Code Original | opencode Adaptation |
|---------|--------------------|--------------------|
| Invocation | `/geo audit <url>` slash commands | Natural language ("geo audit https://...") |
| Agent model | Claude Code agents (`agents/geo-*.md`) | opencode subagent (`agent/geo-agent.md`) |
| Skill location | `~/.claude/skills/geo-*/` | `~/.config/opencode/skills/geo-*/` |
| Auto-discovery | Claude Code scans `.claude/skills/` | opencode scans `.config/opencode/skills/` |
| Orchestration | Claude Code CLI handles routing | opencode orchestrator delegates to geo-agent |
| All GEO analysis | **Identical** — same scripts, same methodology, same scores | **Identical** — same scripts, same methodology, same scores |

Everything else — the citability scoring engine, the AI crawler analysis, the brand mention scanner, the llms.txt generator, the schema templates, the scoring methodology, the report generation — is **exactly the same**.

---

## Prerequisites

- **opencode** — installed and configured
- **Python 3.8+** — for running analysis scripts
- **Git** — for installation

Optional:
- [`uv`](https://docs.astral.sh/uv/) — faster dependency install
- **Playwright** — for screenshots during audits
- **pandoc + Chrome** — for PDF report generation (see [geo-report-pdf](skills/geo-report-pdf/SKILL.md))

---

## Installation

### One-Command Install (macOS/Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/ezefernandezyf/geo-seo-opencode/main/install.sh | bash
```

### Manual Install

```bash
git clone https://github.com/ezefernandezyf/geo-seo-opencode.git
cd geo-seo-opencode
./install.sh
```

> **Windows (Git Bash):** Requires [Git for Windows](https://git-scm.com/downloads). Open Git Bash and run the install script above.

### What the Installer Does

1. Copies skills to `~/.config/opencode/skills/geo-*/`
2. Copies the geo-agent to `~/.config/opencode/agents/geo-agent.md`
3. Creates an isolated Python virtual environment at `~/.config/opencode/skills/geo/.venv/`
4. Installs Python dependencies (requests, beautifulsoup4, lxml, etc.)
5. Patches script shebangs and path references
6. Verifies the installation

### Post-Install

1. **Configure orchestrator permissions** — Add `"geo-agent": "allow"` to the `permission.task` section of your `~/.config/opencode/opencode.json`:

   ```json
   "permission": {
     "task": {
       "*": "deny",
       "geo-agent": "allow",
       ...
     }
   }
   ```

2. **Restart opencode** for all changes to take effect. The geo skills will be auto-discovered, and the orchestrator will detect GEO-related requests and delegate them to the geo-agent.

---

## Quick Start

Open opencode and say:

```
geo audit https://example.com
```

This runs a full GEO + SEO audit of the website. The orchestrator detects your intent, loads the relevant skill, delegates the analysis to the geo-agent, and returns a comprehensive report with scores and prioritized actions.

You can also try quick commands:

```
geo quick https://example.com
geo citability https://example.com/blog/article
geo crawlers https://example.com
```

---

## Usage

### How Commands Work

Unlike Claude Code's slash commands (`/geo audit`), opencode uses **natural language triggers**. You don't need a special prefix — just say what you want to do:

```
"audit example.com"
"check the crawlers on https://test.com"
"generate an llms.txt for my site"
"run a technical seo audit on https://ejemplo.com"
```

The orchestrator matches your intent against the available skills, loads the appropriate one, and delegates the work to the **geo-agent** subagent.

### Invoking Directly (if geo-agent is set to primary mode)

If you configure `geo-agent` as a primary agent (selectable via tab), you can switch to it and speak directly:

```
# After switching to geo-agent:
audit https://example.com
citability https://example.com/page
```

See [agent/geo-agent.md](agent/geo-agent.md) for the full agent configuration.

---

## Command Reference

| What to Say | Skill Used | What It Does |
|-------------|-----------|--------------|
| "audit \<url\>" | [geo-audit](skills/geo-audit/SKILL.md) | Full GEO + SEO audit with parallel analysis |
| "citability \<url\>" | [geo-citability](skills/geo-citability/SKILL.md) | Score content for AI citation readiness |
| "crawlers \<url\>" | [geo-crawlers](skills/geo-crawlers/SKILL.md) | Check AI crawler access (robots.txt) |
| "llms.txt \<url\>" | [geo-llmstxt](skills/geo-llmstxt/SKILL.md) | Analyze or generate llms.txt |
| "brands \<url\>" | [geo-brand-mentions](skills/geo-brand-mentions/SKILL.md) | Scan brand mentions across AI-cited platforms |
| "platforms \<url\>" | [geo-platform-optimizer](skills/geo-platform-optimizer/SKILL.md) | Platform-specific AI search optimization |
| "schema \<url\>" | [geo-schema](skills/geo-schema/SKILL.md) | Structured data analysis & generation |
| "technical \<url\>" | [geo-technical](skills/geo-technical/SKILL.md) | Technical SEO audit (SSR, security, CWV) |
| "content \<url\>" | [geo-content](skills/geo-content/SKILL.md) | Content quality & E-E-A-T assessment |
| "quick \<url\>" | [geo](skills/geo/SKILL.md) | 60-second GEO visibility snapshot |
| "report \<url\>" | [geo-report](skills/geo-report/SKILL.md) | Generate client-ready GEO report |
| "report-pdf" | [geo-report-pdf](skills/geo-report-pdf/SKILL.md) | Generate PDF report from audit data |
| "prospect \<cmd\>" | [geo-prospect](skills/geo-prospect/SKILL.md) | CRM-lite prospect pipeline management |
| "proposal \<domain\>" | [geo-proposal](skills/geo-proposal/SKILL.md) | Auto-generate client proposal from audit |
| "compare \<domain\>" | [geo-compare](skills/geo-compare/SKILL.md) | Monthly delta report (baseline vs current) |

---

## Architecture

```
geo-seo-opencode/
├── skills/                           # 16 GEO skills (auto-discovered by opencode)
│   ├── geo/                          # Main skill orchestrator + scripts + schemas
│   │   ├── SKILL.md                  # Primary skill file with command reference
│   │   ├── scripts/                  # Python analysis utilities
│   │   ├── schema/                   # JSON-LD templates for structured data
│   │   └── .venv/                    # Isolated Python virtual environment
│   ├── geo-audit/                    # Full audit orchestration & scoring
│   ├── geo-citability/               # AI citation readiness scoring
│   ├── geo-crawlers/                 # AI crawler access analysis
│   ├── geo-llmstxt/                  # llms.txt standard analysis & generation
│   ├── geo-brand-mentions/           # Brand presence on AI-cited platforms
│   ├── geo-platform-optimizer/       # Platform-specific AI search optimization
│   ├── geo-schema/                   # Structured data for AI discoverability
│   ├── geo-technical/                # Technical SEO foundations
│   ├── geo-content/                  # Content quality & E-E-A-T
│   ├── geo-report/                   # Client-ready markdown report generation
│   ├── geo-report-pdf/               # Professional PDF report generation
│   ├── geo-prospect/                 # CRM-lite prospect pipeline management
│   ├── geo-proposal/                 # Auto-generate client proposals
│   ├── geo-compare/                  # Monthly delta tracking & progress reports
│   └── geo-update/                   # Pull latest updates from upstream
├── agent/
│   └── geo-agent.md                  # opencode subagent definition
├── scripts/                          # Python utilities (source)
│   ├── fetch_page.py                 # Page fetching & parsing
│   ├── citability_scorer.py          # AI citability scoring engine
│   ├── brand_scanner.py              # Brand mention detection
│   ├── llmstxt_generator.py          # llms.txt validation & generation
│   └── webapp/                       # Prospect CRM dashboard (Flask)
├── schema/                           # JSON-LD templates (source)
│   ├── organization.json
│   ├── local-business.json
│   ├── article-author.json
│   ├── software-saas.json
│   ├── product-ecommerce.json
│   └── website-searchaction.json
├── templates/                        # Report templates (PDF, HTML)
├── assets/                           # Branding assets
├── install.sh                        # Installer for opencode
├── uninstall.sh                      # Uninstaller
├── requirements.txt                  # Python dependencies
├── LICENSE                           # MIT License
└── README.md                         # This file
```

---

## How It Works

### Full Audit Flow

When you say "audit https://example.com":

1. **Discovery** — The geo-agent fetches the homepage, detects business type (SaaS, Local, E-commerce, Publisher, Agency), and crawls the sitemap for up to 50 pages.

2. **Parallel Analysis** — The geo-agent performs 5 concurrent analyses:
   - **AI Visibility** — Citability scoring, AI crawler access, llms.txt compliance, brand mentions
   - **Platform Optimization** — Readiness for ChatGPT, Perplexity, Google AI Overviews
   - **Technical SEO** — Core Web Vitals, SSR vs CSR, security headers, mobile optimization
   - **Content E-E-A-T** — Content quality, author expertise, source citations, freshness
   - **Schema Markup** — Detection, validation, and missing schema recommendations

3. **Synthesis** — Scores are aggregated into a composite GEO Score (0–100).

4. **Report** — A markdown file (`GEO-AUDIT-REPORT.md`) is generated with prioritized action items.

### Scoring Methodology

| Category | Weight | What It Measures |
|----------|--------|-----------------|
| AI Citability & Visibility | 25% | How quotable/extractable content is for AI systems |
| Brand Authority Signals | 20% | Third-party mentions, entity recognition signals |
| Content Quality & E-E-A-T | 20% | Experience, Expertise, Authoritativeness, Trustworthiness |
| Technical Foundations | 15% | AI crawler access, SSR, speed, security |
| Structured Data | 10% | Schema.org markup quality and completeness |
| Platform Optimization | 10% | Presence on platforms AI models cite |

**Formula:**
```
GEO_Score = (Citability × 0.25) + (Brand × 0.20) + (EEAT × 0.20) + (Technical × 0.15) + (Schema × 0.10) + (Platform × 0.10)
```

### Score Interpretation

| Range | Rating | Interpretation |
|-------|--------|---------------|
| 90–100 | Excellent | Top-tier GEO optimization |
| 75–89 | Good | Strong foundation with room for improvement |
| 60–74 | Fair | Moderate presence, significant opportunities |
| 40–59 | Poor | Weak signals, AI may struggle to cite |
| 0–39 | Critical | Largely invisible to AI systems |

---

## Data Storage

CRM and reporting features store data at:

```
~/.geo-prospects/
├── prospects.json              # Client/prospect pipeline data
├── proposals/                  # Generated proposal documents
│   └── <domain>-proposal-<date>.md
└── reports/                    # Monthly delta reports
    └── <domain>-monthly-<YYYY-MM>.md
```

This directory is **not removed** by the uninstaller. Delete it manually if you no longer need your data.

---

## Uninstall

```bash
./uninstall.sh
```

Or manually:

```bash
rm -rf ~/.config/opencode/skills/geo ~/.config/opencode/skills/geo-*
rm -f ~/.config/opencode/agents/geo-agent.md
```

---

## License & Attribution

This project is an adaptation of [geo-seo-claude](https://github.com/zubair-trabzada/geo-seo-claude) by **[Zubair Trabzada](https://github.com/zubair-trabzada)**.

- **Original work**: Copyright (c) 2026 Zubair Trabzada — [geo-seo-claude](https://github.com/zubair-trabzada/geo-seo-claude)
- **opencode adaptation**: Copyright (c) 2026 — this repository

Both the original and this adaptation are distributed under the **MIT License**. See [LICENSE](LICENSE) for full terms.

Want to learn how to turn GEO into a business? Join the [AI Workshop Community](https://skool.com/aiworkshop).

---

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. All contributions must maintain compatibility with both the GEO methodology and opencode's architecture.

---

Built for the AI search era. Based on [geo-seo-claude](https://github.com/zubair-trabzada/geo-seo-claude) by Zubair Trabzada.
