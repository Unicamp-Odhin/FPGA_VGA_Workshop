import sys
import numpy as np
import matplotlib.pyplot as plt

def plotar_imagem_hex(hex_file, largura=640, altura=480):
    # Lê os valores do arquivo .hex
    with open(hex_file, 'r') as f:
        valores = [int(linha.strip(), 16) for linha in f if linha.strip()]

    # Detecta tipo de imagem pelo valor máximo
    max_val = max(valores)

    if max_val <= 1:
        # Imagem binária
        matriz = np.array(valores, dtype=np.uint8).reshape((altura, largura))
        cmap = 'gray'
        vmin, vmax = 0, 1
        print("Detectado formato: BINÁRIO (0/1 por pixel)")
    elif max_val <= 15:
        # Imagem em 4 bits → escala para 0–255
        matriz = (np.array(valores, dtype=np.uint8) * 17).reshape((altura, largura))
        cmap = 'gray'
        vmin, vmax = 0, 255
        print("Detectado formato: ESCALA DE CINZA 4 BITS")
    else:
        # Imagem em 8 bits
        matriz = np.array(valores, dtype=np.uint8).reshape((altura, largura))
        cmap = 'gray'
        vmin, vmax = 0, 255
        print("Detectado formato: ESCALA DE CINZA 8 BITS")

    # Plota
    plt.imshow(matriz, cmap=cmap, vmin=vmin, vmax=vmax)
    plt.axis('off')
    plt.show()

# --- Execução via terminal ---
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python plotar_hex.py <arquivo.hex>")
        sys.exit(1)

    arquivo_hex = sys.argv[1]
    plotar_imagem_hex(arquivo_hex)
