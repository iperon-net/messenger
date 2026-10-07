#!/usr/bin/env python3
"""Сжатие узора обоев, экспортированного из Figma (assets/wallpapers/*.svg).

Figma выгружает сотни отдельных <path> с координатами до 4 знаков, плюс
opacity / mix-blend-mode / вложенные clip-path. Приложению нужен только чёрный
силуэт: цвет и прозрачность оно задаёт само (lib/components/chats/chat_wallpaper.dart),
поэтому скрипт:
  • склеивает все чёрные контуры в один <path> (заливка у всех одна, nonzero);
  • округляет координаты до 0.1 (на экране это < 0.3 px даже на @3x);
  • выкидывает opacity, blend-mode и группы, оставляя обрезку по холсту;
  • дожимает результат svgo (относительные команды, шорткаты, без пробелов).

Нужен Node.js (svgo берётся через npx).
Запуск: python3 tool/wallpapers/optimize.py in.svg [out.svg]  (по умолчанию — на месте)
"""
import os
import re
import subprocess
import sys
import tempfile

NUMBER = re.compile(r'-?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?')


def round_number(match):
    text = f'{round(float(match.group(0)), 1):.1f}'.rstrip('0').rstrip('.')
    return '0' if text == '-0' else text


def merge(src):
    """Один <path> из всех чёрных контуров, координаты — с шагом 0.1."""
    width = re.search(r'<svg[^>]*\bwidth="([\d.]+)"', src).group(1)
    height = re.search(r'<svg[^>]*\bheight="([\d.]+)"', src).group(1)
    paths = []
    for attrs in re.findall(r'<path\b([^>]*)/?>', src):
        fill = re.search(r'\bfill="([^"]*)"', attrs)
        if fill and fill.group(1).lower() in ('none', 'white', '#fff', '#ffffff'):
            continue
        paths.append(NUMBER.sub(round_number, re.search(r'\bd="([^"]*)"', attrs).group(1)))
    return width, height, (
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">'
        f'<clipPath id="c"><rect width="{width}" height="{height}"/></clipPath>'
        f'<path clip-path="url(#c)" d="{"".join(paths)}"/></svg>\n'
    )


def optimize(src_path, out_path):
    with open(src_path) as f:
        width, height, merged = merge(f.read())
    with tempfile.NamedTemporaryFile('w', suffix='.svg', delete=False) as tmp:
        tmp.write(merged)
    try:
        # -p 2, а не 1: на 1 svgo 3 падает в convertPathData. Координаты уже на
        # сетке 0.1, так что точность от этого не страдает.
        subprocess.run(['npx', '-y', 'svgo@3', '--multipass', '-p', '2', '-q', '-i', tmp.name, '-o', out_path], check=True)
    finally:
        os.unlink(tmp.name)
    with open(out_path) as f:
        result = f.read()
    # svgo убирает viewBox при совпадении с width/height — вернём для надёжности.
    if 'viewBox' not in result:
        result = result.replace('<svg ', f'<svg viewBox="0 0 {width} {height}" ', 1)
    with open(out_path, 'w') as f:
        f.write(result.rstrip('\n') + '\n')


if __name__ == '__main__':
    optimize(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else sys.argv[1])
