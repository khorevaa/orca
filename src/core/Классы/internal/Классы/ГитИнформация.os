#Использовать gitrunner

Процедура Запустить(Контекст) Экспорт
	
	ОписаниеГит = ПолучитьОписаниеГит(Контекст);

	Тег = ОписаниеГит.Тег;
	Коммит = ОписаниеГит.Коммит;

	Если ПустаяСтрока(Тег)
		И НЕ Контекст.Снапшот Тогда
		Возврат;
	КонецЕсли;

	Контекст.ОписаниеГит = ОписаниеГит;

	УстановитьВерсию(Контекст, Тег, Коммит);

	Если Контекст.ПроверкаВерсии Тогда
		ПроверитьВерсию(Контекст, Тег, Коммит);
	КонецЕсли;

КонецПроцедуры	
	
Процедура УстановитьВерсию(Контекст, Знач Тег, Знач Коммит)
	
	Если Контекст.Снапшот Тогда
		Контекст.Версия = ПолучитьИмяСпаншота(Контекст, Тег, Коммит);
	Иначе
		Контекст.Версия = Тег; // Сделать обрезку v
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьВерсию(Контекст, Знач Тег, Знач Коммит)
	
КонецПроцедуры

Функция ПолучитьОписаниеГит(Контекст)
	
	ОписаниеГит =  Новый Структура("Тег, Коммит", "", "");

	ГитРепозиторий = Новый ГитРепозиторий();
	ГитРепозиторий.УстановитьРабочийКаталог(Контекст.РабочийКаталог);
	Если НЕ ГитРепозиторий.ЭтоРепозиторий() Тогда
		Возврат ОписаниеГит;
	КонецЕсли;

	ПараметрыЗапуска = СтрРазделить("describe --tags --abbrev=0", " ");
	ГитРепозиторий.ВыполнитьКоманду(ПараметрыЗапуска);

	ОписаниеГит.Тег = ГитРепозиторий.ПолучитьВыводКоманды();

	ПараметрыЗапуска = СтрРазделить("show --format='%H' HEAD", " ");
	
	ГитРепозиторий.ВыполнитьКоманду(ПараметрыЗапуска);

	ОписаниеГит.Коммит = ГитРепозиторий.ПолучитьВыводКоманды();

	Возврат ОписаниеГит;

КонецФункции

Функция ПолучитьИмяСпаншота(Контекст, Знач Тег, Знач Коммит)
	
КонецФункции