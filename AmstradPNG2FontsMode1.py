from PIL import Image
import matplotlib.pyplot as plt
import numpy as np


def generate_font_data(image_path):
    # Charger l'image
    img = Image.open(image_path).convert("RGB")
    print(f"Image size: {img.width} x {img.height}")

    # Calculer le nombre de caractères
    chars_x = img.width // 8
    chars_y = img.height // 8
    total_chars = chars_x * chars_y

    print(f"Nombre de caractères détectés: {chars_x} x {chars_y} = {total_chars}")

    # Détecter les couleurs utilisées
    colors = img.getcolors(maxcolors=16)
    if not colors or len(colors) > 4:
        print(f"Attention: {len(colors) if colors else 'plus de 16'} couleurs détectées")

    # Créer le mapping des couleurs (tri par fréquence)
    colors.sort(reverse=True)
    color_map = {rgb: index for index, (count, rgb) in enumerate(colors[:4])}

    print("Palette détectée:")
    for rgb, val in color_map.items():
        print(f"  Couleur {rgb} → valeur {val}")

    # Préparer l'affichage des caractères
    fig, axes = plt.subplots(chars_y, chars_x, figsize=(chars_x * 2, chars_y * 2))
    if chars_y == 1:
        axes = [axes]
    if chars_x == 1:
        axes = [[ax] for ax in axes]

    char_index = 0

    # Parcourir chaque caractère
    for row in range(chars_y):
        for col in range(chars_x):
            print(f"\n; === Caractère {char_index} (ligne {row}, colonne {col}) ===")

            # Extraire la zone 8x8
            start_x = col * 8
            start_y = row * 8

            # Générer les données pour ce caractère
            char_data = []
            char_pixels = []  # Pour l'affichage

            for y in range(8):  # 8 lignes de pixels
                line_bytes = []
                pixel_line = []

                # Traiter 8 pixels par groupes de 4 (2 octets par ligne)
                for group in range(0, 8, 4):  # 2 groupes de 4 pixels
                    pixels = []
                    for i in range(4):
                        pixel_x = start_x + group + i
                        pixel_y = start_y + y
                        pixel_rgb = img.getpixel((pixel_x, pixel_y))
                        pixels.append(pixel_rgb)
                        pixel_line.append(color_map.get(pixel_rgb, 0))

                    # Convertir en valeurs 0-3
                    vals = [color_map.get(p, 0) for p in pixels]

                    # Encoder selon le format CPC mode 1
                    b0 = [(v >> 0) & 1 for v in vals]  # bits de poids faible
                    b1 = [(v >> 1) & 1 for v in vals]  # bits de poids fort

                    # Construire l'octet
                    byte = (b0[0] << 7) | (b0[1] << 6) | (b0[2] << 5) | (b0[3] << 4) | \
                           (b1[0] << 3) | (b1[1] << 2) | (b1[2] << 1) | (b1[3] << 0)

                    line_bytes.append(byte)

                char_data.extend(line_bytes)
                char_pixels.append(pixel_line)

            # Afficher les données en assembleur
            hex_values = [f"&{b:02X}" for b in char_data]
            print(f"char_{char_index:02d}")

            # Afficher par lignes de 2 octets (plus lisible)
            for i in range(0, len(hex_values), 2):
                line_data = hex_values[i:i + 2]
                print(f"    db {','.join(line_data)}")

            # Afficher le caractère dans matplotlib
            char_array = np.array(char_pixels)
            ax = axes[row][col] if chars_y > 1 else axes[col]
            im = ax.imshow(char_array, cmap='viridis', vmin=0, vmax=3)
            ax.set_title(f'Char {char_index}', fontsize=8)
            ax.set_xticks([])
            ax.set_yticks([])

            char_index += 1

    # Afficher toutes les polices
    plt.tight_layout()
    plt.suptitle('Police de caractères extraite', fontsize=14)
    plt.show()

    print(f"\n; === Résumé ===")
    print(f"; {total_chars} caractères générés")
    print(f"; {len(char_data)} octets par caractère (16 octets = 2 octets × 8 lignes)")


# Utilisation
if __name__ == "__main__":
    # Remplacez par le chemin de votre image de police
    image_path = "/Volumes/Gros disque/Amstrad/fonts.png"  # Adaptez le chemin

    try:
        generate_font_data(image_path)
    except FileNotFoundError:
        print("Fichier image non trouvé. Veuillez vérifier le chemin.")
    except Exception as e:
        print(f"Erreur: {e}")