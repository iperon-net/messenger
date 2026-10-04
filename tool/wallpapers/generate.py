#!/usr/bin/env python3
"""Генератор узоров обоев для чатов (assets/wallpapers/*.svg).

Каждый узор — бесшовная плитка 400×400 из контурных иконок (24×24), разбросанных
псевдослучайно (фиксированный seed) с поворотом и масштабом. Иконки у краёв
повторяются с другой стороны — плитка стыкуется без шва. Цвет в SVG чёрный:
приложение тонирует узор под выбранный цвет и тему (светлая / тёмная), см.
lib/components/chats/chat_wallpaper.dart.

Запуск: python3 tool/wallpapers/generate.py
"""
import math
import os
import random

TILE = 400
OUT = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'wallpapers')

ICONS = {
    'heart': 'M12 20.5s-7.5-4.6-9.3-9.2C1.4 8 3.4 4.5 6.9 4.5c2.1 0 3.6 1.1 5.1 3c1.5-1.9 3-3 5.1-3c3.5 0 5.5 3.5 4.2 6.8C19.5 15.9 12 20.5 12 20.5z',
    'star': 'M12 3l2.7 5.6 6.1.9-4.4 4.3 1 6.1L12 17l-5.4 2.9 1-6.1L3.2 9.5l6.1-.9z',
    'bubble': 'M5 5h14a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-8l-4.5 3.5V17H5a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2z',
    'plane': 'M21 3L3 10.5l7 2.5 2.5 7zM10 13l11-10',
    'phone': 'M6.5 3h3l1.5 4.5-2 1.5a11 11 0 0 0 6 6l1.5-2 4.5 1.5v3a2 2 0 0 1-2 2A17 17 0 0 1 4.5 5a2 2 0 0 1 2-2z',
    'smile': 'M12 3a9 9 0 1 0 0 18a9 9 0 1 0 0-18zM8 14c1 1.5 2.4 2.3 4 2.3s3-.8 4-2.3M9 9.5v.5M15 9.5v.5',
    'envelope': 'M3 6h18v12H3zM3 6l9 7 9-7',
    'camera': 'M4 7h3l2-2.5h6L17 7h3a1 1 0 0 1 1 1v10a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V8a1 1 0 0 1 1-1zM12 9.5a3.5 3.5 0 1 0 0 7a3.5 3.5 0 1 0 0-7z',
    'moon': 'M20 14.5A8.5 8.5 0 1 1 9.5 4a7 7 0 0 0 10.5 10.5z',
    'planet': 'M12 7a5 5 0 1 0 0 10a5 5 0 1 0 0-10zM6.2 14.8C3.6 16.9 2.6 18.6 3.4 19.4c1.4 1.4 7.2-1.6 12.9-7.3s8.7-11.5 7.3-12.9c-.8-.8-2.5.2-4.6 2.8',
    'sparkle': 'M12 3c.8 4.6 2.4 6.2 7 7-4.6.8-6.2 2.4-7 7-.8-4.6-2.4-6.2-7-7 4.6-.8 6.2-2.4 7-7z',
    'rocket': 'M12 2c3 2.5 4.5 6 4 11l-2 3h-4l-2-3c-.5-5 1-8.5 4-11zM12 8.5a1.5 1.5 0 1 0 0 3a1.5 1.5 0 1 0 0-3zM8 13l-3 3v3l3.5-2M16 13l3 3v3l-3.5-2M10.5 19l1.5 3 1.5-3',
    'dot': 'M12 9a3 3 0 1 0 0 6a3 3 0 1 0 0-6z',
    'leaf': 'M5 19C5 10 11 5 20 4c-1 9-6 15-15 15zM5 19l9-9',
    'cloud': 'M7 18h10.5a3.5 3.5 0 0 0 .3-7A6 6 0 0 0 6.2 10.2 4 4 0 0 0 7 18z',
    'sun': 'M12 8a4 4 0 1 0 0 8a4 4 0 1 0 0-8zM12 2v2.5M12 19.5V22M2 12h2.5M19.5 12H22M4.9 4.9l1.8 1.8M17.3 17.3l1.8 1.8M4.9 19.1l1.8-1.8M17.3 6.7l1.8-1.8',
    'drop': 'M12 3s6 6.5 6 11a6 6 0 0 1-12 0c0-4.5 6-11 6-11z',
    'flower': 'M12 9.5a2.5 2.5 0 1 0 0 5a2.5 2.5 0 1 0 0-5zM12 9.5C10 6 10 3.5 12 3c2 .5 2 3 0 6.5zM12 14.5c2 3.5 2 6 0 6.5-2-.5-2-3 0-6.5zM9.5 12C6 14 3.5 14 3 12c.5-2 3-2 6.5 0zM14.5 12c3.5-2 6-2 6.5 0-.5 2-3 2-6.5 0z',
    'note': 'M9 17V5l10-2v12M9 17a2.5 2.5 0 1 1-5 0a2.5 2.5 0 1 1 5 0zM19 15a2.5 2.5 0 1 1-5 0a2.5 2.5 0 1 1 5 0z',
    'note1': 'M12 17V3l5 3M12 17a3 3 0 1 1-6 0a3 3 0 1 1 6 0z',
    'headphones': 'M4 15v-3a8 8 0 0 1 16 0v3M4 15h3v5H4zM17 15h3v5h-3z',
    'triangle': 'M12 4l9 16H3z',
    'square': 'M5 5h14v14H5z',
    'plus': 'M12 4v16M4 12h16',
    'ring': 'M12 4a8 8 0 1 0 0 16a8 8 0 1 0 0-16z',
    'zigzag': 'M2 14l4-4 4 4 4-4 4 4 4-4',
    'coffee': 'M5 9h11v5a5 5 0 0 1-5 5h-1a5 5 0 0 1-5-5zM16 10h1.5a2.5 2.5 0 0 1 0 5H16M8 3c-1 1.5 1 2.5 0 4M11.5 3c-1 1.5 1 2.5 0 4',
    'pizza': 'M12 21L3 6c6-3.5 12-3.5 18 0zM4.5 8.5c5-2.7 10-2.7 15 0M10 10.5h.1M14 13h.1M12 16h.1',
    'gift': 'M4 10h16v10H4zM3 7h18v3H3zM12 7v13M12 7c-2-4-6-3-4.5-.5M12 7c2-4 6-3 4.5-.5',
}

PATTERNS = {
    'chat': ['bubble', 'heart', 'plane', 'phone', 'smile', 'envelope', 'camera', 'star'],
    'space': ['star', 'planet', 'moon', 'sparkle', 'rocket', 'dot', 'ring'],
    'nature': ['leaf', 'cloud', 'sun', 'drop', 'flower'],
    'music': ['note', 'note1', 'headphones', 'heart', 'sparkle'],
    'geometry': ['triangle', 'square', 'plus', 'ring', 'zigzag', 'dot'],
    'food': ['coffee', 'pizza', 'gift', 'heart', 'star'],
}


def place(rng, count, min_dist):
    """Точки на торе TILE×TILE не ближе min_dist друг к другу (dart throwing)."""
    points = []
    attempts = 0
    while len(points) < count and attempts < 20000:
        attempts += 1
        x, y = rng.uniform(0, TILE), rng.uniform(0, TILE)
        ok = True
        for px, py in points:
            dx = min(abs(x - px), TILE - abs(x - px))
            dy = min(abs(y - py), TILE - abs(y - py))
            if math.hypot(dx, dy) < min_dist:
                ok = False
                break
        if ok:
            points.append((x, y))
    return points


def generate(name, icons, seed):
    rng = random.Random(seed)
    parts = []
    for i, (x, y) in enumerate(place(rng, 64, 42)):
        icon = icons[i % len(icons)] if i < len(icons) else rng.choice(icons)
        scale = rng.uniform(0.95, 1.5)
        angle = rng.uniform(-30, 30)
        reach = 18 * scale
        # Копии у краёв — чтобы плитка стыковалась без шва.
        for ox in (-TILE, 0, TILE):
            for oy in (-TILE, 0, TILE):
                cx, cy = x + ox, y + oy
                if -reach <= cx <= TILE + reach and -reach <= cy <= TILE + reach:
                    parts.append(
                        f'<path transform="translate({cx:.1f} {cy:.1f}) rotate({angle:.0f}) scale({scale:.2f}) translate(-12 -12)" '
                        f'stroke-width="{1.5 / scale:.2f}" d="{ICONS[icon]}"/>'
                    )
    svg = (
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{TILE}" height="{TILE}" viewBox="0 0 {TILE} {TILE}">'
        '<g fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round">'
        + ''.join(parts)
        + '</g></svg>\n'
    )
    with open(os.path.join(OUT, f'{name}.svg'), 'w') as f:
        f.write(svg)


if __name__ == '__main__':
    os.makedirs(OUT, exist_ok=True)
    for seed, (name, icons) in enumerate(PATTERNS.items()):
        generate(name, icons, seed + 7)
