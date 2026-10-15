#!/usr/bin/env python3
"""Usage: python3 -I tools/check-links.py [workspace_dir]
Reports relative markdown links that do not resolve, in live documents only.
Scope: records/, evidence/, scratch/ and claude-memory/ are skipped (frozen or copies); fenced and inline code are
stripped; links are keyed by path, not basename; links leaving the workspace are reported separately.
Exit code 1 if anything inside the workspace is broken."""
import os, re, sys

root = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), '..'))
FENCE = re.compile(r'^(```|~~~).*?^\1', re.S | re.M)
INLINE = re.compile(r'`[^`\n]*`')
LINK = re.compile(r'\]\(([^)\s#]+)(?:#[^)]*)?\)')
broken, outside = [], []
for dirpath, dirnames, filenames in os.walk(root):
    parts = os.path.relpath(dirpath, root).split(os.sep)
    if parts[0] in ('records', '.git', 'scratch', 'claude-memory') or 'evidence' in parts:
        dirnames[:] = []; continue
    for name in filenames:
        if not name.endswith('.md'): continue
        path = os.path.join(dirpath, name)
        text = INLINE.sub('', FENCE.sub('', open(path, encoding='utf-8').read()))
        for target in LINK.findall(text):
            if re.match(r'^[a-z]+:', target): continue
            resolved = os.path.normpath(os.path.join(dirpath, target))
            where = (os.path.relpath(path, root), target)
            if not resolved.startswith(root + os.sep) and resolved != root:
                outside.append(where + (os.path.exists(resolved),))
            elif not os.path.exists(resolved):
                broken.append(where)
for f, t in broken: print(f'BROKEN   {f} -> {t}')
for f, t, ok in outside: print(f'OUTSIDE  {f} -> {t} ({"exists" if ok else "missing"})')
print(f'broken: {len(broken)}  outside-workspace: {len(outside)}')
sys.exit(1 if broken else 0)
