#Requires AutoHotkey v2.0
#SingleInstance Force
#Include tools.ahk
LAUGH := "HaHAhA"
SMILE := Chr(0x003D) Chr(0x0029)
CARD := Chr(0x004B) Chr(0x2660)
A_ScriptName := CARD
app := main()
app.start()

class Joke
{
    table := ["LAUGH","SMILE","CARD"]
    tick := 0
    __New()
    {
        target := ObjBindMethod(this,"Play")
        SetTimer(target,2000)
    }
    Play()
    {
        if this.tick == 3
            this.tick := 0
        ++this.tick
        A_ScriptName := this.table[this.tick]
        MsgBox(%this.table[this.tick]%,,"t1")
    }
}

class input
{
    __New(parent)
    {
        this.parent := %parent%
    }
    static play(index,*)
    {
        for i, v in A_Args
            MsgBox(i " " v,,"t1")
        logic.trySquare(index)
    }
}

class logic
{
    static board := logic.createBoard()
    static currentPlayer := 0x1
    static state
    {
        get
        {
            answer := ""
            loop logic.board.Length
            {
                answer .= logic.board[A_Index].state
            }
            return answer
        }
    }
    static stateO
    {
        get
        {
            answer := ""
            loop logic.board.Length
            {
                answer .= logic.board[A_Index].isO
            }
            return answer
        }
    }
    static stateX
    {
        get
        {
            answer := ""
            loop logic.board.Length
            {
                answer .= logic.board[A_Index].isX
            }
            return answer
        }
    }
    __New(parentlink)
    {
        static parent := %parentlink%
    }
    static checkDraw()
    {
        loop logic.board.Length
        {
            if logic.board[A_Index].isEmpty == true
                return false
        }
        logic.gameState := "draw"
        return true
    }
    static checkWinner()
    {
    ; Máscaras binárias para padrões de vitória
    patterns := [
        000000111,  ; Linha 1        - 0b000000111
        000111000,  ; Linha 2        - 0b000111000
        111000000,  ; Linha 3       - 0b111000000
        001001001,  ; Coluna 1       - 0b001001001
        010010010,  ; Coluna 2       - 0b010010010
        100100100,  ; Coluna 3      - 0b100100100
        100010001,  ; Diagonal principal - 0b100010001
        001010100   ; Diagonal secundária - 0b001010100
    ]
    stateO := logic.stateO
    stateX := logic.stateX
    MsgBox(stateO " " stateX)
    for pattern in patterns 
        {
        if (stateO & pattern == pattern)
        {
            MsgBox("O venceu")
            return true
        }
        if (stateX & pattern == pattern)
            {
                MsgBox("X venceu")
                return true
            }
    }
    return false
    }
    static createBoard()
    {
        answer := []
        loop 9
        {
            answer.Push(LogicalSquare())
        }
        return answer
    }
    static endGame(how)
    {
        if !("draw" || "win" == how) ;this logical test can only work as this
        {
            MsgBox("Expected either 'draw' or 'win' but got" how)
            return false
        }
        MsgBox(how)
        return true
    }
    static endTurn()
    {
        switch logic.currentPlayer
        {
            case 0x1:
                logic.currentPlayer := 0x2
            case 0x2:
                logic.currentPlayer := 0x1
        }
        return true
    }
    static render()
    {
        answer := false
        updateIsDone := app.window.Update()
        if updateIsDone == true
            answer := true
        return answer
    }
    static trySquare(index)
    {
        if index == 0
            ++index
        answer := false
        boardIsPlayed := logic.board[index].play(logic.currentPlayer)
        if (boardIsPlayed == false)
        {
            MsgBox("Erro na execução da jogada. " A_ThisFunc,,"T1")
        }
        renderIsDone := logic.render()
        if (renderIsDone == false)
        {
            MsgBox("Erro de renderização")
        }
        if (boardIsPlayed & renderIsDone) == true
        {
            win := logic.checkWinner()
            if win == true
                return logic.endGame("win")
            draw := logic.checkDraw()
            if draw == true
                return logic.endGame("draw")
            logic.endTurn()
            answer := true
        }
        return answer
    }
}

class LogicalSquare
{
    isO := false
    isX := false
    isEmpty
    {
        get
        {
            answer := (this.isO & this.isX) == false ? true : false
            return answer
        }
    }
    state
    {
        get
        {
            answer := ""
            answer := this.isO . this.isX
            return answer
        }
    }
    value
    {
        get
        {
            answer := ""
            answer := to.Value(this.state)
            return answer
        }
    }
    play(who)
    {
        if (this.isEmpty == false)
        {
            MsgBox("Jogue em um Quadrado Vazio",,"t1")
            return false
        }
        table := ["O","X"]
        for , player in table
        {
            if (table[who] == player)
            {
                tag := table[who]
                this.isO := false
                this.isX := false
                this.is%tag% := true
                return true
            }
        }
        MsgBox(A_ThisFunc " esperando " table.OwnProps() " e recebeu " who)
        return false
    }
}


class main {
    static instance := ""
    __New()
    {
        if !main.instance
            main.instance := this
        global FLAGO, FLAGX, FLAGNULL
        link        := &this
        FLAGO       := 01
        FLAGX       := 10
        FLAGNULL    := 00
        this.logic  := logic(link)
        this.input  := input(link)
        this.window := window(link)
    }
    __Call()
    {
        return main.instance
    }
    start()
    {
        for i, v in this.OwnProps()
        {
            if v.HasMethod("start")
            {
                this.%i%.start()
            }
        }
    }
}

class window {
    __New(parent) 
    {
        this.parent  := %parent%
        this.GUI     := Gui("-Border -Caption")
        this.appear()
        this.squares := this.MakeBoard()
        this.Update()
    }

    CELL_W := 100
    CELL_H := 100
    WIN_W := (3 * this.CELL_W)
    WIN_H := (3 * this.CELL_H)
    
    state
    {
        get
        {
            answer := logic.state
            return answer
        }
    }

    appear()
    {
        this.GUI.Show("Center w" this.WIN_W " h" this.WIN_H)
    }
    MakeBoard()
    {
        answer := Make.Array(9)
        loop answer.Length
        {
            index := A_Index
            answer[index] := this.MakeSquare(index,this.parent)
        }
        return answer
    }
    MakeSquare(index,parent)
    {
        answer := this.GUI.AddText(this.SquarePositionTag(To.Column(index),To.Line(index)) " w" this.CELL_W " h" this.CELL_H " Border Center",logic.board[index].value)
        answer.index := index
        answer.SetFont("w1000 s64 cPurple","Verdana")
        answer.OnEvent("DoubleClick",input.play.Bind(this,index))
        return answer
    }
    Render()
    {
        answer := false
        loop this.squares.Length
        {
            index := A_Index
            this.squares[index].Value := logic.board[index].value
        }
        answer := true
        return answer

    }
    SquarePositionTag(column,line)
    {
        x := (column - 1) * this.CELL_W
        y := (line - 1) * this.CELL_H
        answer := "x" x " y" y
        return answer
    }
    Update()
    {
        answer := false
        isRendered := this.Render()
        if isRendered == true
            answer := true
        return answer
    }
}

class Make
{
    static Array(N)
    {
        answer := []
        loop N
        {
            answer.Push("")
        }
        return answer
    }
    static Matrix(lines,columns)
    {
        answer := []
        loop lines
            {
                row := []
                loop columns
                {
                    row.Push("")
                }
                answer.Push(row)
            }
        return answer
    }
}