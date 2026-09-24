"""Import removebg logo uploads into assets/team_logos, downscaled for the app.

The app draws logos at most ~96 logical px, and every stored logo is also
base64-encoded into the database, so oversized PNGs cost memory and make list
scrolling janky. 256 px is plenty of detail for every screen density we target.
"""

from __future__ import annotations

import os

from PIL import Image

SRC = r"C:\Users\sherl\.cursor\projects\c-Users-sherl-Desktop-Tourneez\assets"
DST = r"C:\Users\sherl\Desktop\Tourneez\assets\team_logos"

MAX_SIDE = 256

MAP = {
    "cairo_falcons.png": "Cairo_Falcons-removebg",
    "london_city.png": "London_City-removebg",
    "tokyo_talons.png": "Tokyo_Talons-removebg",
    "buenos_aires_tango.png": "Buenos_Aires_Tango-removebg",
    "delhi_flaming_tigers.png": "Delhi_Flaming_Tigers-removebg",
    "mexico_city_groupies.png": "Mexico_City_Groupies-removebg",
    "new_york_empire.png": "New_York_Empire-removebg",
    "lagos_lions.png": "Lagos_Lions-removebg",
    "melbourne_surf.png": "Melbourne_Surf-removebg",
    "beijing_light.png": "Beijing_Light-removebg",
    "city_of_gold.png": "City_of_Gold-removebg",
    "singapore_orchids.png": "Singapore_Orchids-removebg",
    "moscow_taiga.png": "Moscow_Taiga-removebg",
}


def find_source(key: str) -> str | None:
    if not os.path.isdir(SRC):
        return None
    for name in os.listdir(SRC):
        if key in name and name.lower().endswith(".png"):
            return os.path.join(SRC, name)
    return None


def write_shrunk(src_path: str, dest_path: str) -> None:
    with Image.open(src_path) as img:
        img = img.convert("RGBA")
        img.thumbnail((MAX_SIDE, MAX_SIDE), Image.LANCZOS)
        img.save(dest_path, format="PNG", optimize=True)


def main():
    os.makedirs(DST, exist_ok=True)
    for dest_name, key in MAP.items():
        dest = os.path.join(DST, dest_name)
        src = find_source(key) or (dest if os.path.exists(dest) else None)
        if not src:
            print(f"MISSING {dest_name} ({key})")
            continue
        write_shrunk(src, dest)
        print(f"OK {dest_name} ({os.path.getsize(dest) // 1024} KB)")
    print("done")


if __name__ == "__main__":
    main()
