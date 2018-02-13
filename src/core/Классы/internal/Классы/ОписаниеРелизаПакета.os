#Использовать gitrunner
#использовать logos

Перем Лог;

Процедура Запустить(Контекст) Экспорт

	Если НЕ ПустаяСтрока(Контекст.ОписаниеВыпуска) Тогда
		Возврат;
	КонецЕсли;

	Если Контекст.ЭтоСнимок Тогда
		Возврат;
	КонецЕсли;

	ОписаниеИзменений = Контекст.Настройка.ОписаниеИзменений;

	Если НЕ ПроверитьСортировку(ОписаниеИзменений.Сортировка) Тогда
		Возврат;
	КонецЕсли; 

	НаборИзменений = ПолучитьИзмененияИзГитЛога(Контекст);

	ЗаголовокОписаниеВыпуска = "## Описание изменений" + Символы.ПС + Символы.ПС;
	ОписаниеВыпуска = СтрШаблон("%1%2", ЗаголовокОписаниеВыпуска, СтрСоединить(НаборИзменений, Символы.ПС));
	Лог.Отладка("<%1>", ОписаниеВыпуска);
	Контекст.ОписаниеВыпуска = ОписаниеВыпуска;

КонецПроцедуры

Функция ПолучитьИзмененияИзГитЛога(Контекст)
	
	ГитРепозиторий = Новый ГитРепозиторий();
	ГитРепозиторий.УстановитьТихийРежимРаботы();
	ГитРепозиторий.УстановитьРабочийКаталог(Контекст.РабочийКаталог);
	Лог.Отладка("Установлен рабочий каталог гит <%1>", Контекст.РабочийКаталог);

	ОписаниеТега = ПредыдущийТег(ГитРепозиторий, Контекст.ГитИнформация.Тег);
	
	СтрокаПараметровЗапуска = "log --pretty=oneline --abbrev-commit --no-decorate";
	ПараметрыЗапуска = СтрРазделить(СтрокаПараметровЗапуска, " ");

	ПараметрыЗапуска.Добавить(СтрШаблон("%1..%2", ОписаниеТега.SHA, Контекст.ГитИнформация.Тег));

	ГитРепозиторий.ВыполнитьКоманду(ПараметрыЗапуска);
	
	ТекстИстории = ГитРепозиторий.ПолучитьВыводКоманды();
	
	МассивВерсий = СтрРазделить(ТекстИстории, Символы.ПС);
	
	Если МассивВерсий.Количество() = 0 Тогда
		Возврат МассивВерсий;
	КонецЕсли;

	// Удаление последний строки версии
	МассивВерсий.Удалить(МассивВерсий.ВГраница());

	ФильтрованныйМассив = ПрименитьФильтры(МассивВерсий, Контекст);
	СортированныйМассив = СортироватьМассив(МассивВерсий, Контекст);

	Возврат СортированныйМассив;

КонецФункции

Функция ПрименитьФильтры(МассивВерсий, Контекст)
	
	ФильтрованныйМассив = Новый Массив;

	Если МассивВерсий.Количество() = 0 Тогда
		Возврат ФильтрованныйМассив;
	КонецЕсли;

	НаборФильтровВключения = Контекст.Настройка.ОписаниеИзменений.Фильтры.Включить;
	НаборФильтровИсключить = Контекст.Настройка.ОписаниеИзменений.Фильтры.Исключить;
	
	Лог.Отладка("Количество фильтров включить <%1>", НаборФильтровВключения.Количество());
	Лог.Отладка("Количество фильтров исключить <%1>", НаборФильтровИсключить.Количество());
	
	ПрименитьНаборФильтра(ФильтрованныйМассив, МассивВерсий, НаборФильтровВключения, Истина);
	ПрименитьНаборФильтра(ФильтрованныйМассив, МассивВерсий, НаборФильтровИсключить, Ложь);
	
	Возврат ФильтрованныйМассив;

КонецФункции

Процедура ПрименитьНаборФильтра(ФильтрованныйМассив, МассивВерсий, НаборФильтра, НаправлениеСовпадения = Истина)
	
	Для каждого Фильтр Из НаборФильтра Цикл
		
		РегулярноеВыражение = Новый РегулярноеВыражение(Фильтр);

		Для каждого СтрокаМассив Из МассивВерсий Цикл
			
			ОписаниеСтроки = СтрРазделить(СтрокаМассив, " ")[1];

			Если НаправлениеСовпадения 
				И РегулярноеВыражение.Совпадает(ОписаниеСтроки) Тогда
				ФильтрованныйМассив.Добавить(СтрокаМассив);
			ИначеЕсли НЕ НаправлениеСовпадения 
				И НЕ РегулярноеВыражение.Совпадает(ОписаниеСтроки) Тогда
				ФильтрованныйМассив.Добавить(СтрокаМассив);
			КонецЕсли;
			
		КонецЦикла;

	КонецЦикла;

КонецПроцедуры

Функция СортироватьМассив(МассивВерсий, Контекст)
	
	СортированныйМассив = Новый Массив;
	
	Если МассивВерсий.Количество() = 0 Тогда
		Возврат СортированныйМассив;
	КонецЕсли;
	// TODO: Сделать обратную сортировку массива

	СортированныйМассив = МассивВерсий;

	Возврат СортированныйМассив;

КонецФункции

Функция ПредыдущийТег(ГитРепозиторий, Тег)
	
	ОписаниеТега = Новый Структура("ЭтоТег, SHA", Истина, "");

	ПараметрыЗапуска = СтрРазделить("describe --tags --abbrev=0", " ");
	ГитРепозиторий.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Если ГитРепозиторий.ПолучитьКодВозврата() = 0 Тогда
		ОписаниеТега.SHA = ГитРепозиторий.ПолучитьВыводКоманды();
	Иначе
		ПараметрыЗапуска = СтрРазделить("rev-list --max-parents=0 HEAD", " ");
		ГитРепозиторий.ВыполнитьКоманду(ПараметрыЗапуска);
		ОписаниеТега.ЭтоТег = Ложь;
		ОписаниеТега.SHA = ГитРепозиторий.ПолучитьВыводКоманды();
	
	КонецЕсли;
	
	Возврат ОписаниеТега;

КонецФункции


Функция ПроверитьСортировку(Знач ИмяСортировки)
	// TODO: Проверка сортировки на адекватость ввода
	Возврат Истина;
КонецФункции

Процедура УстановитьНастройкиПоУмолчанию(Контекст) Экспорт

	
КонецПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.lib.orca.pipe.changelog");
Лог.УстановитьУровень(УровниЛога.Отладка);
