#Include UDF.ahk
#Include helperFSB_test.ahk

ActiveID := 0
way := "C:\Amazing Games\Amazing Online\PC\amazing\chatlog.txt"
global CRMP_USER_NICKNAME := "Vladislav_Shetkov"
global poz := "Фантом"
global chatFile := ""
global chatPos := 0
global activeEvent := ""
global cufffl := false
global UserID := 0

#Persistent
SetTimer, ChatWatcher, 500
Sleep, 5000
loadInGame()
Return

ChatWatcher:
    if (!IsObject(chatFile)) {
        chatFile := FileOpen(way, "r-d")
        if (!IsObject(chatFile)) {
            FileAppend,, %way%
            chatFile := FileOpen(way, "r-d")
        }
        chatFile.Seek(0, 2)
        chatPos := chatFile.Pos
        return
    }
    
    currentSize := chatFile.Length
    if (currentSize < chatPos) {
        chatFile.Close()
        chatFile := FileOpen(way, "r-d")
        chatPos := 0
    }
    
    if (currentSize > chatPos) {
        chatFile.Seek(chatPos)
        newData := chatFile.Read()
        chatPos := chatFile.Pos
        
        Loop, Parse, newData, `n, `r
        {
            line := Trim(A_LoopField)
            if (line != "") {
                ProcessChatLine(line)
            }
        }
    }
return

ProcessChatLine(line) {

    if InStr(line, CRMP_USER_NICKNAME) && InStr(line, "местоположение") {
        RegExMatch(line, "запросил местоположение (\w+_\w+) \[(\d+)\]\", zapros)
        sendChat("/id " zapros2)
    }
    
    if InStr(line, "Вы оглушили") {
        if (InStr(line, "дубинки") || InStr(line, "электрошокера")) {
            if InStr(line, "Неизвестный [") {
                RegExMatch(line, "Вы оглушили Неизвестный \[(\d+)\]", pmask)
                activeEvent := "saveMask"
                addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}> Нажмите Y чтобы записать маску " pmask1)
            } else {
                RegExMatch(line, "Вы оглушили (\w+_\w+)", name)
                sendChat("/id " name1)
            }
        }
    }
    
    if InStr(line, "Сработала сигнализация дома") {
        RegExMatch(line, "Сработала сигнализация дома (\d+)", pid)
        activeEvent := "signal"
        addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}> Нажмите Y чтобы отметить дом " pid1)
    }
    
    if InStr(line, "употребил(-а)") && (InStr(line, "пудру") || InStr(line, "чай")) {
        if InStr(line, "Неизвестный [") {
            RegExMatch(line, "Неизвестный \[(\d+)\] употребил", pmmask)
            activeEvent := "narkoMask"
            addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}> Рядом употребили наркотики! Нажмите Y для маски " pmmask1)
        } else {
            RegExMatch(line, "(\w+_\w+) употребил", narko)
            activeEvent := "narkoID"
            addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}> Рядом употребили наркотики! Нажмите Y для ID " narko1)
        }
    }
    
    if InStr(line, "Вы начали спасать игрока") {
        if InStr(line, "Неизвестный [") {
            RegExMatch(line, "Вы начали спасать игрока Неизвестный \[(\d+)\]", pmaskk)
            activeEvent := "saveUnknown"
            addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}> Спасаете игрока! Нажмите Y для наручников")
        } else {
            RegExMatch(line, "Вы начали спасать игрока (\w+_\w+)", acuff)
            activeEvent := "saveKnown"
            addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}> Спасаете " acuff1 "! Нажмите Y для наручников")
        }
    }
    
    if InStr(line, "Вы спасли") {
        if (cufffl) {
            RegExMatch(line, "Вы спасли (\w+_\w+)", acuff)
            SendChat("/cuff " UserID)
            Sleep 500
            SendChat("/frac " UserID)
            Sleep 300
            SendInput {sc2}{sc2}
            Sleep 200  
            SendInput {sc5}{sc5}
            cufffl := false
        }
    }
    
    if InStr(line, CRMP_USER_NICKNAME) && InStr(line, "преследование") {
        RegExMatch(line, "\[(\d+)\] начал преследование за (\w+_\w+) \[(\d+)\]", presled)
        sendchat("/id " presled3)
    }
    
    if InStr(line, "Игроки онлайн:") {
        RegExMatch(line, "\}\[(.*)\]", pid)
        UserID := pid1
        addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}> ID обновлен: " UserID)
    }
}

~Y::
    if (activeEvent = "signal") {
        sendChat("/gps")
        Sleep 300
        SendInput, {Down 15}{Enter}
        Sleep 300
        SendInput %RegHomeId%{Enter}
        activeEvent := ""
    }
    else if (activeEvent = "narkoMask") {
        saveMask(pmmask1)
        activeEvent := ""
    }
    else if (activeEvent = "narkoID") {
        sendChat("/id " narko1)
        activeEvent := ""
    }
    else if (activeEvent = "saveUnknown" || activeEvent = "saveKnown") {
        cufffl := true
        sendchat("/id " pmaskk1)
        activeEvent := ""
    }
    else if (activeEvent = "saveMask") {
        saveMask(pmask1)
        activeEvent := ""
    }
return

~N::
    if (activeEvent != "") {
        addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}> Действие отменено")
        activeEvent := ""
    }
return



// Вбив id
!1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
Sleep 100
SendInput, /Введите ID подозреваемого:{space}
Sleep 50
Input, UserID, I L6 V, {Enter}
addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}>  {94f8ff}ID {ffffff}подозреваемого был обновлен на {94f8ff}"UserID)

If ActiveID == 0
{
CustomColor3 = EEAA99

Gui +LastFound +AlwaysOnTop -Caption +ToolWindow 

Gui, Color, black

Gui, Font, s7

Gui, Font, cWhite

Gui, Font, w%Скорость1%0

GUI, ADD, TEXT,, ID = %UserID%

WinSet, TransColor, %CustomColor3% 180

Gui, Show, x5 y50 NoActivate, window.	
}

Else
{
Gui Destroy

CustomColor3 = EEAA99

Gui +LastFound +AlwaysOnTop -Caption +ToolWindow 

Gui, Color, black

Gui, Font, s7

Gui, Font, cWhite

Gui, Font, w%Скорость1%0

GUI, ADD, TEXT,, ID = %UserID%

WinSet, TransColor, %CustomColor3% 180

Gui, Show, x5 y50 NoActivate, window.
}
Return

// Бинд своей команды
!Numpad3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
Sleep 100
SendInput, /Введите текст:{space}
Sleep 50
Input, Vnedrenie, I L50 V, {Enter}
Return

// Отправка своей команды
Numpad3::
SendChat(Vnedrenie)
Return

// Представление
!2::
SendChat("Здравия желаю, оперуполномоченный Т-УФСБ. Мой личный позывной "Poz )
Return


// chase id
!3::
If UserID < 1000
{
SendChat("/chase " + UserID)
}
Else
{
SendChat("/chaseid " + UserID)
}
Return


// deject id
!4::
If UserID < 1000
{
SendChat("/deject " + UserID)
}
Else
{
SendChat("/dejectid " + UserID)
}
Return


// cuff залом
!5::
SendChat("/cuff " + UserID)
Sleep 500
SendChat("/frac " + UserID)
Sleep 300
SendInput {sc2}{sc2}
Sleep 200  
SendInput {sc5}{sc5}
Return


// incar
!6::
SendChat("/incar " + UserID)
Sleep 500
SendChat("/me открыл дверь автомобиля, посадил задержанного в автомобиль, пристегнул ремнем безопасности")
Return


// Остановка
!7::
SendChat("/m [УФСБ] Водитель, останавливаемся и прижимаемся к обочине")
Sleep 500
SendChat("/m [УФСБ] В случае неподчинения, я открываю огонь по колёсам")
Return


// Пропуск тс
!8::
SendChat("/m [УФСБ] Водитель, уходим в другую полосу")
Sleep 500
SendChat("/m [УФСБ] Пропускаем спец.транспорт")
Return


// police
!9::
SendChat("/police")
Sleep 500
SendChat("/me нажал на кнопку вкл/выкл проблесковых маячков")
Return


// chase
Numpad0::
SendChat("/chase")
Return


// frac
Numpad1::
SendChat("/frac " + UserID)
Return


// Пробив по id
Numpad2::
SendChat("/frac")
Sleep 120
SendInput {sc2}{sc2}
Sleep 120  
SendInput {sc4}{sc4}
Sleep 120  
SendInput {sc4}{sc4}
Sleep 120
SendInput %UserID%
Sleep 60
SendInput, {Enter}
Return


// Зачитать права
:?:!права::
SendInput, {Enter}
SendChat("Вы имеете право на отказ от дачи показаний против себя и своих близких.")
Sleep 3000
SendChat("Вы имеете на ознакомление со всеми протоколами, составленными при задержании.")
Sleep 3000
SendChat("Вы имеете право на адвоката, переводчика, медицинскую помощь и один телефонный звонок. Вам они будут предоставлены в ИВС.")
Sleep 3000
SendChat("Если вы желаете обжаловать задержание, можете оставить жалобу на официальном портале области.")
Return


// Связаться в депортамент
:?:!деп::
SendMessage, 0x50,, 0x4190419,, A
SendInput /d [УФСБ/] Говорит %poz%.{left 17}
Return


:?:!сос::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r Докладывает: %poz%. Выехал на вызов СОС.
Return

:?:!смс::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r Докладывает: %poz%. Начал прослушку СМС и вызовов.
Return

:?:!смс1::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r Докладывает: %poz%. Продолжаю прослушку СМС и вызовов.
Return

:?:!смс2::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r Докладывает: %poz%. Завершил прослушку СМС и вызовов.
Return


:?:!прослушка::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r Докладывает: %poz%. Начал прослушку ЧОП "".{left 2}
Return


:?:!прослушка1::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r Докладывает: %poz%. Продолжаю прослушку ЧОП "".{left 2}
Return


:?:!прослушка2::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r Докладывает: %poz%. Завершил прослушку ЧОП "".{left 2}
Return


:?:!внедрение::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r Докладывает: %poz%. Начал внедрение ЧОП "".{left 2}
Return


:?:!внедрение1::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r 0 Докладывает: %poz%. Продолжаю внедрение ЧОП "".{left 2}
Return


:?:!внедрение2::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r Докладывает: %poz%. Завершил внедрение ЧОП "".{left 2}
Return


:?:!сос1::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r Докладывает: %poz%. Прибыл на вызов СОС.
Return

:?:!угон::
SendInput, {Enter}
SendChat("/r Докладывает " poz ": выехал на вызов об автоугоне.")
Return

:?:!угон1::
SendInput, {Enter}
SendChat("/r Докладывает " poz ": прибыл на вызов об автоугоне.")
Return

:?:!вк::
SendMessage, 0x50,, 0x4190419,, A
Sendinput, /r Докладывает: %poz%. Начал сопровождение военной колонны C-1, К-1.{left 6}
Return

:?:!вк1::
SendMessage, 0x50,, 0x4190419,, A
Sendinput, /r Докладывает: %poz%. Завершил сопровождение военной колонны C-1, К-1.{left 6}
Return

:?:!эв::
SendInput, {Enter}
SendChat("/me прикрепил трос к бамперу автомобиля")
Return


// Тут свою маску впишите
:?:!уд::
SendInput, {Enter}
SendChat("/do Номер жетона сотрудника Т-УФСБ: «271-832».")
Return

:?:!м::
SendInput, {Enter}
SendChat("/mask")
Sleep 600
SendChat("/call 97710514")
Sleep 600
SendChat("/h")
Return

:?:!ар::
SendInput, {Enter}
SendChat("/me позвал дежурного по рации")
Sleep, 500
SendChat("/do Дежурный вышел, после чего забрал задержанного и посадил в КПЗ.")
Return

:?:!ш::
SendInput, {Enter}
SendChat("/frac " + UserID)
Sleep 300
SendInput {sc2}{sc2}
Sleep 200  
SendInput {sc7}{sc7}
Sleep 200  
SendInput {sc2}{sc2}
Sleep 200  
SendChat("/me достал КПК, авторизовался как военнослужащий УФСБ, ввел данные гражданина")
Sleep 500
SendChat("/do Личное дело найдено.")
Sleep 500
SendChat("/me начал выписывать штраф")
sleep 30000
addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}> {ffffff} 30 секунд прошло!")
Return


:?:!су::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {Enter}
if(UserID ==) {
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_FSB {155912}> {ffffff} Вы не зарегистрировали ID в системе")
}
else {
sendChat("/su " UserID)
SendChat("/su " + UserID)
Sleep 500
SendChat("/me достал КПК, авторизовался как военнослужащий УФСБ, ввел данные гражданина")
Sleep 500
SendChat("/do Личное дело найдено.")
Sleep 500
SendChat("/me начал вводить корректировки")
sleep 20000
addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}> {ffffff} 20 секунд прошло!")
}
return

:?:!пр::
SendInput, {Enter}
Sleep 200
SendChat("/me взял бланк протокола и ручку и начал заполнять")
Sleep 1000
SendChat("/me вписал личные данные задержанного лица, обстоятельства и причины задержания, дату и время")
Sleep 1000
SendChat("/me вписал свой позывной")
Sleep 2000
SendChat("Расписываться в протоколе будете?")
Return

:?:!визиткадс::
SendInput, {Enter}
sendChat("/me достал визитку из нагрудного кармана и передал человеку напротив")
Sleep 700
sendChat("/do На визитке написано: «com/users/abysmalrat7.")
Sleep 700
sendChat("/b Это дискорд. В браузере вбиваешь: «discord.», после вставляешь содержимое в кавычках выше.")
Sleep 700
sendChat("/b В ином случае, добавляешь в друзья по никнейму: «abysmalrat7».")
Return

:?:!визиткавк::
SendInput, {Enter}
sendChat("/me достал визитку из нагрудного кармана и передал человеку напротив")
Sleep 700
sendChat("/do На визитке написано: «com/10kus».")
Sleep 700
sendChat("/b Это ВК. В браузере вбиваешь: «vk.», после вставляешь содержимое в кавычках выше.")
Sleep 700
sendChat("/b В ином случае, ищешь по id: «10kus».")
Return


:?:!камера::
SendInput, {Enter}
sendChat("/do Нагрудная камера висит на груди.")
Sleep 1000
sendChat("/me нажал на кнопку включения видеозаписи")
Sleep 1000
sendChat("/do Нагрудная камера включена.")
Return


:?:!блокнот::
SendInput, {Enter}
sendChat("/me достал блокнот и шариковую ручку из внутреннего кармана")
Sleep 1000
sendChat("/do Блокнот в левой руке, шариковая ручка в правой руке.")
Sleep 1000
sendChat("/me недовольно записывает что-то в блокнот")
Return


:?:!ешка::
SendInput, {Enter}
sendChat("/do Mercedes-Benz E63S AMG 4MATIC+ (W213, 2021). Номер: А444УЕ 74.")
Sleep 2000
sendChat("/do Двигатель: 4.0L V8 битурбо, 812 л.с./1102 Нм. Тюнинг Stage 3.")
Sleep 2000
sendChat("/do РЭБ «Грач-М2»: подавление GSM/GPS/ГЛОНАСС (0.8-6 ГГц).")
Sleep 2000
sendChat("/do Система «Ключ-М», позволяющая открывать любые ворота.")
Sleep 2000
sendChat("/do Бронезащита: класс VR7 (корпус), BR6 (стекла). Противовзрывное днище.")
Sleep 2000
sendChat("/do Тактический компьютер «Омега-ТК4» с криптозащитой AES-256.")
Sleep 2000
sendChat("/do Оптика: ИК-фары (800 м), оснащены страбоскопами, скрытые камеры 360°.")
Sleep 2000
sendChat("/do Багажник: «БРС-3» (3 шт), ГРП «Кордон-Т», саперный набор «EOD-9».")
Return


// Солнцезащитные очки
:?:!очки::
SendInput, {Enter}
sendChat("/me снял складные очки с нагрудного кармана, надел их")
Sleep 1000
sendChat("/do Поляризационные линзы, черная оправа.")
Return

:?:!очки1::
SendInput, {Enter}
sendChat("/me снял складные очки, сложил, повесил на нагрудный карман")
Sleep 1000
sendChat("/do Очки висят на нагрудном кармане.")
Return


// кофе
:?:!кофе::
SendInput, {Enter}
sendChat("/me взял термокружку с подстаканника")
Sleep 1000
sendChat("/do Надпись: «ФСБ России.")
Return


:?:!кофе1::
SendInput, {Enter}
sendChat("/me поставил термокружку на крышу машины")
Sleep 1000
sendChat("/do Горячий кофе, пар идет из отверстия в крышке.")
Return


:?:!кофе2::
SendInput, {Enter}
sendChat("/me взял термокружку с крыши машины")
Sleep 1000
sendChat("/do Черный кофе без сахара, температура 68°.")
Sleep 1000
sendChat("/me сделал несколько глотков, поставил стакан обратно")
Return


// сигарета
:?:!сигарета::
SendInput, {Enter}
sendChat("/me достал пачку сигарет")
Sleep 2000
sendChat("/do Пачка «Parlament», 9 сигарет осталось, одна перевернута.")
Sleep 2000
sendChat("/me достал сигарету и зажигалку из пачки, поджег сигарету")
Sleep 2000
sendChat("/do Дым медленно рассеивается в воздухе.")
Return


// карта
:?:!карта::
SendInput, {Enter}
sendChat("/me развернул бумажную карту")
Sleep 1000
sendChat("/do Карта Нижегородской области с пометками маркером.")
Return


// Осмотр АПС
:?:!апс::
SendInput, {Enter}
sendChat("/me извлек пистолет Стечкина из кобуры")
Sleep 1000
sendChat("/do Оружие: АПС, серийный номер ПК81В, 20 патронов в магазине.")
Sleep 1000
sendChat("/me проверил наличие патрона в патроннике, поставил на предохранитель")
Return


// Подсказки
flvu1 := False, flvu2 := False, flvu3 := False
flfp1 := False, flfp2 := False, flfp3 := False
current_doc := 0

:?:!ву::
{
    SendInput, {Enter}
    global current_doc, flvu1, flvu2, flvu3
    
    if (current_doc != 1)
    {
        CloseAllDocs()
        current_doc := 1
        flvu1 := True
        vu1(flvu1)
    }
    else
    {
        CloseAllDocs()
        current_doc := 0
    }
    Return
}

:?:!фп::
{
    SendInput, {Enter}
    global current_doc, flfp1, flfp2, flfp3
    
    if (current_doc != 2)
    {
        CloseAllDocs()
        current_doc := 2
        flfp1 := True
        fp1(flfp1)
    }
    else
    {
        CloseAllDocs()
        current_doc := 0
    }
    Return
}

PgUp::
{
    global current_doc
    if (current_doc == 1)
        NavigateVU("next")
    else if (current_doc == 2)
        NavigateFP("next")
    Return
}

PgDn::
{
    global current_doc
    if (current_doc == 1)
        NavigateVU("prev")
    else if (current_doc == 2)
        NavigateFP("prev")
    Return
}

NavigateVU(direction) {
    global flvu1, flvu2, flvu3
    
    if (flvu1) {
        flvu1 := False
        flvu2 := (direction == "next") ? True : False
        flvu3 := (direction == "prev") ? True : False
        if (flvu2){
            vu2(True)
        }
        if (flvu3){
            vu3(True)
        } 
    }
    else if (flvu2) {
        flvu2 := False
        flvu3 := (direction == "next") ? True : False
        flvu1 := (direction == "prev") ? True : False
        if (flvu3){
            vu3(True)
        }
        if (flvu1){
            vu1(True)
        }
    }
    else if (flvu3) {
        flvu3 := False
        flvu1 := (direction == "next") ? True : False
        flvu2 := (direction == "prev") ? True : False
        if (flvu1){
            vu1(True)
        }
        if (flvu2){
            vu2(True)
        }
    }
}

NavigateFP(direction) {
    global flfp1, flfp2, flfp3
    
    if (flfp1) {
        flfp1 := False
        flfp2 := (direction == "next") ? True : False
        flfp3 := (direction == "prev") ? True : False
        if (flfp2){
            fp2(True)
        }
        if (flfp3){
            fp3(True)
        }
    }
    else if (flfp2) {
        flfp2 := False
        flfp3 := (direction == "next") ? True : False
        flfp1 := (direction == "prev") ? True : False
        if (flfp3){
            fp3(True)
        }
        if (flfp1){
            fp1(True)
        }
    }
    else if (flfp3) {
        flfp3 := False
        flfp1 := (direction == "next") ? True : False
        flfp2 := (direction == "prev") ? True : False
        if (flfp1){
            fp1(True)
        }
        if (flfp2){
            fp2(True)
        }
    }
}

CloseAllDocs() {
    global
    Gui Destroy
    flvu1 := flvu2 := flvu3 := False
    flfp1 := flfp2 := flfp3 := False
}


:?:!фп1::Return
:?:!фп2::Return
:?:!фп3::Return

!X::
{
    State4 := !State4
    help(State4)    
    Return
}


:?:!д::
SendMessage, 0x50,, 0x4190419,, A
SendInput, /Введите номер дома:{space}
Sleep 50
Input, k, I L15 V, {Enter}
if k is number
{
if k < 542
{
if (!checkHandles())
checkHandles()
Sleep 100
addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}>  {ffffff}На вашей карте отмечен {94f8ff}дом {ffffff}под номером {94f8ff}"k)
}
else
{
if (!checkHandles())
checkHandles()
Sleep 100
addChatMessageEx(0x4169E1, "{FF4D00} Вы указали неверный номер дома. Номера домов от 1 до 541, попробуйте заново")
return
}
}
Else
{
if (!checkHandles())
checkHandles()
Sleep 100
addChatMessageEx(0x4169E1, "{FF4D00}Введённая переменная не является числом, попробуйте заново")
return
}
sleep 400
sendChat("/gps")
sleep 200
SendInput, {Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{enter}
sleep 200
SendInput,%k%{Enter}
return


:?:!о::
SendMessage, 0x50,, 0x4190419,, A
SendInput, /Введите номер особняка:{space}
Sleep 50
Input, osoba, I L15 V, {Enter}
if osoba is number
{
if osoba < 54
{
if (!checkHandles())
checkHandles()
Sleep 100
addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}>  {ffffff}На вашей карте отмечен {94f8ff}особняк {ffffff}под номером {94f8ff}"osoba)
}
else
{
if (!checkHandles())
checkHandles()
Sleep 100
addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}> {FF4D00} Вы указали неверный номер особняка. Номера особняков от 1 до 53, попробуйте заново")
return
}
}
Else
{
if (!checkHandles())
checkHandles()
Sleep 100
addChatMessageEx(0x4169E1, "{FF4D00}Введённая переменная не является числом, попробуйте заново")
return
}
sleep 400
sendChat("/gps")
sleep 200
SendInput, {Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{enter}
sleep 200
SendInput,%osoba%{Enter}
Return


// Время
:?:/t::
SendInput, {esc}
sendchat("/time")
sleep 100
SetTimer, CheckTime, -1
SetTimer, CheckTime2, -1
SetTimer, CheckTime3, -1
return


// Вместо 2 ставьте свой часовой пояс
CorrectTime(originalTime) {
    hour := SubStr(originalTime, 1, 2)
    minute := SubStr(originalTime, 4, 2)
    newHour := hour - 2 < 0 ? 24 + (hour - 2) : hour - 2
    return Format("{:02d}:{:02d}", newHour, minute)
}

CheckTime:
FormatTime, CurrentTime,, HH:mm
CurrentTime := CorrectTime(CurrentTime) 
TimeArray := ["08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00", "00:00", "01:00", "02:00"]
MinRemaining := -1
TargetTime := ""
Loop, % TimeArray.MaxIndex()
{
CurrentTarget := TimeArray[A_Index]
Remaining := GetRemainingTime3(CurrentTime, CurrentTarget)
if (Remaining >= 0)
{
if (MinRemaining = -1 || Remaining < MinRemaining) {
MinRemaining := Remaining
TargetTime := CurrentTarget
}
}
}
if (TargetTime != "") {
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_FSB {155912}> {ffffff}До ближайшей угонки в {94f8ff}`n" TargetTime " {ffffff}осталось {94f8ff}" MinRemaining  " мин.")
}
Return
GetRemainingTime3(Current, Target) {
CurrentMinutes := SubStr(Current, 1, 2) * 60 + SubStr(Current, 4, 2)
TargetMinutes := SubStr(Target, 1, 2) * 60 + SubStr(Target, 4, 2)
if (TargetMinutes < CurrentMinutes)
TargetMinutes += 1440
Return TargetMinutes - CurrentMinutes
}
CheckTime2:
FormatTime, CurrentTime,, HH:mm
CurrentTime := CorrectTime(CurrentTime) 
TimeArray := ["08:00", "11:00", "14:00", "17:00", "20:00", "23:00", "02:00"]
MinRemaining := -1
TargetTime := ""
Loop, % TimeArray.MaxIndex()
{
CurrentTarget := TimeArray[A_Index]
Remaining := GetRemainingTime(CurrentTime, CurrentTarget)
if (Remaining >= 0)
{
if (MinRemaining = -1 || Remaining < MinRemaining) {
MinRemaining := Remaining
TargetTime := CurrentTarget
}
}
}
if (TargetTime != "") {
if (MinRemaining >= 0) {
Hours := Floor(MinRemaining / 60)
Minutes := MinRemaining - (Hours * 60)
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_FSB {155912}> {ffffff}До ближайшего ограбления в {94f8ff}" TargetTime " {ffffff}осталось {94f8ff}" Hours " ч. " Minutes " мин.")
} else {
addChatMessageEx(0xFFFFFF, "{ff0000}Ошибка: оставшееся время не может быть отрицательным.")
}
}
Return
GetRemainingTime(Current, Target) {
CurrentMinutes := SubStr(Current, 1, 2) * 60 + SubStr(Current, 4, 2)
TargetMinutes := SubStr(Target, 1, 2) * 60 + SubStr(Target, 4, 2)
if (TargetMinutes < CurrentMinutes)
TargetMinutes += 1440
Return TargetMinutes - CurrentMinutes
}
CheckTime3:
FormatTime, CurrentTime,, HH:mm
CurrentTime := CorrectTime(CurrentTime) 
TimeArray := ["15:00", "19:00"]
MinRemaining := -1
TargetTime := ""
Loop, % TimeArray.MaxIndex()
{
CurrentTarget := TimeArray[A_Index]
Remaining := GetRemainingTime(CurrentTime, CurrentTarget)
if (Remaining >= 0)
{
if (MinRemaining = -1 || Remaining < MinRemaining) {
MinRemaining := Remaining
TargetTime := CurrentTarget
}
}
}
if (TargetTime != "") {
if (MinRemaining >= 0) {
Hours := Floor(MinRemaining / 60)
Minutes := MinRemaining - (Hours * 60)
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_FSB {155912}> {ffffff}До ближайшего поезда в {94f8ff}" TargetTime " {ffffff}осталось {94f8ff}" Hours " ч. " Minutes " мин.")
} else {
addChatMessageEx(0xFFFFFF, "{ff0000}Ошибка: оставшееся время не может быть отрицательным.")
}
}
Return
GetRemainingTime0(Current, Target) {
CurrentMinutes := SubStr(Current, 1, 2) * 60 + SubStr(Current, 4, 2)
TargetMinutes := SubStr(Target, 1, 2) * 60 + SubStr(Target, 4, 2)
if (TargetMinutes < CurrentMinutes)
TargetMinutes += 1440
Return TargetMinutes - CurrentMinutes
}



// Функции НЕ ТРОГАТЬ
loadInGame() {
if (!checkHandles())
checkHandles()
Sleep 1500
addChatMessageEx(0, "          ")
addChatMessageEx(0, "{FFFFFF} AHK_FSB {155912}>{FFFFFF} Приветствуем, {94f8ff}" . CRMP_USER_NICKNAME)
addChatMessageEx(0, "{0082D1} AHK_FSB {155912}>{FFFFFF} Чтобы увидеть подсказку введите {94f8ff} !помощь")
addChatMessageEx(0, "{D1000C} AHK_FSB {155912}>{FFFFFF} Автор AHK - {94f8ff}Vladislav_Shetkov{FFFFFF}/{94f8ff}Vladislav_Valekus{FFFFFF}/{94f8ff}Glad_Valekus")
addChatMessageEx(0, "          ")
}

saveID(fplayerID) {
RegplayerId := fplayerID
if (UserID != fplayerID) {
UserID := fplayerID
addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}>{FFFFFF} ID игрока {94f8ff}" fplayerId " {FFFFFF}зарегистрирован")
} else {
addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}>{FFFFFF} ID игрока уже в системе!")
UserID := RegplayerId
}
}
Return
saveMasktwo(maskIDd) {
addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}>{FFFFFF} Нажмите клавишу {155912}Y{FFFFFF}, чтобы зарегестрировать маску, {b9181b}N{FFFFFF} для отмены")
startTime := A_TickCount
endTime := startTime + 15000
while A_TickCount < endTime {
if GetKeyState("Y", "P") {
RegplayerMask := maskID
if (playerMask != maskID) {
playerMask := maskID
addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}>{FFFFFF} Маска {94f8ff}" maskIDd " {FFFFFF}зарегистрирована")
Return
} else {
addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}>{FFFFFF} Маска игрока уже в системе!")
Return
}
break
}
if GetKeyState("N", "P") {
addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}>{FFFFFF} Отклонено!")
Return
}
Sleep, 10
}
addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}>{FFFFFF} Время принятия истекло")
Return
}
return
saveMask(maskID) {
RegplayerMask := maskID
if (playerMask != maskID) {
UserID := maskID
addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}>{FFFFFF} Маска игрока {94f8ff}" maskID " {FFFFFF}зарегистрирована")
} else {
addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}>{FFFFFF} Маска игрока уже в системе!")
UserID := RegplayerMask
}
}
Return


FracVoiceID(voiceID) {
FracVoice := voiceID
addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}>{FFFFFF} Нажмите {94f8ff}Y{FFFFFF}, чтобы отключиться от рации фракции")
voiceID := FracVoice
startTime := A_TickCount
endTime := startTime + 10000
while A_TickCount < endTime
if GetKeyState("Y", "P")
{
SendChat("/fvoice")
Return
}
}
Rana(ranenn) {
if (ranen == 1)
{
sendchat("/b Я ранен, мне нужна срочная поддержка! Координаты на моем вызове срочной помощи.")
sleep 350
sendChat("/sos")
Return
}
Else
{
}
}
Prest(pmaskk) {
    addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}> {FFFFFF}Список разыскиваемых был обновлен")
    Return
}

narkosha(narik) {
    narko = narik
    startTime := A_TickCount
    endTime := startTime + 10000
    while A_TickCount < endTime
    if GetKeyState("Y", "P")
    {
        SendChat("/id " narik)
        Return
    }
}
narkosham(pmmask) {
    narkom = pmmask
    startTime := A_TickCount
    endTime := startTime + 10000
    while A_TickCount < endTime
    if GetKeyState("Y", "P")
    {
        saveMask(pmmask)
        Return
    }
}


// Доклад о крушении поезда
:?:!поезд::

startTime := A_TickCount
endTime := startTime + 15000
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_FSB {155912}> {ffffff} Нажмите на кнопку {94f8ff}1{ffffff}, если поезд потерпел крушение в {94f8ff}пгт.Батырево")
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_FSB {155912}> {ffffff} Нажмите на кнопку {94f8ff}2{ffffff}, если поезд потерпел крушение в {94f8ff}г.Лыткарино")
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_FSB {155912}> {ffffff} Нажмите на кнопку {94f8ff}3{ffffff}, если поезд потерпел крушение на заводе {94f8ff}г.Арзамас")
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_FSB {155912}> {ffffff} Нажмите на кнопку {ff2428}4{ffffff}, для {94f8ff}отмены действия")
while A_TickCount < endTime {
if GetKeyState("1", "P") {
    sendchat("/r Докладывает: " Poz ". Крушение поезда произошло в пгт.Батырево")
    break
}
if GetKeyState("2", "P") {
    sendchat("/r Докладывает: " Poz ". Крушение поезда произошло в г.Лыткарино.")
    break
}
if GetKeyState("3", "P") {
    sendchat("/r Докладывает: " Poz ". Крушение поезда произошло на заводе г.Арзамас.")
    break
}
if GetKeyState("4", "P") {
    addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_FSB {155912}> {ffffff}Выбор отменен")
    return
}
}

return



// Список команд
:?:!помощь::
help1()
Return




LABEL_EXIT:
    if (IsObject(chatFile)) {
        chatFile.Close()
    }
    ExitApp
return

!Numpad0::reload 