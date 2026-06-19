# apps/docs — documentation site (planned)

A [Zola](https://www.getzola.org/) static site that renders the workspace
[`docs/`](../../docs/README.md) for humans to browse.

**Status: planned.** This is a placeholder; the Zola scaffold is the follow-up step.

## Plan

```txt
config.toml   site config (base_url, title, search)
content/      sourced from ../../docs/*.md (synced at build time — single source)
templates/    minimal layout + nav
static/       assets
```

```bash
zola serve    # preview at http://127.0.0.1:1111
zola build    # static output in public/
```

When scaffolded, add `zola` to [`.prototools`](../../.prototools), give this app a `moon.yml`
(`build`/`serve`), and register it in `.moon/workspace.yml`. See
[`../../docs/apps.md`](../../docs/apps.md). Agents do not run `zola serve`/`build` without
permission.
