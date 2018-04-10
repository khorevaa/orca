Процедура Запустить(Контекст) Экспорт
	





КонецПроцедуры

Процедура УстановитьНастройкиПоУмолчанию(Контекст) Экспорт
	
	НастройкиСборки = Контекст.Настройка.НастройкиСборки;

	Если НастройкиСборки.Количество() = 0 Тогда
		
		НастройкиСборки.Добавить(Контекст, Контекст.Настройка.НастройкаСборки);

	Иначе


	КонецЕсли;
	

КонецПроцедуры

Функция НастройкаСборкиПоУмолчанию(Контекст, НастройкаСборки)
	
	Если ПустаяСтрока(НастройкаСборки.ИмяПриложения) Тогда
		
		НастройкаСборки.ИмяПриложения = ""; // TODO: Сделать чтение из packagedef
		
	КонецЕсли;

	Возврат НастройкаСборки;

КонецФункции


Процедура ВыполнитьОбработчик(Контекст, Обработчик, ДопПеременныеСреды)
	
	Если Обработчик.Скрипт.Количество() = 0  Тогда
		Возврат;
	КонецЕсли;

	КомандныйФайл = Новый КомандныйФайл();
		
	Для каждого СтрокаСкрипта Из Обработчик.Скрипт Цикл

		КомандныйФайл.ДобавитьКоманду();

	КонецЦикла;
	
	КомандныйФайл.Исполнить();

КонецПроцедуры