#Include Yunit.ahk

class YunitWindow extends Yunit
{
    __new()
    {
        global YunitWindowTitle, YunitWindowEntries
        Gui, Yunit:Font, s16, Arial
        Gui, Yunit:Add, Text, x0 y0 h30 vYunitWindowTitle Center, Test Results
        
        hImageList := IL_Create()
        IL_Add(hImageList,"shell32.dll",78) ;yellow triangle with exclamation mark
        IL_Add(hImageList,"shell32.dll",138) ;green circle with arrow facing right
        IL_Add(hImageList,"shell32.dll",135) ;two sheets of paper
        Gui, Yunit:Font, s10
        Gui, Yunit:Add, TreeView, x10 y30 vYunitWindowEntries ImageList%hImageList%
        
        Gui, Yunit:Font, s8
        Gui, Yunit:Add, StatusBar
        Gui, Yunit:+Resize +MinSize320x200
        Gui, Yunit:Show, w500 h400, Yunit Testing
        Gui, Yunit:+LastFound
        
        this.Categories := {}
        Return this
        
        YunitGuiSize:
        GuiControl, Yunit:Move, YunitWindowTitle, w%A_GuiWidth%
        GuiControl, Yunit:Move, YunitWindowEntries, % "w" . (A_GuiWidth - 20) . " h" . (A_GuiHeight - 60)
        Gui, Yunit:+LastFound
        WinSet, Redraw
        Return
        
        YunitGuiClose:
        ExitApp
    }
    
    Update(Category, TestName, Result)
    {
        Gui, Yunit:Default
        If !this.Categories.HasKey(Category)
            this.AddCategories(Category)
        Parent := this.Categories[Category]
        If IsObject(result)
        {
            hChildNode := TV_Add(TestName,Parent,"Icon1 Sort")
            TV_Add("Line #" result.line ": " result.message,hChildNode,"Icon3")
        }
        Else
            TV_Add(TestName,Parent,"Icon2 Sort")
    }
    
    AddCategories(Categories)
    {
        Parent := 0
        Category := ""
        Loop, Parse, Categories, .
        {
            Category .= (Category == "" ? "" : ".") A_LoopField
            If (!this.Categories.HasKey(Category))
                this.Categories[Category] := TV_Add(A_LoopField, Parent, "Icon3")
            Parent := this.Categories[Category]
        }
    }
}