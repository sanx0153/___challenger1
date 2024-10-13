#Requires AutoHotkey v2.0
#SingleInstance Force
LAUGH := "HaHAhA"
SMILE := "=)"
CARD := Chr(0x004B) Chr(0x2660)
A_ScriptName := CARD

class main {
    __New() {
        
    }
}

class output {
    CELL_W := 100
    CELL_H := 100
    __New() {
        this.GUI := Gui("AlwaysOnTop -Border -Caption")
        this.tools := tools()
        this.squares := this.MakeBoard()
        this.Appear()
        this.render()
    }
    Appear()
    {
        this.GUI.Show("Center AutoSize")
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
            answer[column] := this.MakeSquare(line,column)
        }
        return answer
    }
    MakeSquare(line,column)
    {
        answer := this.GUI.AddText(this.SquarePositionTag(line,column) " w" this.CELL_W " h" this.CELL_H " Border Center","")
        answer.SetFont("w1000 s64 cPurple","Verdana")
        answer.Update
        {
            set
            {
                value := ;quero que update ao ser chamada faça com que value receba a correspondente value da parte logica
            }
        }
        return answer
    }
    Render()
    {
        for line in this.squares
        {
            nLine := A_Index
            for square in line 
            {
                nColumn := A_Index
                this.squares[nLine][nColumn].Update()
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

test := output()