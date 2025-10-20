#include UDF.ahk
#Include helperFSB_test.ahk
#CommentFlag

// way - путь до папки игры\amazing\chatlog.txt
// CRMP_USER_NICKNAME - Ваш никнейм
// poz - Ваш позывной
// Ниже можете ввести свою маску и должность, все отмечено комментариями
// По желанию можете поменять бинды клавиш: ! - LAlt, ^-Ctrl

ActiveID = 0
way = C:\Users\ilusha\Desktop\PC\amazing\chatlog.txt
// way = C:\Amazing Games\Amazing Online\PC\amazing\chatlog.txt
global CRMP_USER_NICKNAME:="Vladislav_Shetkov"
global poz:="Фантом"
global strings=1



global cufffl


Sleep 1000

cufffl := False

loadInGame()
FileDelete, %way%
Goto, start

// Цикл
start:
FileReadLine, line, %way%, strings
{
    if ErrorLevel
    {
        goto start
    }
    else
    {

        // Пробив ООП id
        if line contains %CRMP_USER_NICKNAME%
        {
            If(InStr(line, "местоположение"))
            {
                RegExMatch(line, "запросил местоположение (\w+_\w+) \[(\d+)\]\", zapros)
                RegExMatch(line, "\[(\d+)\]", zapros)
                sendChat("/id " zapros1)
            }
        }


        // Тазер и дубинка
        if line contains Вы оглушили
        {
            if (InStr(line, "с помощью дубинки") or InStr(line, "с помощью электрошокера"))
            {
                if (InStr(line, "Неизвестный ["))
                {
                    RegExMatch(line, "Вы оглушили Неизвестный \[(.*)\] с помощью", pmask)
                    saveMasktwo(pmask1)
                }
                else {
                    RegExMatch(line, "Вы оглушили (.*) с помощью", name)
                    sendChat("/id " name1)
                }
            }
        }


        // Сигналка
        if line contains [R] Внимание всем постам
        {
            If(InStr(line, "Сработала сигнализация дома"))
            {
                RegExMatch(line, "Сработала сигнализация дома (.*), возможно", pid)
                RegHomeId := pid1
                addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}> {ffffff}Нажмите {94f8ff}Y{FFFFFF} если вы хотите отметить дом {94f8ff}" RegHomeId ".")
                ograb(RegHomeId)
                
            }
        }



        // Употребление id
        if line contains употребил(-а)
        {
            if (InStr(line, "мятную пудру") or InStr(line, "зеленый чай"))
            {
                if (InStr(line, "Неизвестный ["))
                {
                    RegExMatch(line, "Неизвестный \[(\d+)\] употребил(-а)", pmmask)
                    RegExMatch(line, "\[(\d+)\]", pmmask)
                    addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}> {ffffff}Рядом с вами употребили наркотики, нажмите {94f8ff}Y{FFFFFF}, чтобы записать маску игрока")
                    narkosham(pmmask1)
                }
                else {
                    RegExMatch(line, "(\w+_\w+) употребил(-а)", narko)
                    RegExMatch(line, "(\w+_\w+)", narko)
                    addChatMessageEx(-1, "{94f8ff} AHK_FSB {155912}> {ffffff}Рядом с вами употребили наркотики, нажмите {94f8ff}Y{FFFFFF}, чтобы записать ID игрока")
                    narkosha(narko1)
                }
            }
        }


        // Преследка id
        if InStr(line, CRMP_USER_NICKNAME)
        {
        if InStr(line, "преследование")
            {
                if RegExMatch(line, "\[(\d+)\] начал преследование за (\w+_\w+) \[(\d+)\]", presled)
                {
                    sendchat("/id " presled3)
                }
            }
        }

        // id из ника
        if line contains Игроки онлайн:
        {
            str := strings+=2
            sleep 25
            FileReadLine, nick, %way%, %str%
            if(InStr(nick, "Совпадений не найдено")) {
            } else {
                RegExMatch(nick, "\}\[(.*)\]", pid)
                UserID := pid1
                addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}>  {94f8ff}ID {ffffff}подозреваемого был обновлен на {94f8ff}"UserID)
            }
        }


        // Кафф после ПДП
        if line contains Вы начали
        {
            If(InStr(line, "спасать игрока"))
            {
                if (InStr(line, "Неизвестный ["))
                {
                    RegExMatch(line, "Вы начали спасать игрока Неизвестный \[(.*)\]", pmaskk)
                }
                else {
                    RegExMatch(line, "Вы начали спасать игрока (\w+_\w+)!", acuff)
                    RegExMatch(line, "(\w+_\w+)", acuff)
                    autocuff(acuff)

                }
            }
        }
        if line contains Вы
        {
            If(InStr(line, "спасли"))
            {
                if (cufffl){
                    RegExMatch(line, "Вы спасли (\w+_\w+)!", acuff)
                    RegExMatch(line, "(\w+_\w+)", acuff)
                    SendChat("/cuff " + UserID)
                    Sleep 500
                    SendChat("/frac " + UserID)
                    Sleep 300
                    SendInput {sc2}{sc2}
                    Sleep 200  
                    SendInput {sc5}{sc5}
                }
                
            }
        }

        strings+=1
        goto start
    }
}

// Вбив id
!1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
Sleep 100
SendInput, /Введите ID подозреваемого:{space}
Sleep 50
Input, UserID, I L6 V, {Enter}
addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}>  {94f8ff}ID {ffffff}подозреваемого был обновлен на {94f8ff}"UserID)
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

// Штрафы
Numpad4::
SendChat("/call")
Sleep 120
SendInput, {Down 10}
Sleep 120
SendInput, {Enter}
Sleep 100
SendInput, {Enter}
Sleep 100
SendInput, {Enter}
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
Sleep 180
SendInput {sc2}{sc2}
Sleep 180  
SendInput {sc4}{sc4}
Sleep 180  
SendInput {sc4}{sc4}
Sleep 180
SendInput %UserID%
Sleep 80
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

// переодеться
:?:!п::
SendInput, {Enter}
SendChat("/frac")
Sleep 180
SendInput {sc2}{sc2}
Sleep 180  
SendInput {sc4}{sc4}
Sleep 180  
SendInput {sc7}{sc7}
Sleep, 500
SendChat("/me достал комплект формы, переоделся")
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
SendChat("/me достал КПК, авторизовался как военнослужащий УФСБ, ввел данные гражданина, начал выписывать штраф")
sleep 30000
addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}> {ffffff} 30 секунд прошло!")
Return


// Уголовные штрафы
:?:!шук::
SendMessage, 0x50,, 0x4190419,, A
SendInput, /Введите сумму штрафа:{space}
Sleep 50
Input, fine_amount, I L10 V, {Enter}

SendInput, {F6}
Sleep 100
SendInput, /Введите номер статьи (ст. <Номер> УК):{space}
Sleep 50
Input, article_number, I L5 V, {Enter}
Sleep, 200
repetitions := Ceil(fine_amount / 50000)

SendInput, {Enter}
Sleep, 300

Loop, %repetitions%
{
    SendChat("/frac " + UserID)
    Sleep 300
    SendInput {sc2}{sc2}
    Sleep 200  
    SendInput {sc7}{sc7}
    Sleep 200  
    SendInput {sc2}{sc2}
    Sleep 200  
    SendInput {Down}
    Sleep 200  
    SendInput {Enter}
    Sleep 200  
    
    SendInput, 50000
    Sleep 200
    SendInput {Tab}
    Sleep 200  
    
    SendInput, ст. %article_number% УК
    Sleep 200
    SendInput {Enter}
    Sleep 200
    
    current_progress := A_Index * 50000
    if (current_progress > fine_amount)
        current_progress := fine_amount
    
    addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}> {ffffff} Процесс выписывания штрафа {94f8ff}(" current_progress "/" fine_amount ")")
    
    if (A_Index < repetitions)
        Sleep, 30000
}

addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {155912}> {ffffff} Штраф на сумму {94f8ff}" fine_amount " руб.{ffffff} по {94f8ff}ст. " article_number " УК{ffffff} выписан полностью!")

fine_amount := ""
article_number := ""
repetitions := ""
current_progress := ""
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

:?:!выг::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {Enter}
Sleep 100
SendChat("/me достал КПК, авторизовался как военнослужащий УФСБ, ввел данные сотрудника")
Sleep 2000
SendChat("/do Личное дело найдено.")
Sleep 2000
SendChat("/me начал вводить корректировки")
return


:?:!лдкар::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {Enter}
Sleep 100
SendChat("/me снял все предметы с лица гражданина")
Sleep 2000
SendChat("/me навел камеру бортового компьютера на лицо гражданина, сделал фоторобот")
Sleep 2000
SendChat("/me сделал запрос в базу данных УФСБ")
Sleep 2000
SendChat("/do Личное дело найдено.")
return


:?:!лд::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {Enter}
Sleep 100
SendChat("/me снял все предметы с лица гражданина, достал КПК")
Sleep 2000
SendChat("/me навел камеру КПК на лицо гражданина, сделал фоторобот")
Sleep 2000
SendChat("/me сделал запрос в базу данных УФСБ")
Sleep 2000
SendChat("/do Личное дело найдено.")
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


:?:!визиткатг::
SendInput, {Enter}
sendChat("/me достал визитку из нагрудного кармана и передал человеку напротив")
Sleep 700
sendChat("/do На визитке написано: «@FSBamazingbot».")
Sleep 700
sendChat("/b Это телеграмм. Открываешь телеграмм и ищешь по юзернейму бота.")
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


:?:!жига::
SendInput, {Enter}
sendChat("/do ВАЗ-2110 2004г. Цвет: черный металик.")
Sleep 2000
sendChat("/do Двигатель: 1.6L 16кл (87 л.с.), расход масла 300г/1000км.")
Sleep 2000
sendChat("/do Тюнинг: усилитель руля от 2112, китайская магнитола.")
Sleep 2000
sendChat("/do Тонировка: 5% вкруг. На лобовом стекле наклейка 4К.")
Sleep 2000
sendChat("/do На приборке: горит чек двигателя, спидометр залипает на 80 км/ч.")
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


:?:!упр::
SendInput, {Enter}
sendChat("/do У человека имеются при себе видео/аудио записывающие устройства?")
Sleep, 2000
sendChat("/b Ответ в /do: Да./Нет.")
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
addChatMessageEx(0, "{D1000C} AHK_FSB {155912}>{FFFFFF} Автор AHK - {94f8ff}Vladislav_Shetkov{FFFFFF}/{94f8ff}Vladislav_Valekus{FFFFFF}")
addChatMessageEx(0, "          ")
}
LABEL_EXIT:
ExitApp
Return
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

autocuff(acuff){
    cufffl := False
    addChatMessageEx(-1, "{94f8ff} AHK_FSB {176114}>{FFFFFF} Вы спасаете игрока {94f8ff}" acuff "{FFFFFF}. Нажмите клавишу {94f8ff}Y{FFFFFF}, чтобы надеть на него наручники после спасения")
    addChatMessageEx(-1, "{94f8ff} AHK_FSB {176114}>{FFFFFF} Нажмите клавишу {ff2428}N{FFFFFF}, чтобы отклонить предложение")
    startTime := A_TickCount
    endTime := startTime + 15000
    while A_TickCount < endTime {
        if GetKeyState("Y", "P") {
            cufffl := True
            sendchat("/id " acuff)
            Return
        } else if GetKeyState("N", "P") {
            cufffl := False
            addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {176114}>{FFFFFF} Отклонено!")
            Return
        }
    }
    addChatMessageEx(0x4169E1, "{94f8ff} AHK_FSB {176114}>{FFFFFF} Время принятия истекло")
    Return
}

ograb(ograba) {
    startTime := A_TickCount
    endTime := startTime + 10000
    while A_TickCount < endTime
    if GetKeyState("Y", "P")
    {
        sleep 100
        sendChat("/gps")
        sleep 200
        SendInput, {Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{enter}
        sleep 200
        SendInput,%ograba%{Enter}
        Return
    }
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


// Перезагрузка
!Numpad0::
sleep 50
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_FSB {155912}> {ffffff}Перезагрузка AHK")
reload
return