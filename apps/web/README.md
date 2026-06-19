# apps/web — marketing site (planned)

A [Zola](https://www.getzola.org/) single-page site to promote and share WfOS: tagline, the
five products, and links to the docs and repository.

**Status: planned.** This is a placeholder; the Zola scaffold is the follow-up step.

## Plan

- Start with one page; grow only if it earns more.

```bash
zola serve    # preview at http://127.0.0.1:1111
zola build    # static output in public/
```

When scaffolded, add `zola` to [`.prototools`](../../.prototools), give this app a `moon.yml`
(`build`/`serve`), and register it in `.moon/workspace.yml`. See
[`../../docs/apps.md`](../../docs/apps.md). Agents do not run `zola serve`/`build` without
permission.
