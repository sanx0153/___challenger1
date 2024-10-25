#Requires AutoHotkey v2.0

static checkWinnerByState() {
    ; Máscaras binárias para padrões de vitória
    patterns := [
        0x07, ; Linha 1        - 0b000000111
        0x38, ; Linha 2        - 0b000111000
        0x1C0, ; Linha 3       - 0b111000000
        0x49, ; Coluna 1       - 0b001001001
        0x92, ; Coluna 2       - 0b010010010
        0x124, ; Coluna 3      - 0b100100100
        0x111, ; Diagonal principal - 0b100010001
        0x54  ; Diagonal secundária - 0b001010100
    ]
    stateO := logic.stateO
    stateX := logic.stateX
    for , pattern in patterns {
        ; Verifica se jogador X venceu (bits 0 a 8)
        if ((stateX & pattern) == pattern) {
            return "X"
        }
        ; Verifica se jogador O venceu (bits 9 a 17)
        if (((stateO >> 9) & pattern) == pattern) {
            return "O"
        }
    }

    return false ; Nenhum vencedor ainda
}
