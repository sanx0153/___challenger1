#Requires AutoHotkey v2.0

class main {
    __New() {
        
    }
}

class output {
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
        answer := this.GUI.AddText(this.SquarePositionTag(line,column) " Border Center Disabled","0")
        return answer
    }
    Render()
    {
        for line in this.squares
        {
            nLine := A_Index
            for square in line
            {
                MsgBox(nLine A_Index)
            }
        }
    }
    SquarePositionTag(line,column)
    {
        x := (line - 1) * 50
        y := (column - 1) * 50
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