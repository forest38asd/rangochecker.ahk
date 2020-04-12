if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
   ExitApp
}

;=================================================
;====================== INFO =====================
;=================================================
; Создатель - Bogdan_Forest
current_version = 0.1.1
;=================================================



;=================================================
;================ UPDATE CHECKER =================
;=================================================

UrlDownloadToFile, https://raw.githubusercontent.com/forest38asd/rangochecker.ahk/master/version.txt, new_version.txt
FileReadLine, new_version, new_version.txt, 1
FileDelete, new_version.txt

if current_version != new_version
{
	UrlDownloadToFile, https://raw.githubusercontent.com/forest38asd/rangochecker.ahk/master/changelog/%new_version%.txt, changes.txt
	FileRead, changes, changes.txt
	FileDelete, changes.txt
	
	MsgBox, 4, Обновление скрипта, Список изменений:`n`n %changes%
	
	IfMsgBox, Yes
	{
		new_file_name = %A_ScriptName%%new_version%.ahk
		UrlDownloadToFile, https://raw.githubusercontent.com/forest38asd/rangochecker.ahk/master/rangochecker`%20v%new_version%.ahk, %new_file_name%
		while not FileExist(new_file_name)
		{
			MsgBox, Не создался
			sleep 2000
		}
		FileDelete, %A_ScriptName%
		Run, %new_file_name%
		FileMove, %new_file_name%, %A_ScriptName%
		exit
	}
}

;=================================================


#Include SAMP.ahk

;=================================================
;================ GOOGLE CHECKER =================
;=================================================

!y::
	povyshkaDoRang = 0
	povyshkaNextDate = 0
	showDialog("1", "Чекер повышений", "Введите id или ник игрока", "Ок")
	Input, check, V, {enter}
	
	UrlDownloadToFile, https://docs.google.com/spreadsheets/d/e/2PACX-1vSClmbHtT6YKwynp2gO6OmTbQdfmcZrbSm2VM_K7t8ZCOmCeStDx_dfdkuvBMAkpTSMBt5fN35r2ti2/pubhtml?gid=2101403455&single=true, sroki.csv
	FileRead, file, sroki.csv
	if RegExMatch(check, "[0-9]+")
	{
		NickName := getPlayerNameById(check)
	}
	else
	{
		NickName := check
	}
	
	poisk = %NickName%</[a-z]+><[a-z ="4]+>[0-9]</td><[a-z ="4]+>([0-9])</td><[a-z ="4]+>[0-9.]+</td><[a-z ="5678]+>([0-9.]+)</td>
	
	p = 1
	Loop
	{
		p := RegExMatch(file, poisk, result, p+StrLen(result))
		if p = 0
			break
		povyshkaDoRang := result1 + 1
		povyshkaNextDate := result2
	}
	
	if povyshkaNextDate
	{
		Addchatmessage("{BFBFBF}[Чекер повышений]{FFFFFF} " NickName "{BFBFBF}: Следующее повышение: {FFFFFF}" povyshkaNextDate "{BFBFBF}. Повысить до {FFFFFF}" povyshkaDoRang "{BFBFBF} ранга.")
	}
	else
	{
		Addchatmessage("{BFBFBF}Игрок с ником {FFFFFF}" NickName "{BFBFBF} не найден в логах")
	}
	
	FileDelete, sroki.csv
	return