#Использовать logos

Перем Лог;
Перем Настройки; // Структура
Перем Имя;
Перем ИмяНастройкиВФайле;
Перем ИндексПолей; // Соответствие ключа и типа элемента массива
Перем ИндексСинонимовПолей;
Перем ТекущееПоле; // Временно содержит имя текущего поля для его корректировки
Перем ИндексНастроек;

Процедура ПриСозданииОбъекта(Знач ИмяЭлемента, Знач ВходящийИндексНастроек)

	Имя = ИмяЭлемента;
	Настройки = Новый Структура;
	ИндексПолей = Новый Соответствие;
	ИндексСинонимовПолей = Новый Соответствие;
	ИндексНастроек = ВходящийИндексНастроек;

КонецПроцедуры

Функция ПолучитьИмя() Экспорт

	Возврат Имя;

КонецФункции

Функция ИмяВФайле(Знач ДополнительноеИмя)

	ИмяНастройкиВФайле = ДополнительноеИмя;
	Возврат ЭтотОбъект;

КонецФункции

Функция ОписаниеПоля(Знач ИмяПоля, Знач ТипПоля, Знач ТипЭлемента = Неопределено, Знач ИмяВложеннойНастройки = Неопределено)

	Описание = НовоеОписаниеПоля();
	Описание.Синонимы = СтрРазделить(ИмяПоля, " ", Ложь);
	Описание.Имя = Описание.Синонимы[0];
	Описание.Тип = ТипПоля;

	Если ТипЭлемента = Неопределено Тогда
		Если ТипПоля = Тип("Массив") Тогда
			ТипЭлемента = Тип("Строка");
		Иначе
			ТипЭлемента = ТипПоля;
		КонецЕсли;
	КонецЕсли;

	Описание.ТипЭлемента = ТипЭлемента;
	Описание.ИмяНастройки = ИмяВложеннойНастройки;
	Описание.ЭтоМассив = Тип("Массив") = ТипПоля;

	ДобавитьСинонимыВИндекс(Описание);

	Возврат Описание;

КонецФункции

Процедура ДобавитьСинонимыВИндекс(Знач СтруктураОписаниеПоля)

	ИмяПоля = СтруктураОписаниеПоля.Имя;

	Для каждого Синоним Из СтруктураОписаниеПоля.Синонимы Цикл
		Лог.Отладка("Добавляю в индекс синоним <%1> для поля <%2>", Синоним, ИмяПоля);
		ИндексСинонимовПолей.Вставить(Синоним, ИмяПоля);
	КонецЦикла;

КонецПроцедуры

Функция НовоеОписаниеПоля()
	Возврат Новый Структура("Имя, Тип, ТипЭлемента, ИмяНастройки, ЭтоМассив, Синонимы");
КонецФункции

Функция ПолучитьОписаниеПоля(Знач ИмяПоля)

	ИмяПоляВИндексе = ИндексСинонимовПолей[ИмяПоля];

	Лог.Отладка("Получение описание поля <%1> (<%2>)", ИмяПоляВИндексе, ИмяПоля);

	Если ИмяПоляВИндексе = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат ИндексПолей[ИмяПоляВИндексе];

КонецФункции

Функция ОписаниеТекущегоПоля()

	Возврат ПолучитьОписаниеПоля(ТекущееПоле);

КонецФункции

Функция СинонимПоля(Знач Синоним) Экспорт

	ОписаниеП = ОписаниеТекущегоПоля();

	ОписаниеП.Синонимы.Добавить(Синоним);

	Возврат ЭтотОбъект;

КонецФункции

Функция ИмяНастройкиПоля(Знач ИмяНастройки) Экспорт

	ОписаниеП = ОписаниеТекущегоПоля();

	ОписаниеП.ИмяНастройки = ИмяНастройки;

	Возврат ЭтотОбъект;

КонецФункции

Функция ТипПоля(Знач ВходящийТипПоля) Экспорт

	ОписаниеП = ОписаниеТекущегоПоля();

	ОписаниеП.Тип = ВходящийТипПоля;

	Возврат ЭтотОбъект;

КонецФункции

Функция Массив(Знач ТипЭлементаМассива) Экспорт

	ОписаниеП = ОписаниеТекущегоПоля();

	ОписаниеП.ЭтоМассив = Истина;
	ОписаниеП.Тип = Тип("Массив");
	ОписаниеП.ТипЭлемента = ТипЭлементаМассива;

	Возврат ЭтотОбъект;

КонецФункции

Функция ПолеМассив(Знач ИмяПоля, Знач ТипЭлемента, Знач ИмяВложеннойНастройки = "") Экспорт

	Лог.Отладка("Добавляю поле <%1> тип <%2> ТипЭлементов <%3>", ИмяПоля, Тип("Массив"), ТипЭлемента);
	Возврат Поле(ИмяПоля, Новый Массив, ТипЭлемента, ИмяВложеннойНастройки);

КонецФункции

Функция ПолеСтрока(Знач ИмяПоля, ЗначениеПоУмолчанию = "") Экспорт

	Возврат Поле(ИмяПоля, ЗначениеПоУмолчанию);

КонецФункции

Функция ПолеЧисло(Знач ИмяПоля, ЗначениеПоУмолчанию = 0) Экспорт

	Возврат Поле(ИмяПоля, ЗначениеПоУмолчанию);

КонецФункции

Функция ПолеБулево(Знач ИмяПоля, ЗначениеПоУмолчанию = Ложь) Экспорт

	Возврат Поле(ИмяПоля, ЗначениеПоУмолчанию);

КонецФункции

Функция ПолеОбъект(Знач ИмяПоля, Знач Объект) Экспорт

	Лог.Отладка("Добавляю поле объект <%1>, <%2>, <%3>", ИмяПоля, ТипЗнч(Объект), Объект.ПолучитьИмя());

	Возврат Поле(ИмяПоля, Объект, ТипЗнч(Объект), Объект.ПолучитьИмя());

КонецФункции

Функция Поле(Знач ИмяПоля, Знач ЗначениеПоУмолчанию = Неопределено, Знач ТипЭлемента = Неопределено, Знач ИмяВложеннойНастройки = "") Экспорт

	Если НЕ ЗначениеПоУмолчанию = Неопределено Тогда
		ТипПоля = ТипЗнч(ЗначениеПоУмолчанию);
	Иначе
		ТипПоля = Тип("Строка");
	КонецЕсли;

	ОписаниеНовогоПоля = ОписаниеПоля(ИмяПоля, ТипПоля, ТипЭлемента, ИмяВложеннойНастройки);

	ИндексПолей.Вставить(ОписаниеНовогоПоля.Имя, ОписаниеНовогоПоля);

	Настройки.Вставить(ОписаниеНовогоПоля.Имя, ЗначениеПоУмолчанию);

	ТекущееПоле = ОписаниеНовогоПоля.Имя;

	Возврат ЭтотОбъект;

КонецФункции

// Устанавливает класс приемник для выгрузки результата чтения параметров
//
// Параметры:
//   ИмяНастройки        - Строка - имя параметра
//                                  допустимо указание пути к параметру через точку (например, "config.server.protocol")
//   ЗначениеПоУмолчанию - Произвольный - возвращаемое значение в случае отсутствия параметра после чтения
//
// Возвращаемое значение:
//	Строка, Число, Булево, Массив, Соответствие - значение параметра
//
Функция Настройка(Знач ИмяНастройки, Знач ЗначениеПоУмолчанию = Неопределено) Экспорт

	ЗначениеИзИндекса = ЗначениеПоУмолчанию;

	Лог.Отладка("Получение значения настройки <%1>. Значение по умолчанию <%2>", ИмяНастройки, ЗначениеПоУмолчанию);
	Если Настройки.Свойство(ИмяНастройки, ЗначениеИзИндекса) Тогда
		Лог.Отладка(" --- получено значение <%1>", ЗначениеИзИндекса);
		Возврат ЗначениеИзИндекса;
	КонецЕсли;

	Возврат ЗначениеПоУмолчанию;

КонецФункции

Функция ВСтруктуру() Экспорт

	ИсходящаяСтруктура = Новый Структура;

	Для каждого КлючЗначение Из Настройки Цикл

		Значение = КлючЗначение.Значение;

		ЗначениеКлюча = ЗначениеВСтруктуру(Значение);

		ИсходящаяСтруктура.Вставить(КлючЗначение.Ключ, ЗначениеКлюча);

	КонецЦикла;

	Возврат ИсходящаяСтруктура;

КонецФункции

Функция ЗначениеВСтруктуру(Значение)

	ТипЗначения = ТипЗнч(Значение);

	Если ТипЗначения = Тип("Массив") Тогда

		МассивЗначений = Новый Массив;

		Для Каждого ЭлМассива Из Значение Цикл

			МассивЗначений.Добавить(ЗначениеВСтруктуру(ЭлМассива));

		КонецЦикла;

		Возврат МассивЗначений;

	ИначеЕсли ТипЗначения = Тип("ЭлементНастройки") Тогда

		Возврат Значение.ВСтруктуру();

	Иначе

		Возврат Значение;

	КонецЕсли;

КонецФункции

Функция ИзСоответствия(Знач ВходящиеСоответствие) Экспорт

	Лог.Отладка("Читаю настройки <%1>", Имя);

	ПрочитатьИзСоответствия(ВходящиеСоответствие);

	ПоказатьНастройкиВРежимеОтладки(Настройки);

	Возврат ЭтотОбъект;

КонецФункции

Процедура ПрочитатьИзСоответствия(Знач ВходящиеСоответствие)

	Для каждого КлючЗначение Из ВходящиеСоответствие Цикл

		ИмяКлюча = КлючЗначение.Ключ;
		Значение = КлючЗначение.Значение;
		Лог.Отладка("Загружаю поле <%1>, <%2>", ИмяКлюча, Значение);
		
		ОписаниеП = ПолучитьОписаниеПоля(ИмяКлюча);
				
		Если ОписаниеП = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		ЗначениеНастройки = ПреобразоватьЗначение(Значение, ОписаниеП);

		Настройки.Вставить(ОписаниеП.Имя, ЗначениеНастройки);

	КонецЦикла;

КонецПроцедуры

Функция ПреобразоватьЗначение(Значение, ОписаниеП, ТипЗначения = Неопределено)

	Если ТипЗначения = Неопределено Тогда

		ТипЗначения = ОписаниеП.Тип;

	КонецЕсли;
	
	Лог.Отладка("Тип значение <%1> = <%2>", ТипЗначения, ТипЗнч(Значение));

	Если ТипЗначения = Тип("Строка") Тогда

		Возврат Строка(Значение);

	ИначеЕсли ТипЗначения = Тип("Число") Тогда

		Возврат Число(Значение);

	ИначеЕсли ТипЗначения = Тип("Булево") Тогда

		Возврат Булево(Значение);

	ИначеЕсли ТипЗначения = Тип("Массив") Тогда

		Возврат ПреобразоватьМассив(Значение, ОписаниеП);

	ИначеЕсли ТипЗначения = Тип("ЭлементНастройки") Тогда

		ОбъектНастройка = ИндексНастроек[ОписаниеП.ИмяНастройки];

		Возврат ОбъектНастройка.ИзСоответствия(Значение);
	Иначе

		ВызватьИсключение СтрШаблон("Не правильный тип настройки поля <%1>", Строка(ТипЗначения));

	КонецЕсли;

КонецФункции

Функция ПреобразоватьМассив(ВходящийМассив, ОписаниеП)

	МассивЗначений = Новый Массив;
	ТипЭлементовМассива = ОписаниеП.ТипЭлемента;
	
	Лог.Отладка("Обрабатываю массив");
		
	Для каждого ЭлементМассива Из ВходящийМассив Цикл
		МассивЗначений.Добавить(ПреобразоватьЗначение(ЭлементМассива, ОписаниеП, ТипЭлементовМассива))

	КонецЦикла;

	Возврат МассивЗначений;

КонецФункции

Процедура ПоказатьНастройкиВРежимеОтладки(ЗначенияПараметров, Знач Родитель = "")
	
	Если Родитель = "" Тогда
		Лог.Отладка("	Тип параметров %1", ТипЗнч(ЗначенияПараметров));
	КонецЕсли;
	
	Если ЗначенияПараметров.Количество() = 0 Тогда
		Лог.Отладка("	Коллекция параметров пуста!");
	КонецЕсли;

	Если ЗначенияПараметров = Тип("Массив") Тогда
		
		Для ИИ=0 По ЗначенияПараметров.ВГраница() Цикл
			ПоказатьНастройкиВРежимеОтладки(ЗначенияПараметров[ИИ], СтрШаблон("%1.%2", Родитель, ИИ));
		КонецЦикла;
	
	ИначеЕсли ТипЗнч(ЗначенияПараметров) = Тип("Структура")
		ИЛИ ТипЗнч(ЗначенияПараметров) = Тип("Соответствие") Тогда
	
		Для каждого Элемент Из ЗначенияПараметров Цикл
	
			Если Не ПустаяСтрока(Родитель) Тогда
				ПредставлениеКлюча  = СтрШаблон("%1.%2", Родитель, Элемент.Ключ);
			Иначе
				ПредставлениеКлюча = Элемент.Ключ;
			КонецЕсли;
		
			Если ТипЗнч(Элемент.Значение) = Тип("ЭлементНастройки") Тогда
		
				ПоказатьНастройкиВРежимеОтладки(Элемент.Значение.ВСтруктуру(), ПредставлениеКлюча);
		
			ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("Структура") 
				ИЛИ ТипЗнч(Элемент.Значение) = Тип("Соответствие")  Тогда
		
				ПоказатьНастройкиВРежимеОтладки(Элемент.Значение, ПредставлениеКлюча);	

			Иначе
				Лог.Отладка("	параметр <%1> = <%2>", ПредставлениеКлюча, Элемент.Значение);
		
			КонецЕсли;
			
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.lib.orca.config");
Лог.УстановитьУровень(УровниЛога.Отладка);