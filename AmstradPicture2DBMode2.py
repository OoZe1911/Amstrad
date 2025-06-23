from PIL import Image

# Charger l'image
img = Image.open(r"/Volumes/Gros disque/Amstrad/Terminator-Mode2.png").convert("RGB")

# Fonction pour déterminer si un pixel est "allumé"
def is_pixel_on(rgb):
    # On considère qu'un pixel clair (blanc) est allumé
    r, g, b = rgb
    return (r + g + b) > 128 * 3  # seuil ajustable

# Ligne à lire (par exemple y = 0)
y = 0

while y != 207:

    if y >= 200:
        y = y - 200 + 1
        # Rempli les 48 octets non visible
        octets = ["&00"] * 48
        print("db " + ",".join(octets))

    # Liste des octets générés
    line_bytes = []

    for group in range(80):  # 640 / 8 = 80 groupes
        byte = 0
        for bit in range(8):
            x = group * 8 + bit
            pixel = img.getpixel((x, y))
            if is_pixel_on(pixel):
                byte |= (1 << (7 - bit))
        line_bytes.append(byte)

    hex_values = [f"&{b:02X}" for b in line_bytes]
    print("db " + ",".join(hex_values))
    y = y + 8