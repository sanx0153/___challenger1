class To
; USAGE : To.Function(Args) => value
; EXAMPLE: line := to.line(index)
{
    static Binary(O_or_X)
    {
        answer := ""
        if StrUpper(O_or_X) != "O" || "X"
        {
            return MsgBox("I got this:" O_or_X " instead of O or X")
        }
        table := {O: 10,X: 01}
        answer := table[O_or_X]
        return answer
    }
    static Column(index) ;translates index into column number
    {
        answer := ""
        column := ""
        column := (Mod((index - 1),3) + 1)
        answer := column
        return answer    
    }
    static Index(line,column) ;states index from line,column numbers
    {
        args := Map()
        args["line"] := ""
        args["column"] := ""
        args["line"] := line
        args["column"] := column
        for i, j in args
            if (j < 1) || (j > 3)
                return MsgBox(i " precisa ser 1, 2 ou 3 mas é:" j)
        answer := ""
        index := ""
        index := (column + ((line - 1) * 3))
        answer := Integer(index)
        return answer
    }
    static Line(index) ;translates index into line number
    {
        answer := ""
        line := ""
        line := (((index - 1) // 3) + 1)
        answer := line
        return answer
    }
    static Value(flag) ; translates flag into O,X,?
    {
        answer := ""
        switch flag
        {
        case 00:
            answer := "?"
        case 01:
            answer := "X"
        case 10:
            answer := "O"
        case 0x1:
            answer := "X"
        case 0x2:
            answer := "O" 
        default:
            answer := "E"
        }
        return answer
    }
}
/*
    TestTools()

    TestTools()
    {
        loop 9
        {
            MsgBox(To.Line(A_Index),,"t2")
        }
}
*/