#Использовать configor

Перем ИндексНастроек;
Перем ОсновнаяНастройка;

Функция НовоеПолеНастройки(Имя)
	
	НовыйЭлемент = Новый ЭлементНастройки(Имя, ИндексНастроек);
	ИндексНастроек.Вставить(Имя, НовыйЭлемент);
	Возврат НовыйЭлемент;

КонецФункции

Процедура ИнициализоватьСтруктуруНастроек()

	ИндексНастроек = Новый Соответствие;

	Обработчик = НовоеПолеНастройки("Обработчик")
				.ПолеСтрока("Перед pre")
				.ПолеСтрока("После post");

	НастройкаГитХаб = НовоеПолеНастройки("НастройкаГитХаб")
				.ПолеСтрока("СерверAPI api")
				.ПолеСтрока("АдресОтправки upload")
				.ПолеСтрока("АдресЗагрузки download")
				;

	НастройкаСборки = НовоеПолеНастройки("НастройкаСборки")
				.ПолеСтрока("ИмяПриложения binary")
				.ПолеМассив("ПеременныеОкружения env", Тип("Строка"))
				.ПолеМассив("Обработчик hooks", ТипЗнч(Обработчик), "Обработчик")
				.ПолеМассив("ЦельСборки targets", Тип("Строка"))
				.ПолеСтрока("Главная main")
				;

	НастройкаПерезаписиФорматаАрхива = НовоеПолеНастройки("НастройкаПерезаписиФорматаАрхива")
				.ПолеСтрока("ОС os")
				.ПолеСтрока("Формат format")
				;

	НастройкаАрхивирования = НовоеПолеНастройки("НастройкаАрхивирования")
				.ПолеСтрока("ШаблонИмениФайла name_template")
				.ПолеМассив("Замена replacements", Тип("Строка"))
				.ПолеСтрока("Формат format")
				.ПолеМассив("ПерезаписьФормата format_overrides", ТипЗнч(НастройкаПерезаписиФорматаАрхива), "НастройкаПерезаписиФорматаАрхива")
				.ПолеМассив("ДополнительныеФайлы files", Тип("Строка"))
				;
	
	НастройкаВыпускаГитхаба = НовоеПолеНастройки("НастройкаВыпускаГитхаба")
				.ПолеОбъект("НастройкаГитХаб github", НастройкаГитХаб)
				.ПолеБулево("Черновик draft")
				.ПолеБулево("Предварительный prerelease")
				.ПолеСтрока("ШаблонИмени name_template")
				;

	НастройкаFPM = НовоеПолеНастройки("НастройкаFPM")
				.ПолеСтрока("ШаблонИмени name_template")
				.ПолеМассив("Замены replacements", Тип("Строка"))
				.ПолеМассив("Форматы formats", Тип("Строка"))
				.ПолеМассив("Зависимости dependencies", Тип("Строка"))
				.ПолеМассив("Конфликты conflicts", Тип("Строка"))
				.ПолеСтрока("Поставщик vendor")
				.ПолеСтрока("ДомашняяСтраница homepage")
				.ПолеСтрока("Разработчик maintainer")
				.ПолеСтрока("Описание description")
				.ПолеСтрока("Лицензия license")
				.ПолеСтрока("КаталогЗапуска bindir")
				.ПолеМассив("Файлы files", Тип("Строка"))
				;

	НастройкаСнимка = НовоеПолеНастройки("НастройкаСнимка")
				.ПолеСтрока("ШаблонИмени name_template")
				;
	НастройкаРасчетаКонтрольныхСумм = НовоеПолеНастройки("НастройкаРасчетаКонтрольныхСумм")
				.ПолеСтрока("ШаблонИмени name_template")
				;

	НастройкаСборкиДокерФайла = НовоеПолеНастройки("НастройкаСборкиДокерФайла")
				.ПолеСтрока("Binary binary")
				.ПолеСтрока("ОС os")
				.ПолеСтрока("ИмяОбраза image")
				.ПолеСтрока("ИмяДокерФайла dockerfile")
				.ПолеБулево("Последний latest")
				.ПолеМассив("ШаблонИмениТегов tag_templates", Тип("Строка"))
				.ПолеМассив("ДополнительныеФайлы extra_files", Тип("Строка"))
				;

	НастройкаArtifactory = НовоеПолеНастройки("НастройкаArtifactory")
				.ПолеСтрока("Адрес target url")
				.ПолеСтрока("Имя name")
				.ПолеСтрока("ИмяПользователя username")
				.ПолеСтрока("Режим mode")
				;

	ФильтрИзменений = НовоеПолеНастройки("ФильтрОписанияИзменений")
				.ПолеМассив("Исключить exclude", Тип("Строка"))
				.ПолеМассив("Включить include", Тип("Строка"))
				;

	ОписаниеИзменений = НовоеПолеНастройки("ОписаниеИзменений")
				.ПолеСтрока("Сортировка sort")
				.ПолеМассив("ФильтрИсключение filters", ТипЗнч(ФильтрИзменений), "ФильтрИзменений")
				;
	
	ОсновнаяНастройка = НовоеПолеНастройки("Проект")
				.ПолеСтрока("ИмяПроекта project_name")
				.ПолеОбъект("НастройкаВыпускаГитхаба releases", НастройкаВыпускаГитхаба)
				.ПолеМассив("НастройкиСборки builds", ТипЗнч(НастройкаСборки), "НастройкаСборки")
				.ПолеОбъект("НастройкаАрхивирования archive", НастройкаАрхивирования)
				.ПолеОбъект("НастройкаFPM fpm", НастройкаFPM)
				.ПолеОбъект("НастройкаСнимка snapshot", НастройкаСнимка)
				.ПолеОбъект("НастройкаРасчетаКонтрольныхСумм checksum", НастройкаРасчетаКонтрольныхСумм)
				.ПолеМассив("НастройкиСборкиДокерФайлов dockers", ТипЗнч(НастройкаСборкиДокерФайла), "НастройкаСборкиДокерФайла")
				.ПолеМассив("НастройкиArtifactory artifactories", ТипЗнч(НастройкаArtifactory), "НастройкаArtifactory")
				.ПолеОбъект("ОписаниеИзменений changelog", ОписаниеИзменений)
				.ПолеСтрока("КаталогСборки dist")
				.ПолеОбъект("НастройкаСборки build", НастройкаСборки)
				.ПолеОбъект("НастройкаГитХаб gihub_urls", НастройкаГитХаб)
				;

КонецПроцедуры

Функция ВСтруктуру() Экспорт
	
	Возврат ОсновнаяНастройка.ВСтруктуру();

КонецФункции

Функция Настройка(Знач ИмяНастройки, Знач ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Возврат ОсновнаяНастройка.Настройка(ИмяНастройки, ЗначениеПоУмолчанию);

КонецФункции

Процедура ЗагрузитьИзФайла(Знач ПутьКФайлу) Экспорт
	
	ЧтенияФайлаYAML = Новый ЧтениеНастроекYAML;
	РезультатЧтения = ЧтенияФайлаYAML.Прочитать(ПутьКФайлу);
	
	ОсновнаяНастройка.ИзСоответствия(РезультатЧтения);

КонецПроцедуры

ИнициализоватьСтруктуруНастроек();