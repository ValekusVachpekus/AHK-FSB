!F1::
    ShowSettingsUI()
return

ShowSettingsUI() {
    global CRMP_USER_NICKNAME, poz, way, Zheton
    
    // Загружаем настройки перед отображением GUI
    LoadSettings()
    
    Gui, SettingsGUI:New, -MaximizeBox -MinimizeBox, Настройки AHK_FSB
    Gui, Color, White
    
    Gui, Font, s12 cNavy Bold, Segoe UI
    Gui, Add, Text, x20 y20 w400 Center, Настройки AHK_FSB
    
    Gui, Font, s9 cBlack Normal, Segoe UI
    Gui, Add, Text, x20 y60, Ваш никнейм в игре:
    Gui, Add, Edit, x20 y80 w300 vNewNickname, % CRMP_USER_NICKNAME
    
    Gui, Add, Text, x20 y120, Ваш позывной:
    Gui, Add, Edit, x20 y140 w300 vNewPoz, % poz
    
    Gui, Add, Text, x20 y180, Номер маски (жетона):
    Gui, Add, Edit, x20 y200 w300 vNewZheton, % Zheton
    
    Gui, Add, Text, x20 y240, Путь к папке игры:
    Gui, Add, Edit, x20 y260 w250 vNewWay, % way
    Gui, Add, Button, x280 y258 w40 h23 gSelectGameFolder, ...
    
    Gui, Add, Button, x20 y300 w120 h30 gSaveSettings, Сохранить
    Gui, Add, Button, x150 y300 w120 h30 gCancelSettings, Отмена
    Gui, Add, Button, x280 y300 w120 h30 gApplySettings, Применить
    
    Gui, Font, s8 cGray, Segoe UI
    Gui, Add, Text, x20 y340, *После сохранения требуется перезапуск скрипта
    
    Gui, Show, w420 h380
}

SelectGameFolder:
    FileSelectFolder, selectedFolder,, 3, Выберите папку с игрой
    if (selectedFolder != "") {
        newPath := selectedFolder . "\amazing\chatlog.txt"
        GuiControl, , NewWay, % newPath
    }
return

SaveSettings:
    Gui, Submit, NoHide
    ApplyNewSettings()
    Reload
return

ApplySettings:
    Gui, Submit, NoHide
    ApplyNewSettings()
    MsgBox, 64, Настройки AHK_FSB, Настройки применены!`nСкрипт будет работать с новыми параметрами.
    Gui, Destroy
return

CancelSettings:
    Gui, Destroy
return

ApplyNewSettings() {
    global NewNickname, NewPoz, NewZheton, NewWay
    
    // Сохраняем настройки в config.ini
    IniWrite, %NewNickname%, config.ini, Settings, Nickname
    IniWrite, %NewPoz%, config.ini, Settings, Poz
    IniWrite, %NewZheton%, config.ini, Settings, Zheton
    IniWrite, %NewWay%, config.ini, Settings, Way
    
    // Обновляем глобальные переменные
    CRMP_USER_NICKNAME := NewNickname
    poz := NewPoz
    Zheton := NewZheton
    way := NewWay
    
    // Очищаем временные переменные
    NewNickname := ""
    NewPoz := ""
    NewZheton := ""
    NewWay := ""
}

LoadSettings() {
    global CRMP_USER_NICKNAME, poz, Zheton, way
    
    // Проверяем существует ли config файл
    IfNotExist, config.ini
    {
        // Создаем config файл с значениями по умолчанию
        IniWrite, Имя_Фамилия, config.ini, Settings, Nickname
        IniWrite, Позывной, config.ini, Settings, Poz
        IniWrite, XXX-XXX, config.ini, Settings, Zheton
        IniWrite, C:\Amazing Games\Amazing Online\PC\, config.ini, Settings, Way
    }
    
    // Читаем значения из config файла
    IniRead, CRMP_USER_NICKNAME, config.ini, Settings, Nickname, Имя_Фамилия
    IniRead, poz, config.ini, Settings, Poz, Позывной
    IniRead, Zheton, config.ini, Settings, Zheton, XXX-XXX
    IniRead, way, config.ini, Settings, Way, C:\Amazing Games\Amazing Online\PC\
}