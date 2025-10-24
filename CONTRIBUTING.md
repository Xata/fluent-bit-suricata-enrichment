# Contributing to Fluent Bit Suricata Enrichment

Thank you for your interest in contributing! This project welcomes contributions from the community. The more people using open source alternatives the better! 

## How Can I Contribute?

### Adding Category Mappings

One of the most valuable contributions is expanding the category mappings! Here are the steps below:

### 1. Identify the Category

Find the verbose Suricata category name from your logs:

```json
{
  "alert": {
    "category": "Potentially Bad Traffic"
  }
}
```

### 2. Add to the Lua Filter

Edit `filters/suricata-enrich.lua` and add your mapping to the `category_map` table:
```lua
local category_map = {
    -- Existing mappings...
    ["Potentially Bad Traffic"] = "suspicious",  -- Your new mapping
}
```

**Choose appropriate normalized names:**

- Use lowercase with underscores
- Keep it concise (1-3 words)
- Use existing categories when possible:
  - `malware`, `web_attack`, `privilege_escalation`
  - `dos`, `reconnaissance`, `command_and_control`
  - `exploitation`, `credential_attack`, `information_disclosure`
  - `protocol_anomaly`, `suspicious`, `network`, `other`

### 3. Add Test Data

Add a test event to `test-data/eve.json`:

```json
{"timestamp":"2025-10-23T14:40:00.000000+0000","event_type":"alert","alert":{"category":"Potentially Bad Traffic","severity":3}}
```

### Prerequisites

- Git
- Docker and Docker Compose
- Text editor of your choice

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork:

    ```zsh
    git clone https://github.com/Xata/fluent-bit-suricata-enrichment.git
    cd fluent-bit-suricata-enrichment
    ```
3. Fire up the test environment:

    ```zsh
    docker compose up -d
    ```

## Development Workflow

1. **Create a branch** for your changes:
```bash
   git checkout -b feature/add-new-categories
```

2. **Make your changes**

3. **Test your changes**

4. **Commit your changes**:
```zsh
   git add .
   git commit -m "add: mappings for network policy violations"
```

5. **Push to your fork**:
```zsh
   git push origin feature/add-new-categories
```

6. **Open a Pull Request** on GitHub

## Submitting Changes

### Pull Request Guidelines

**PR Title Examples:**
- `Add category mappings for policy violations` (✿◠‿◠)
- `Fix nil reference when alert.category is missing` (✿◠‿◠)
- `Update README with OpenSearch integration example` (✿◠‿◠)
- `Update` (✖╭╮✖)
- `Fixed stuff` (✖╭╮✖)

**PR Description Should Include:**
- **What** changed and **why**
- **How to test** the changes
- **Related issues** (if any): `Fixes #123`
- **Breaking changes** (if any)

**Example PR Description:**
```markdown
## Summary
Adds category mappings for new Suricata policy violation categories.

## Changes
- Added mappings for network policy violations to `filters/suricata-enrich.lua`
- Added test cases to `test-data/eve.json`
- Updated README.md category table

## Testing
Tested with Docker Compose against sample Suricata logs containing these categories.

```

## AI Tools

Contributions created with AI assistance (ChatGPT, Claude, Copilot, etc.) are totally fine.

**If you use AI tools, please:**

1. **Mention it in your PR**: "Created with assistance from [tool name]"
2. **Review and test** all AI-generated code before submitting
3. **Take responsibility**: you're accountable for your contribution
