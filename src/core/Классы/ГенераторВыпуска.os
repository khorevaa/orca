#Использовать "internal"

// defaults.Pipe{},        // load default configs
// dist.Pipe{},            // ensure ./dist is clean
// git.Pipe{},             // get and validate git repo state
// effectiveconfig.Pipe{}, // writes the actual config (with defaults et al set) to dist
// changelog.Pipe{},       // builds the release changelog
// env.Pipe{},             // load and validate environment variables
// build.Pipe{},           // build
// archive.Pipe{},         // archive (tar.gz, zip, etc)
// fpm.Pipe{},             // archive via fpm (deb, rpm, etc)
// snapcraft.Pipe{},       // archive via snapcraft (snap)
// checksums.Pipe{},       // checksums of the files
// sign.Pipe{},            // sign artifacts
// docker.Pipe{},          // create and push docker images
// artifactory.Pipe{},     // push to artifactory
// release.Pipe{},         // release to github
// brew.Pipe{}, 		   // push to brew tap

Процедура Выпустить(Знач ПутьКФайлуИлиКаталогу)

    ПутьКФайлуНастройки = ПолучитьФайлНастроек(ПутьКФайлуИлиКаталогу);

    Если ПутьКФайлуНастройки = Неопределено Тогда
        Возврат;
    КонецЕсли;

    НастройкаВыпуска = Новый НастройкаВыпуска();
    НастройкаВыпуска.ПрочитатьФайл(ПутьКФайлуНастройки);

    Контекст = Новый КонтекстВыпуска(НастройкаВыпуска);

    ВыполнитьСборкиВыпуска(Контекст);
    
КонецПроцедуры

Процедура ВыполнитьСборкиВыпуска(Знач Контекст)

    МассивСборки = ПолучитьЭлементыСборки();
    
    Для Каждого ЭлементСборки Из МассивСборки Цикл

        ЭлементСборки.Запустить(Контекст);

    КонецЦикла

КонецПроцедуры


Функция ПолучитьФайлНастроек(Знач ПутьКФайлуИлиКаталогу)

    ФайлНастройки = Новый Файл(ПутьКФайлуИлиКаталогу);

    Если ФайлНастройки.Существует() 
        И НЕ ФайлНастройки.Каталог() Тогда
        Возврат ФайлНастройки.ПолноеИмя;
    КонецЕсли;

    ВозможныеИмена = ИменаФайловПоУмолчанию();

    Для каждого ИмяФайла Из ВозможныеИмена Цикл
        
        ФайлНастройки = Новый Файл(ОбъединитьПути(ПутьКФайлуИлиКаталогу, ИмяФайла));

        Если ФайлНастройки.Существует() Тогда
            Возврат ФайлНастройки.ПолноеИмя;
        КонецЕсли;

    КонецЦикла;

    Возврат Неопределено;
    
КонецФункции

Функция ПолучитьЭлементыСборки()
    
    МассивЭлементовСборки = Новый Массив;
    МассивЭлементовСборки.Добавить(Новый НачальныйЗагрузчик);
    МассивЭлементовСборки.Добавить(Новый ГитИнформация);
    МассивЭлементовСборки.Добавить(Новый ОписаниеРелизаПакета);
    МассивЭлементовСборки.Добавить(Новый ПеременныеОкруженияСборки);
    МассивЭлементовСборки.Добавить(Новый СборкаПакета);
    МассивЭлементовСборки.Добавить(Новый АрхивированиеПакета);
    МассивЭлементовСборки.Добавить(Новый СборкаFPM);
    МассивЭлементовСборки.Добавить(Новый СборкаSnapcraft);
    МассивЭлементовСборки.Добавить(Новый КонтрольныеСуммыФайлов);
    МассивЭлементовСборки.Добавить(Новый ЦифроваяПодпись);
    МассивЭлементовСборки.Добавить(Новый ОтправкаВХабПакетов);
    МассивЭлементовСборки.Добавить(Новый ОтправкаВРелизыГитХаба);
    МассивЭлементовСборки.Добавить(Новый ОтправкаВArtifactory);


// defaults.Pipe{},        // load default configs
// dist.Pipe{},            // ensure ./dist is clean
// git.Pipe{},             // get and validate git repo state
// effectiveconfig.Pipe{}, // writes the actual config (with defaults et al set) to dist
// changelog.Pipe{},       // builds the release changelog
// env.Pipe{},             // load and validate environment variables
// build.Pipe{},           // build
// archive.Pipe{},         // archive (tar.gz, zip, etc)
// fpm.Pipe{},             // archive via fpm (deb, rpm, etc)
// snapcraft.Pipe{},       // archive via snapcraft (snap)
// checksums.Pipe{},       // checksums of the files
// sign.Pipe{},            // sign artifacts
// docker.Pipe{},          // create and push docker images
// artifactory.Pipe{},     // push to artifactory
// release.Pipe{},         // release to github
// brew.Pipe{}, 		   // push to brew tap



    Возврат МассивЭлементовСборки;

КонецФункции


Функция ИменаФайловПоУмолчанию()
    
    МассивИмен = Новый Массив;
    МассивИмен.Добавить(".orca.yaml");
    МассивИмен.Добавить(".orca.yml");
    МассивИмен.Добавить("orca.yaml");
    МассивИмен.Добавить("orca.yml");
  
    МассивИмен.Добавить(".osreleaser.yaml");
    МассивИмен.Добавить(".osreleaser.yml");
    МассивИмен.Добавить("osreleaser.yaml");
    МассивИмен.Добавить("osreleaser.yml");

    Возврат МассивИмен;

КонецФункции