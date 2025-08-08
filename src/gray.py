import sys
from PIL import Image

def processar_imagem(input_path, output_path):
    # Abre a imagem
    imagem = Image.open(input_path)

    # Redimensiona para 640x480
    imagem = imagem.resize((640, 480))

    # Converte para escala de cinza (8 bits por pixel)
    imagem = imagem.convert('L')  # 'L' = modo 8-bit pixels, black and white

    # Obtém os dados dos pixels
    pixels = list(imagem.getdata())  # linearizado linha a linha

    # Salva os dados no formato .hex
    with open(output_path, 'w') as f:
        for pixel in pixels:
            #f.write(f"{pixel:02X}\n")  # cada valor em hexadecimal, 2 dígitos
            pixel_4bit = pixel >> 4  # Trunca para 4 bits (0–15)
            f.write(f"{pixel_4bit:X}\n")  # 1 dígito hexadecimal (0-F)
    print(f"Imagem processada e salva em: {output_path}")

# Exemplo de uso
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python script.py <arquivo_imagem>")
        sys.exit(1)

    entrada = sys.argv[1]
    saida = "saida.hex"  # nome fixo de saída, pode ser adaptado

    processar_imagem(entrada, saida)