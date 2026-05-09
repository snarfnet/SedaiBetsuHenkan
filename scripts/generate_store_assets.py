from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageOps

ROOT = Path(__file__).resolve().parents[1]
ASSET_DIR = ROOT / "SedaiBetsuHenkan" / "Assets.xcassets"
SCREENSHOT_DIR = ROOT / "screenshots"

BG = (9, 11, 23)
PANEL = (25, 27, 43, 232)
CARD = (31, 34, 52, 238)
TEXT = (248, 244, 232)
SUB = (184, 183, 198)
CYAN = (48, 224, 240)
YELLOW = (255, 210, 46)
PINK = (255, 88, 135)
INK = (14, 12, 15)
LINE = (255, 255, 255, 42)


def font(size, bold=False):
    names = ["YuGothB.ttc" if bold else "YuGothM.ttc", "meiryob.ttc" if bold else "meiryo.ttc", "NotoSansJP-VF.ttf"]
    for name in names:
        path = Path("C:/Windows/Fonts") / name
        if path.exists():
            return ImageFont.truetype(str(path), size=size)
    return ImageFont.load_default()


def draw_text(draw, xy, label, size, fill=TEXT, bold=False, anchor=None, spacing=6):
    draw.multiline_text(xy, label, font=font(size, bold), fill=fill, anchor=anchor, spacing=spacing)


def rounded(draw, box, radius, fill, outline=None, width=1):
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)


def base(size):
    bg_path = ASSET_DIR / "GeneratedTimelineBackground.imageset" / "generated-timeline-background.png"
    if bg_path.exists():
        src = Image.open(bg_path).convert("RGB")
        img = ImageOps.fit(src, size, method=Image.Resampling.LANCZOS, centering=(0.5, 0.5)).convert("RGBA")
    else:
        img = Image.new("RGBA", size, BG)
    shade = Image.new("RGBA", size, (0, 0, 0, 100))
    lower = Image.new("RGBA", size, (0, 0, 0, 0))
    ld = ImageDraw.Draw(lower, "RGBA")
    ld.rectangle((0, int(size[1] * 0.40), size[0], size[1]), fill=(0, 0, 0, 92))
    return Image.alpha_composite(Image.alpha_composite(img, shade), lower)


def app_chrome(draw, w, h):
    y = int(h * 0.075)
    draw_text(draw, (w // 2, y), "世代別変換", int(w * 0.036), TEXT, True, "mm")
    draw_text(draw, (int(w * 0.34), y), "●", int(w * 0.026), YELLOW, True, "mm")


def tab_ad(draw, w, h):
    ad_h = int(h * 0.045)
    draw.rectangle((0, h - ad_h, w, h), fill=(0, 0, 0, 255))
    draw_text(draw, (w // 2, h - ad_h // 2), "広告", int(w * 0.026), (150, 150, 150), True, "mm")


def hero(draw, w, y, title, eyebrow="GENERATION TRANSLATOR"):
    mx = int(w * 0.06)
    draw_text(draw, (mx, y), eyebrow, int(w * 0.027), CYAN, True)
    draw_text(draw, (mx, y + int(w * 0.055)), title, int(w * 0.070), TEXT, True, spacing=4)


def mode_chip(draw, x, y, label, active=False, width=None):
    width = width or 210
    h = 90
    fill = YELLOW if active else (255, 255, 255, 28)
    fg = INK if active else TEXT
    rounded(draw, (x, y, x + width, y + h), 34, fill, LINE if not active else None, 2)
    draw_text(draw, (x + width // 2, y + h // 2), label, 30, fg, True, "mm")


def panel(draw, box, radius=34):
    rounded(draw, box, radius, PANEL, LINE, 2)


def input_box(draw, x, y, w, text_body="明日の集合時間、少し早めでも大丈夫？"):
    panel(draw, (x, y, x + w, y + 360))
    draw_text(draw, (x + 34, y + 36), "変換したい文章", 30, SUB, True)
    rounded(draw, (x + 28, y + 88, x + w - 28, y + 282), 28, (18, 21, 34, 248), LINE, 2)
    draw_text(draw, (x + 52, y + 120), text_body, 42, TEXT, True, spacing=8)
    draw_text(draw, (x + 34, y + 316), f"{len(text_body)}文字", 24, SUB, True)


def style_grid(draw, x, y, w, active="ギャル語"):
    panel(draw, (x, y, x + w, y + 560))
    draw_text(draw, (x + 34, y + 36), "変換モード", 30, SUB, True)
    labels = [("おじさん構文", "元気かな？"), ("ギャル語", "それよすぎじゃん"), ("Z世代", "ガチで助かる"), ("昭和レトロ", "結構でございます"), ("ごちゃ混ぜ", "時代をMIX")]
    cell_w = (w - 78) // 2
    cell_h = 150
    for i, (label, sample) in enumerate(labels):
        cx = x + 28 + (i % 2) * (cell_w + 22)
        cy = y + 92 + (i // 2) * (cell_h + 18)
        selected = label == active
        fill = (61, 48, 25, 238) if selected else CARD
        outline = (*YELLOW, 230) if selected else LINE
        rounded(draw, (cx, cy, cx + cell_w, cy + cell_h), 28, fill, outline, 3 if selected else 2)
        draw.ellipse((cx + 24, cy + 24, cx + 78, cy + 78), fill=YELLOW if selected else (48, 224, 240, 40))
        draw_text(draw, (cx + 51, cy + 51), label[:1], 26, INK if selected else CYAN, True, "mm")
        draw_text(draw, (cx + 94, cy + 26), label, 30, TEXT, True)
        draw_text(draw, (cx + 94, cy + 76), sample, 21, SUB, True)


def convert_button(draw, x, y, w):
    rounded(draw, (x, y, x + w, y + 96), 32, YELLOW)
    draw_text(draw, (x + w // 2, y + 49), "この世代に変換", 34, INK, True, "mm")


def result_box(draw, x, y, w, mode="ギャル語", body="まって 明日の集合時間、少し早めでもだいじょぶ じゃん"):
    panel(draw, (x, y, x + w, y + 430))
    draw_text(draw, (x + 34, y + 36), "変換結果", 30, SUB, True)
    rounded(draw, (x + w - 250, y + 24, x + w - 34, y + 72), 22, (255, 255, 255, 28), LINE, 2)
    draw_text(draw, (x + w - 142, y + 49), "コピー", 24, CYAN, True, "mm")
    rounded(draw, (x + 28, y + 92, x + w - 28, y + 300), 28, (12, 42, 44, 245), (*YELLOW, 118), 2)
    draw_text(draw, (x + 52, y + 122), body, 42, TEXT, True, spacing=8)
    rounded(draw, (x + 28, y + 326, x + w - 28, y + 392), 24, (31, 34, 52, 238), LINE, 2)
    draw_text(draw, (x + w // 2, y + 360), f"{mode}でもう一回", 26, TEXT, True, "mm")


def speech_pair(draw, x, y, w):
    panel(draw, (x, y, x + w, y + 340))
    draw_text(draw, (x + 34, y + 34), "変換サンプル", 30, SUB, True)
    bw = (w - 92) // 2
    rounded(draw, (x + 28, y + 92, x + 28 + bw, y + 278), 28, CARD, LINE, 2)
    draw_text(draw, (x + 52, y + 122), "元の文", 22, CYAN, True)
    draw_text(draw, (x + 52, y + 168), "明日ちょっと\n遅れます", 31, TEXT, True)
    draw_text(draw, (x + w // 2, y + 186), "→", 34, YELLOW, True, "mm")
    rx = x + 64 + bw
    rounded(draw, (rx, y + 92, rx + bw, y + 278), 28, (12, 42, 44, 245), (*YELLOW, 105), 2)
    draw_text(draw, (rx + 24, y + 122), "ギャル語", 22, CYAN, True)
    draw_text(draw, (rx + 24, y + 168), "まって 明日\n遅れるかもw", 31, TEXT, True)


def screenshot(size, filename, scene):
    w, h = size
    img = base(size)
    draw = ImageDraw.Draw(img, "RGBA")
    app_chrome(draw, w, h)
    mx = int(w * 0.06)
    y = int(h * 0.13)

    if scene == 1:
        hero(draw, w, y, "言葉の時代を\nスイッチ")
        input_box(draw, mx, int(h * 0.36), w - mx * 2)
        style_grid(draw, mx, int(h * 0.53), w - mx * 2, "ギャル語")
    elif scene == 2:
        hero(draw, w, y, "変換モードを\n選ぶだけ", "STYLE SELECT")
        style_grid(draw, mx, int(h * 0.32), w - mx * 2, "Z世代")
        convert_button(draw, mx, int(h * 0.72), w - mx * 2)
    elif scene == 3:
        hero(draw, w, y, "ギャル語へ\n一発変換", "RESULT")
        input_box(draw, mx, int(h * 0.31), w - mx * 2, "今日の予定、あとで送ってください。")
        convert_button(draw, mx, int(h * 0.50), w - mx * 2)
        result_box(draw, mx, int(h * 0.57), w - mx * 2, "ギャル語", "てか 今日の予定、あとで送って じゃん")
    elif scene == 4:
        hero(draw, w, y, "コピーも共有も\nすぐできる", "SHARE")
        result_box(draw, mx, int(h * 0.34), w - mx * 2, "おじさん構文", "やっほー😊 今日も頑張ってネ‼️ ところでご飯ちゃんと食べたカナ？")
        rounded(draw, (mx, int(h * 0.58), w - mx, int(h * 0.64)), 32, YELLOW)
        draw_text(draw, (w // 2, int(h * 0.61)), "コピー済み", 32, INK, True, "mm")
    else:
        hero(draw, w, y, "世代のノリを\n見比べる", "PREVIEW")
        speech_pair(draw, mx, int(h * 0.34), w - mx * 2)
        style_grid(draw, mx, int(h * 0.53), w - mx * 2, "昭和レトロ")

    tab_ad(draw, w, h)
    img.convert("RGB").save(SCREENSHOT_DIR / filename, quality=95)


def main():
    SCREENSHOT_DIR.mkdir(parents=True, exist_ok=True)
    sizes = {
        "iphone-6.9": (1290, 2796),
        "iphone-6.5": (1284, 2778),
        "iphone-5.5": (1242, 2208),
    }
    for prefix, size in sizes.items():
        for scene in range(1, 6):
            screenshot(size, f"{prefix}-{scene:02d}.jpg", scene)


if __name__ == "__main__":
    main()
