from PIL import Image

# Ouvre l'image en RGB
img = Image.open(r"/Volumes/Gros disque/Amstrad/Terminator-Mode1.png").convert("RGB")
print(len(img.getcolors()))
# Vérifie les couleurs utilisées
colors = img.getcolors(maxcolors=4)
#if not colors or len(colors) > 4:
#    raise ValueError("L'image doit contenir exactement 4 couleurs ou moins.")

# Trie les couleurs par fréquence (optionnel)
colors.sort(reverse=True)

# Crée le mapping RGB → valeur 2 bits (0 à 3)
color_map = {rgb: index for index, (count, rgb) in enumerate(colors)}

print("Palette détectée :")
for rgb, val in color_map.items():
    print(f"Couleur {rgb} → valeur {val}")

# Traitement de la première ligne
y = 0

width = img.width
print("Image size : " + str(img.width) + " x " + str(img.height))
if width != 320:
    raise ValueError("L'image doit faire 320 pixels de large en mode 1.")

while y != 207:

    if y >= 200:
        y = y - 200 + 1
        # Rempli les 48 octets non visible
        octets = ["&00"] * 48
        print("db " + ",".join(octets))


    line_bytes = []

    for group in range(0, 320, 4):  # 4 pixels par octet → 160 octets
        pixels = [img.getpixel((group + i, y)) for i in range(4)]
        vals = [color_map[p] for p in pixels]

        # Extraire les b0 et b1 pour chaque pixel
        b0 = [(v >> 0) & 1 for v in vals]
        b1 = [(v >> 1) & 1 for v in vals]

        # Construire l’octet : P3b0 P2b0 P1b0 P0b0 P3b1 P2b1 P1b1 P0b1
        byte = (b0[0] << 7) | (b0[1] << 6) | (b0[2] << 5) | (b0[3] << 4) | \
               (b1[0] << 3) | (b1[1] << 2) | (b1[2] << 1) | (b1[3] << 0)

        line_bytes.append(byte)

    # Affiche tout sur une seule ligne en assembleur CPC
    hex_values = [f"&{b:02X}" for b in line_bytes]
    print("db " + ",".join(hex_values))
    y = y + 8