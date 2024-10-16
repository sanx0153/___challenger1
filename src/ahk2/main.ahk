#Requires AutoHotkey v2.0
#SingleInstance Force
LAUGH := "HaHAhA"
SMILE := Chr(0x003D) Chr(0x0029)
CARD := Chr(0x004B) Chr(0x2660)
A_ScriptName := CARD
main()

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
        if this.tick = 3
            this.tick := 0
        this.tick++
        A_ScriptName := this.table[this.tick]
        MsgBox(%this.table[this.tick]%,,"t1")
    }
}

class input
{
    __New(parent)
    {
        this.parent := parent
    }
    Try(line,column)
    {
        return this.parent.logic.trySquare(line,column)
    }
}

class logic
{
    state
    {
        get
        {
            answer := ""
            loop this.board.Length
            {
                answer .= this.board[A_Index]
            }
            return answer
        }
    }
    __New(parent)
    {
        this.parent := parent
        this.board := this.createBoard()
        this.currentPlayer := this.firstPlayer()
    }
    createBoard()
    {
        answer := []
        loop 9
        {
            answer.Push(LogicalSquare())
        }
    }
    firstPlayer()
    {
        answer := ""
        table := ["O","X"]
        ;logica para decidir primeiro player
        answer := table[1] ;eliminar depois de fazer acima.
        return answer
    }
    render()
    {
        return this.parent.output.Update(this.state)
    }
    trySquare(line,column)
    {
        who := this.currentPlayer
        squareIndex := line * ( 1  + column )
        target := this.board[squareIndex]
        if target.isEmpty = false
            return MsgBox("Clique duplo em um quadrado vazio, por favor.",,"t1")
        target.play(who)
        return this.render()
    }
    
}

class logicalSquare
{
    isO := false
    isX := false
    isEmpty
    {
        get
        {
            if (this.isO && this.isX == false)
                return true
            return false
        }
    }
    play(who)
    {
        who := StrUpper(who)
        table := ["O","X"]
        for , player in table
        {
            if (who == player)
            {
                this.is%who% := true
                return true
            }
        }
        return MsgBox(A_ThisFunc " esperando " table.OwnProps() " e recebeu " who)
    }
}


class main {
    __New()
    {
        this.input := input(this)
        this.logic := logic(this)
        this.output := output(this)
    }
}

class output {
    CELL_W := 100
    CELL_H := 100
    __New(parent) {
        this.parent := parent
        this.GUI := Gui("-Border -Caption")
        this.tools := tools()
        this.squares := this.MakeBoard()
        this.state := ""
        this.appear()
        this.render()
    }
    appear()
    {
        this.GUI.Show("Center AutoSize")
    }
    getIndexFromLineColumn(line,column)
    {
        answer := ""
        answer := (((line - 1) * 3) + column)
        return answer
    }
    getSquareValueFromBoardState(board,line,column)
    {
        answer     := ""
        index      := this.getIndexFromLineColumn(line,column)
        dictionary := {00: "",01: "X",10: "O"}
        return answer
    }
    MakeBoard()
    {
        answer := this.tools.MakeArray(3)
        for line in answer
        {
            answer[A_Index] := this.MakeLine(A_Index)
        }
        return answer
    }
    MakeLine(N)
    {
        line := N
        answer := this.tools.MakeArray(3)
        for column in answer
        {
            column := A_Index
            answer[column] := this.MakeSquare(line,column,this.parent)
        }
        return answer
    }
    MakeSquare(line,column,parent)
    {
        answer := this.GUI.AddText(this.SquarePositionTag(line,column) " w" this.CELL_W " h" this.CELL_H " Border Center","")
        answer.SetFont("w1000 s64 cPurple","Verdana")
        answer.position := []
        answer.position.Push(line,column)
        answer.OnEvent("DoubleClick",ObjBindMethod(parent.input,"try",line,column))
        return answer
    }
    Render()
    {
        board := this.state
        for line in this.squares
        {
            nLine := A_Index
            for square in line 
            {
                nColumn := A_Index
                this.squares[nLine][nColumn].Value(this.getSquareValueFromBoardState(board,nLine,nColumn))
            }
        }
    }
    SetSquareValue(line,column,theValue)
    {
        this.squares[line][column].Value := theValue
    }
    SquarePositionTag(line,column)
    {
        x := (line - 1) * this.CELL_W
        y := (column - 1) * this.CELL_H
        answer := "x" x " y" y
        return answer
    }
    Update(logicState)
    {
        this.state := logicState
        this.Render()
    }
}

class tools
{
    MakeArray(N)
    {
        answer := []
        loop N
        {
            answer.Push("")
        }
        return answer
    }
    MakeMatrix(lines,columns)
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