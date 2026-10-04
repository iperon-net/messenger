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
    # Общение
    'at': 'M16 12a4 4 0 1 1-8 0a4 4 0 1 1 8 0zM16 12v1.5a2.5 2.5 0 0 0 5 0V12a9 9 0 1 0-3.5 7.1',
    'hash': 'M10 4L8 20M16 4l-2 16M4.5 9h15M4 15h15',
    'bell': 'M6 16v-5a6 6 0 0 1 12 0v5l1.5 2h-15zM10 20.5a2 2 0 0 0 4 0',
    'link': 'M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1M14 10a4 4 0 0 0-5.7 0l-3 3a4 4 0 0 0 5.7 5.7l1-1',
    'lock': 'M6 11h12v9H6zM8.5 11V8a3.5 3.5 0 0 1 7 0v3M12 14.5v2',
    'pin': 'M12 21s-6.5-6-6.5-11a6.5 6.5 0 0 1 13 0c0 5-6.5 11-6.5 11zM12 7.5a2.5 2.5 0 1 0 0 5a2.5 2.5 0 1 0 0-5z',
    'mic': 'M9.5 5a2.5 2.5 0 0 1 5 0v6a2.5 2.5 0 0 1-5 0zM6 11a6 6 0 0 0 12 0M12 17v3.5M9 20.5h6',
    'like': 'M7 11v9H4v-9zM7 11l4-7c1.5 0 2.5 1 2 3l-.8 3H19a1.5 1.5 0 0 1 1.5 1.8l-1.4 6.5A2 2 0 0 1 17.2 20H7',
    'clip': 'M16.5 7.5l-7 7a1.8 1.8 0 0 0 2.5 2.5l7.5-7.5a3.5 3.5 0 0 0-5-5l-7.5 7.5a5.2 5.2 0 0 0 7.4 7.4L19 14',
    'checks': 'M2 12.5l4 4 8-9M11 16l.5.5 8-9',
    'wink': 'M12 3a9 9 0 1 0 0 18a9 9 0 1 0 0-18zM8 14c1 1.5 2.4 2.3 4 2.3s3-.8 4-2.3M8 9.8h2.5M15 9.5v.5',
    # Космос
    'comet': 'M16 5a3 3 0 1 0 0 6a3 3 0 1 0 0-6zM13.8 10.2L4 20M13 7.5L5 12.5M16.5 11L12 19',
    'ufo': 'M8 10a4 4 0 0 1 8 0M3 13c0-1.7 4-3 9-3s9 1.3 9 3-4 3-9 3-9-1.3-9-3zM7 16l-1.5 3M17 16l1.5 3M12 16.5v3',
    'satellite': 'M8.5 11.5l3-3 4 4-3 3zM9 9L5 5l-2.5 2.5 4 4M15 15l4 4 2.5-2.5-4-4M15.5 6a2.5 2.5 0 0 1 2.5 2.5M15.5 3a5.5 5.5 0 0 1 5.5 5.5',
    'telescope': 'M4 13l11-5.5 2 4-11 5.5zM15 7.5l3-1.5 2 4-3 1.5M10 15l-3 6M11.5 14.5l3 6.5',
    'star4': 'M12 2l1.8 8.2L22 12l-8.2 1.8L12 22l-1.8-8.2L2 12l8.2-1.8z',
    'alien': 'M12 3c-4.5 0-7.5 3-7.5 7 0 5 4.5 11 7.5 11s7.5-6 7.5-11c0-4-3-7-7.5-7zM7.5 11c1.5 0 3 1 3.5 3-2 .3-3.5-1-3.5-3zM16.5 11c-1.5 0-3 1-3.5 3 2 .3 3.5-1 3.5-3z',
    # Природа
    'tree': 'M12 3l6 8h-3l4 6H5l4-6H6zM12 17v4',
    'mushroom': 'M3 12a9 7 0 0 1 18 0zM9.5 12v6a2.5 2.5 0 0 0 5 0v-6M8 8.5h.1M14 7h.1',
    'snowflake': 'M12 2v20M3.3 7l17.4 10M3.3 17l17.4-10M9.5 3.5L12 6l2.5-2.5M9.5 20.5L12 18l2.5 2.5',
    'bird': 'M3 10c3-2 6-1.5 9 2 3-3.5 6-4 9-2',
    'mountain': 'M2 20l7-12 4 6 3-4 6 10zM7.5 10.5l1.5 1 1.5-1',
    'wave': 'M2 10c2.5-3 5-3 7.5 0s5 3 7.5 0 3.5-2 5-1M2 15.5c2.5-3 5-3 7.5 0s5 3 7.5 0 3.5-2 5-1',
    'cactus': 'M10 21V5a2 2 0 0 1 4 0v16M10 13H7.5A2.5 2.5 0 0 1 5 10.5V8M14 11h2.5A2.5 2.5 0 0 0 19 8.5V6M7 21h10',
    'tulip': 'M12 13c-3.5 0-5-2.5-5-7l2.5 2L12 4l2.5 4L17 6c0 4.5-1.5 7-5 7zM12 13v8M12 18c-2-2.5-4-3-6-2.5M12 18c2-2.5 4-3 6-2.5',
    'umbrella': 'M3 12a9 9 0 0 1 18 0zM12 12v6.5a2 2 0 0 1-4 0M12 3v-1',
    'rainbow': 'M3 18a9 9 0 0 1 18 0M6.5 18a5.5 5.5 0 0 1 11 0M10 18a2 2 0 0 1 4 0',
    # Музыка
    'guitar': 'M20 4l-8 8M18.5 2.5l3 3M12.5 9.5a3 3 0 0 0-4.3.3c-1 1-.7 2.2-1.8 3-.9.6-2.4.4-3.2 1.7-1.3 2 .7 5.2 3.2 5.7 2 .4 3-1 3.6-2.2.6-1.2.6-2.4 1.8-3 .8-.4 1.8-.8 2.2-1.8a3 3 0 0 0-1.5-3.7zM6.5 15.5l2 2',
    'drum': 'M4 9c0-1.7 3.6-3 8-3s8 1.3 8 3-3.6 3-8 3-8-1.3-8-3zM4 9v7c0 1.7 3.6 3 8 3s8-1.3 8-3V9M14.5 7.5L20 2.5M9.5 7.5L4 2.5M8 12v7M16 12v7',
    'speaker': 'M6 3h12v18H6zM12 12.5a3 3 0 1 0 0 6a3 3 0 1 0 0-6zM12 6a1.5 1.5 0 1 0 0 3a1.5 1.5 0 1 0 0-3z',
    'vinyl': 'M12 3a9 9 0 1 0 0 18a9 9 0 1 0 0-18zM12 9.5a2.5 2.5 0 1 0 0 5a2.5 2.5 0 1 0 0-5zM6.5 10a6 6 0 0 1 3.5-3.5',
    'piano': 'M3 6h18v12H3zM8 12v6M13 12v6M18 12v6M6.5 6v6h3V6M14.5 6v6h3V6',
    'soundwave': 'M3 11v2M6.5 8.5v7M10 5v14M13.5 8v8M17 10v4M20.5 11.5v1',
    'cassette': 'M3 6h18v12H3zM8 9.5a1.5 1.5 0 1 0 0 3a1.5 1.5 0 1 0 0-3zM16 9.5a1.5 1.5 0 1 0 0 3a1.5 1.5 0 1 0 0-3zM9.5 11h5M7 18l1.5-3h7l1.5 3',
    # Геометрия
    'hexagon': 'M12 3l8 4.5v9L12 21l-8-4.5v-9z',
    'diamond': 'M12 3l8 9-8 9-8-9z',
    'cross': 'M6 6l12 12M18 6L6 18',
    'semicircle': 'M4 15a8 8 0 0 1 16 0z',
    'spiral': 'M12 12a1.5 1.5 0 0 1 3 0 3 3 0 0 1-3 3 4.5 4.5 0 0 1-4.5-4.5 6 6 0 0 1 6-6 7.5 7.5 0 0 1 7.5 7.5',
    'pentagon': 'M12 3l8.5 6.2-3.2 10H6.7l-3.2-10z',
    'circles': 'M12 4a8 8 0 1 0 0 16a8 8 0 1 0 0-16zM12 8a4 4 0 1 0 0 8a4 4 0 1 0 0-8z',
    'squiggle': 'M3 8c3 0 3 8 6 8s3-8 6-8 3 8 6 8',
    # Еда
    'apple': 'M12 7.5c-2-1.5-7-1.5-7 4.5 0 4.5 3 9 5 8.5.8-.2 1.2-.5 2-.5s1.2.3 2 .5c2 .5 5-4 5-8.5 0-6-5-6-7-4.5zM12 7.5c0-2 1-3.5 2.5-4.5',
    'cherry': 'M7 15a3 3 0 1 0 0 6a3 3 0 1 0 0-6zM17 13a3 3 0 1 0 0 6a3 3 0 1 0 0-6zM7 15c1-5 3.5-9 7-12M17 13c-1-4-2-7-3-10M14 3c2 0 4 .5 5 2',
    'icecream': 'M7.5 11l4.5 10 4.5-10M7 11a5 5 0 0 1 10 0zM9.5 14.5l4.5-2M10.5 17l3.5-1.5',
    'donut': 'M12 3a9 9 0 1 0 0 18a9 9 0 1 0 0-18zM12 9.5a2.5 2.5 0 1 0 0 5a2.5 2.5 0 1 0 0-5zM7 8l1 1M16 7.5l-.8 1.2M16.5 15l1 .8M8 16l.8-1',
    'cupcake': 'M5 12h14l-2 9H7zM5 12a3 3 0 0 1 2-4.5 5 5 0 0 1 10 0A3 3 0 0 1 19 12M10 12l.5 9M14 12l-.5 9',
    'burger': 'M4 10a8 6 0 0 1 16 0zM3.5 13c1.5 1 3 1 4.3 0s3 1 4.2 0 3 1 4.2 0 3 1 4.3 0M4 16h16v1a3 3 0 0 1-3 3H7a3 3 0 0 1-3-3z',
    'cookie': 'M12 3a9 9 0 1 0 9 9 3 3 0 0 1-3.5-3.5A3 3 0 0 1 14 5a3 3 0 0 1-2-2zM8.5 10h.1M10 15.5h.1M15 14.5h.1',
    'lemon': 'M12 3a9 9 0 1 0 0 18a9 9 0 1 0 0-18zM12 3v18M4.2 7.5l15.6 9M4.2 16.5l15.6-9',
    'carrot': 'M14.5 9.5c-2-2-4-1-5.5.5L3 20l1 1 10-6c1.5-1.5 2.5-3.5.5-5.5zM14.5 9.5c1-2.5 1-4.5 0-6.5M14.5 9.5c2.5-1 4.5-1 6.5 0M14.5 9.5l4-4M7 15.5l1.5 1.5M10 12.5l1.5 1.5',
    'bottle': 'M10 3h4M10.5 3v4L8 10v10a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V10l-2.5-3V3M8 14h8',
    'cake': 'M4 13h16v8H4zM4 16c2 1.5 4 1.5 5.3 0s4 1.5 5.4 0 4 1.5 5.3 0M8 13V9.5M12 13V9.5M16 13V9.5M8 6.5v.1M12 6.5v.1M16 6.5v.1',
}

PATTERNS = {
    'chat': ['bubble', 'heart', 'plane', 'phone', 'smile', 'envelope', 'camera', 'star', 'at', 'hash', 'bell', 'link', 'lock', 'pin', 'mic', 'like', 'clip', 'checks', 'wink', 'gift'],
    'space': ['star', 'planet', 'moon', 'sparkle', 'rocket', 'dot', 'ring', 'comet', 'ufo', 'satellite', 'telescope', 'star4', 'alien'],
    'nature': ['leaf', 'cloud', 'sun', 'drop', 'flower', 'tree', 'mushroom', 'snowflake', 'bird', 'mountain', 'wave', 'cactus', 'tulip', 'umbrella', 'rainbow'],
    'music': ['note', 'note1', 'headphones', 'heart', 'sparkle', 'guitar', 'drum', 'mic', 'speaker', 'vinyl', 'piano', 'soundwave', 'cassette'],
    'geometry': ['triangle', 'square', 'plus', 'ring', 'zigzag', 'dot', 'hexagon', 'diamond', 'cross', 'semicircle', 'spiral', 'pentagon', 'circles', 'squiggle'],
    'food': ['coffee', 'pizza', 'gift', 'heart', 'star', 'apple', 'cherry', 'icecream', 'donut', 'cupcake', 'burger', 'cookie', 'lemon', 'carrot', 'bottle', 'cake'],
}


def place(rng, count, min_dist):
    """Точки на торе TILE×TILE не ближе min_dist друг к другу (dart throwing)."""
    points = []
    attempts = 0
    while len(points) < count and attempts < 50000:
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
    for i, (x, y) in enumerate(place(rng, 200, 30)):
        icon = icons[i % len(icons)] if i < len(icons) else rng.choice(icons)
        scale = rng.uniform(0.8, 1.2)
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
