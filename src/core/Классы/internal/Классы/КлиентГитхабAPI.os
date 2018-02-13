#Использовать restler
#Использовать logos

Перем APIКлиент;
Перем НастройкаПрокси;
Перем Лог;

Перем URL Экспорт;
Перем ИмяРепозитория;
Перем ИмяПользователя;
Перем КонтекстВыполнения;
Перем Заголовки;

Перем Соединение;

Процедура ПриСозданииОбъекта()

	// Если НЕ ИмяГитРепозитория = Неопределено Тогда
	// 	ПрочитатьИмяГитРепозитория(Контекст.Репозиторий);
	// КонецЕсли;

	// Если НЕ ЗначениеЗаполнено(АдресСервера) Тогда
	АдресСервера = "https://api.github.com";
	// КонецЕсли;
	
	Соединение = Новый HTTPСоединение(АдресСервера);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("User-Agent", "Awesome-Octocat-App");
	
	APIКлиент = Новый КлиентВебAPI();
	APIКлиент.ИспользоватьСоединение(Соединение);
	APIКлиент.УстановитьЗаголовки(Заголовки);

КонецПроцедуры

Процедура УстановитьТокенАвторизации(Знач Токен) Экспорт
	
	Заголовки.Вставить("Authorization", "token " +Токен);

КонецПроцедуры

Процедура УстановитьРепозиторий(Знач ВходящееИмяПользователя, Знач ВходящееИмяРепозитория) Экспорт
	
	ИмяПользователя = ВходящееИмяПользователя;
	ИмяРепозитория = ВходящееИмяРепозитория;

КонецПроцедуры

Функция URLКлонирования() Экспорт
	Возврат СтрШаблон("https://github.com/%1/%2", ИмяПользователя, ИмяРепозитория);
КонецФункции

Функция API() Экспорт
	Возврат СтрШаблон("repos/%1/%2", ИмяПользователя, ИмяРепозитория);
КонецФункции

Функция Releases_API() Экспорт
	
	Возврат СтрШаблон("%1/releases", API());

КонецФункции

Функция СоздатьРелиз(Знач Тег, Знач Описание = "", Знач ИмяРелиза = "", Знач Черновик = Ложь, Знач Предварительный = Ложь) Экспорт

	СтруктураЗапроса = Новый Структура("tag_name, draft, prerelease", Тег, Черновик, Предварительный);

	Если ЗначениеЗаполнено(ИмяРелиза) Тогда
		СтруктураЗапроса.Вставить("name", ИмяРелиза);
	КонецЕсли;

	Если ЗначениеЗаполнено(Описание) Тогда
		СтруктураЗапроса.Вставить("body", Описание);
	КонецЕсли;

	АдресРесурса = Releases_API();

	ТелоЗапроса = ВJson(СтруктураЗапроса);

	Лог.Отладка("Адрес запроса: <%1/%2>", Соединение.Сервер, АдресРесурса);

	HTTPЗапрос = APIКлиент.ПолучитьHTTPЗапрос(АдресРесурса);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	HTTPЗапрос.Заголовки = Заголовки;

	HTTPОтвет = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	
	Если Не HTTPОтвет.КодСостояния = 201 Тогда
		Лог.КритичнаяОшибка("Создание релиза не удалось по причине <%1>", HTTPОтвет.ПолучитьТелоКакСтроку());
	КонецЕсли;

КонецФункции

Процедура ИзменитьРелиз(Знач ИдентификаторРелиза, Знач Тег, Знач Описание = "", Знач ИмяРелиза = "", Знач Черновик = Ложь, Знач Предварительный = Ложь) Экспорт

	СтруктураЗапроса = Новый Структура("tag_name, draft, prerelease", Тег, Черновик, Предварительный);

	Если ЗначениеЗаполнено(ИмяРелиза) Тогда
		СтруктураЗапроса.Вставить("name", ИмяРелиза);
	КонецЕсли;

	Если ЗначениеЗаполнено(Описание) Тогда
		СтруктураЗапроса.Вставить("body", Описание);
	КонецЕсли;

	АдресРесурса = Releases_API()+"/"+ИдентификаторРелиза;

	ТелоЗапроса = ВJson(СтруктураЗапроса);

	HTTPЗапрос = APIКлиент.ПолучитьHTTPЗапрос(АдресРесурса);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);

	HTTPОтвет = Соединение.Изменить(HTTPЗапрос);
	
	Если Не HTTPОтвет.КодСостояния = 200 Тогда
		Лог.КритичнаяОшибка("Изменение релиза не удалось по причине <%1>", HTTPОтвет.ПолучитьТелоКакСтроку());
	КонецЕсли;

КонецПроцедуры

Процедура ЗагрузитьФайлРелиза(Знач ИдентификаторРелиза, Знач ПутьКФайлу, Знач ИмяФайла = "") Экспорт
	
	ФайлЗагрузки = Новый Файл(ПутьКФайлу);

	Если Не ФайлЗагрузки.Существует() Тогда
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ИмяФайла) Тогда
		ИмяФайла = ФайлЗагрузки.Имя;
	КонецЕсли;

	АдресРесурса = СтрШаблон("%1/%2/asserts?name=%3", Releases_API(), ИдентификаторРелиза, ИмяФайла);

	Заголовки.Вставить("Content-Type", "application/zip");


	HTTPЗапрос = APIКлиент.ПолучитьHTTPЗапрос(АдресРесурса);
	HTTPЗапрос.УстановитьТелоИзДвоичныхДанных(Новый ДвоичныеДанные(ФайлЗагрузки.ПолноеИмя));

	HTTPОтвет = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	
	Если Не HTTPОтвет.КодСостояния = 200 Тогда
		Лог.КритичнаяОшибка("Загрузка файла <%1> в релиз <%2> не удалось по причине <%3>", ПутьКФайлу, ИдентификаторРелиза, HTTPОтвет.ПолучитьТелоКакСтроку());
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьРелизПоТегу(Знач Тег) Экспорт

	Лог.Отладка("Запрашиваю идентификатор релиза для тега <%1>", Тег);
	
	АдресРесурса = Releases_API()+"/tags/"+Тег;

	Лог.Отладка("Адрес запроса: <%1/%2>", Соединение.Сервер, АдресРесурса);

	HTTPЗапрос = APIКлиент.ПолучитьHTTPЗапрос(АдресРесурса);
	HTTPЗапрос.Заголовки = Заголовки;

	HTTPОтвет = Соединение.Получить(HTTPЗапрос);

	ТелоОтвета = HTTPОтвет.ПолучитьТелоКакСтроку();
	Если ТелоОтвета = Неопределено Тогда
		ТелоОтвета = "";
	КонецЕсли;

	//Лог.Отладка("Тело ответа <%1>", ТелоОтвета);

	Идентификатор = Неопределено;

	Если HTTPОтвет.КодСостояния = 200 Тогда
		Идентификатор = ИЗJson(ТелоОтвета)["id"];
	КонецЕсли;

	Возврат Идентификатор;

КонецФункции

Процедура УстановитьПрокси(Знач НоваяНастройкаПрокси) Экспорт
	НастройкаПрокси = НоваяНастройкаПрокси;
КонецПроцедуры

Процедура ПрочитатьИмяГитРепозитория(Знач ИмяГитРепозитория) 

	ИмяГитРепозитория = СтрЗаменить(ИмяГитРепозитория, "https://github.com/", "");
	ИмяГитРепозитория = СтрЗаменить(ИмяГитРепозитория, "http://github.com/", "");
	ИмяГитРепозитория = СтрЗаменить(ИмяГитРепозитория, "github.com/", "");

	Если СтрНайти(ИмяГитРепозитория, "@") > 0 Тогда
		
		МассивСтрок = СтрРазделить(ИмяГитРепозитория, "@");
		ИмяГитРепозитория = МассивСтрок[0];
		Тег = МассивСтрок[1];

	КонецЕсли;

	МассивСтрок = СтрРазделить(ИмяГитРепозитория, "/");
	ИмяПользователя = МассивСтрок[0];
	ИмяРепозитория = МассивСтрок[1];

КонецПроцедуры

Функция ВJson(Знач СтруктураЗапроса)
	
	ПарсерJSON = Новый ПарсерJSON;
	Возврат ПарсерJSON.ЗаписатьJSON(СтруктураЗапроса);

КонецФункции

Функция ИЗJson(ТелоОтвета)
	
	Парсер = Новый ПарсерJSON;
	Результат = Парсер.ПрочитатьJSON(ТелоОтвета);

	Возврат Результат;

КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.lib.orca.github.api");
Лог.УстановитьУровень(УровниЛога.Отладка);