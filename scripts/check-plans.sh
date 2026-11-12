#!/usr/bin/env python3
# Проверка конвенции отметок «Тестирования» в планах (docs/plans/README.md):
# [✅] (подтверждение пользователя) допустимо только вместе с датой
# подтверждения — "(подтверждено ...)". Проверяются только нумерованные
# (шаблонные) планы: старые планы с описательными именами написаны до
# конвенции и используют ✅ как декоративную пометку. README и TEMPLATE
# исключены — там сама конвенция описывается.
import pathlib
import re
import sys

fail = False

numbered = re.compile(r"^\d+-")
for path in sorted(pathlib.Path("docs/plans").glob("*.md")):
    if path.name in ("README.md", "TEMPLATE.md") or not numbered.match(path.name):
        continue

    lines = path.read_text(encoding="utf-8").splitlines()

    for i, line in enumerate(lines):
        if "✅" not in line:
            continue

        # Пункт может переноситься: собираем строку с продолжениями-отступами.
        item = line
        j = i + 1
        while j < len(lines) and lines[j].startswith(("  ", "\t")):
            item += " " + lines[j].strip()
            j += 1

        if "подтверждено" not in item.lower():
            print(f"FAIL {path}:{i + 1}: [✅] without confirmation date")
            fail = True

if not fail:
    print("plans: ok")

sys.exit(1 if fail else 0)
