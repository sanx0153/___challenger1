#Requires AutoHotkey v2.0
#SingleInstance Force
#Include tools.ahk
LAUGH := "HaHAhA"
SMILE := Chr(0x003D) Chr(0x0029)
CARD := Chr(0x004B) Chr(0x2660)
A_ScriptName := CARD
app := main()

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

class inputManager
{
    __New(parent)
    {
        this.parent := %parent%
        OnMessage(0x2000,this.play)
    }
    play(line,column,*)
    {
        MsgBox(line column)
        PostMessage(0x2001,line,column)
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
                answer .= this.board[A_Index].state
            }
            return answer
        }
    }
    __New(parent)
    {
        this.parent := %parent%
        this.currentPlayer := 1
        this.board := this.createBoard()
        OnMessage(0x2001,this.trySquare)
    }
    createBoard()
    {
        answer := []
        loop 9
        {
            answer.Push(LogicalSquare())
        }
        return answer
    }
    render()
    {
        return this.parent.window.Update()
    }
    trySquare(line,column,*)
    {
        who := this.currentPlayer
        squareIndex := To.Index(line,column)
        targetIsEmpty := this.board[squareIndex].isEmpty
        if targetIsEmpty == false
            return MsgBox("Clique duplo em um quadrado vazio, por favor.",,"t1")
        this.board[squareIndex].play(who) 
        return this.render()
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
            if (this.state == 00)
                return true
            return false
        }
    }
    state
    {
        get
        {
            answer := this.isO . this.isX
            return answer
        }
    }
    play(who)
    {
        if (this.isEmpty == false)
            return MsgBox("Jogue em um Quadrado Vazio")
        table := ["O","X"]
        for , player in table
        {
            if (table[who] == player)
            {
                tag := table[who]
                this.is%tag% := true
                return true
            }
        }
        MsgBox(A_ThisFunc " esperando " table.OwnProps() " e recebeu " who)
        return false
    }
}


class main {
    __New()
    {
        link        := &this
        this.logic  := logic(link)
        this.input  := inputManager(link)
        this.window := window(link)
    }
}

class window {
    __New(parent) 
    {
        this.parent  := %parent%
        this.GUI     := Gui("-Border -Caption")
        this.squares := this.MakeBoard()
        this.appear()
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
            answer := this.parent.logic.state
            return answer
        }
    }

    appear()
    {
        this.GUI.Show("Center w" this.WIN_W " h" this.WIN_H)
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
        index      := to.Index(line,column)
        dictionary := {00: "",01: "X",10: "O"}
        binary := SubStr(board,(((index - 1) * 2) + 1),2)
        answer := dictionary.%binary%
        return answer
    }
    MakeBoard()
    {
        answer := Make.Array(3)
        for line in answer
        {
            answer[A_Index] := this.MakeLine(A_Index)
        }
        return answer
    }
    MakeLine(N)
    {
        line := N
        answer := Make.Array(3)
        for column in answer
        {
            column := A_Index
            MsgBox(column)
            answer[column] := this.MakeSquare(line,column,this.parent)
        }
        return answer
    }
    MakeSquare(line,column,parent)
    {
        answer := this.GUI.AddText(this.SquarePositionTag(line,column) " w" this.CELL_W " h" this.CELL_H " Border Center","")
        answer.SetFont("w1000 s64 cPurple","Verdana")
        answer.OnEvent("DoubleClick",PostMessage.Bind(0x2000,line,column))
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
                this.squares[nLine][nColumn].Value := this.getSquareValueFromBoardState(board,nLine,nColumn)
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
    Update()
    {
        this.Render()
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