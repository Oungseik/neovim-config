# IDE Tips and Tricks

The leader key is `<Space>`. [Back to the README](README.md).

## Search contents, then narrow by filename

Snacks supports this workflow out of the box:

1. Press `<leader>st` to open live grep.
2. Type a regex, such as `foo.*bar` or `\bfunction\b`.
3. Press `<C-g>` in the input window to switch to filtering the results.
4. Type filename filters, for example:

   ```text
   file:!effect file:!.tsx$
   ```

   This excludes paths containing `effect` and files ending in `.tsx`.
5. Press `<C-g>` again to edit the content search while keeping the filename filters.

Pause briefly after typing before pressing `<C-g>`, so Snacks saves the complete input.

### Start with a filename instead

1. Press `<leader>st`, then `<C-g>` before entering a content search.
2. Type a filename filter, such as `file:.lua$`.
3. Pause, press `<C-g>` again, and type a content search such as `Snacks`.

The filename filter stays active. No results appear until you enter a content search.

### Filename filters

| Filename filter | Meaning |
|-----------------|---------|
| `file:src/` | Fuzzy-match paths against `src/` |
| `file:'src/` | Require the literal substring `src/` in the path |
| `file:!effect` | Exclude paths containing `effect` |
| `file:.tsx$` | Keep files ending in `.tsx` |
| `file:!.tsx$` | Exclude files ending in `.tsx` |
| `file:!effect file:!.tsx$` | Apply both exclusions |

### Match either filename with OR

Use `|` with spaces on both sides to match either alternative:

```text
file:.lua$ | file:.md$
```

This keeps results from either `.lua` or `.md` files. Repeat `file:` for each
alternative. Other space-separated filters still apply to both alternatives:

```text
file:.lua$ | file:.md$ file:!test
```

This keeps `.lua` or `.md` files but excludes paths containing `test`.
To fuzzy-match either term in the result text instead, use `foo | bar`.

### Search and filter syntax

The two modes use different syntax:

- **Live grep:** ripgrep's [Rust regex syntax](https://docs.rs/regex/latest/regex/#syntax).
  For example, `foo|bar` searches for either expression. `<A-r>` toggles regex
  versus literal search. There is no `regex:` prefix.
- **Result filtering:** Snacks' fzf-style matching with field prefixes such as
  `file:`. Here, `!` means exclusion and `$` means an exact suffix; `.tsx` is
  literal, so the dot does not need escaping. A filter such as `text:'picker`
  matches the result text, including its path and matching line; it does not
  start a new content search.

Filename filters hide results after grep has searched the files. Live grep is
limited to 10,000 results by default, so filtering a broad search may miss later
matches. To prevent searching a submodule at all, add a ripgrep glob exclusion
in the live grep input:

```text
foo.*bar -- -g !path/to/submodule/**
```

Replace `path/to/submodule` with the actual submodule path.
See the [maintainer's workflow explanation](https://github.com/folke/snacks.nvim/discussions/461)
and [Snacks picker documentation](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md).
