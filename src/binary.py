import sys
from PIL import Image

def processar_imagem_binaria(input_path, output_path, threshold=128):
    # Abre a imagem
    imagem = Image.open(input_path)

    # Redimensiona para 640x480
    imagem = imagem.resize((640, 480))

    # Converte para escala de cinza primeiro para pegar intensidade
    imagem = imagem.convert('L')

    # Obtém os dados dos pixels
    pixels = list(imagem.getdata())  # linearizado linha a linha

    # Aplica binarização e salva no formato .hex
    with open(output_path, 'w') as f:
        for pixel in pixels:
            bin_pixel = 1 if pixel >= threshold else 0
            f.write(f"{bin_pixel:X}\n")  # escreve 0 ou 1

    print(f"Imagem binarizada e salva em: {output_path}")

# --- Execução via linha de comando ---
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python script.py <arquivo_imagem>")
        sys.exit(1)

    entrada = sys.argv[1]
    saida = "saida_binaria.hex"  # nome fixo de saída

    processar_imagem_binaria(entrada, saida)
