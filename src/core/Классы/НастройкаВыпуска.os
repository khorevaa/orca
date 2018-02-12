type GitHubURLs struct {
	API      string `yaml:"api,omitempty"`
	Upload   string `yaml:"upload,omitempty"`
	Download string `yaml:"download,omitempty"`
}


// String of the repo, e.g. owner/name
func (r Repo) String() string {
	if r.Owner == "" && r.Name == "" {
		return ""
	}
	return r.Owner + "/" + r.Name
}


authorCommit = Новый Структура("name, email");

hooks = Новый Структура("pre, post");

repo = Новый Структура("Owner, Name");

GitHubURLs = Новый Структура("api, upload, download");

build = Новый Структура("
	|env,
	|hooks,
	|targets,
	|binary,
	|main");

archive = Новый Структура("
	|name_template,
	|replacements,
	|format,
	|format_overrides,
	|wrap_in_directory,
	|files");

release = Новый Структура("
	|GitHub,
	|Draft,
	|Prerelease,
	|name_template
	|");

fpm = Новый Структура("
	|name_template,
	|Replacements,
	|Formats,
	|Dependencies,
	|Conflicts,
	|Vendor,
	|Homepage,
	|Maintainer,
	|Description,
	|License,
	|Bindir,
	|Files,
	|");

Функция НовыйПроект()
	Ключи = "project_name release builds
			| archive fpm snapcraft snapshot
			| checksum dockers artifactories
			| changelog dist sing envfiles";


	

КонецФункции

Функция НовыйБилд(Знач main = "", Знач env = Неопределено, Знач hooks = Неопределено, Знач targets = Неопределено, Знач binary = "")
	
	Ключи = "main env hooks targets binary";

	Если env = Неопределено Тогда
		env  = Новый Массив;
	КонецЕсли;

	Если hooks = Неопределено Тогда
		hooks  = НовыйHooks();
	КонецЕсли;

	Если targets = Неопределено Тогда
		targets  = Новый Массив;
	КонецЕсли;

	Возврат НоваяСтруктура(Ключи, main, env, targets, binary);

КонецФункции


Функция НоваяСтруктура(КлючиСтруктуры,
						ЗначениеКлюча1 = Неопределено,
						ЗначениеКлюча2 = Неопределено,
						ЗначениеКлюча3 = Неопределено,
						ЗначениеКлюча4 = Неопределено,
						ЗначениеКлюча5 = Неопределено,
						ЗначениеКлюча6 = Неопределено,
						ЗначениеКлюча7 = Неопределено,
						ЗначениеКлюча8 = Неопределено,
						ЗначениеКлюча9 = Неопределено,
						)

	
	МассивКлючей = СтрРазделить(КлючиСтруктуры, " ", Ложь);

	Если МассивКлючей.Количество() = 0 Тогда
		Возврат Новый Структура();
	КонецЕсли;

	МассивЗначений = Новый Массив();
	МассивЗначений.Добавить(ЗначениеКлюча1);
	МассивЗначений.Добавить(ЗначениеКлюча2);
	МассивЗначений.Добавить(ЗначениеКлюча3);
	МассивЗначений.Добавить(ЗначениеКлюча4);
	МассивЗначений.Добавить(ЗначениеКлюча5);
	МассивЗначений.Добавить(ЗначениеКлюча6);
	МассивЗначений.Добавить(ЗначениеКлюча7);
	МассивЗначений.Добавить(ЗначениеКлюча8);
	МассивЗначений.Добавить(ЗначениеКлюча9);

	СтруктураВозврата = Новый Структура;
	Для ИИ = 0 По МассивКлючей.ВГраница() Цикл
		СтруктураВозврата.Вставить(МассивКлючей[ИИ], МассивЗначений[ИИ]);
	КонецЦикла;
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Sign config
type Sign struct {
	Cmd       string   `yaml:"cmd,omitempty"`
	Args      []string `yaml:"args,omitempty"`
	Signature string   `yaml:"signature,omitempty"`
	Artifacts string   `yaml:"artifacts,omitempty"`
}

// SnapcraftAppMetadata for the binaries that will be in the snap package
type SnapcraftAppMetadata struct {
	Plugs  []string
	Daemon string
}

// Snapcraft config
type Snapcraft struct {
	NameTemplate string            `yaml:"name_template,omitempty"`
	Replacements map[string]string `yaml:",omitempty"`

	Name        string                          `yaml:",omitempty"`
	Summary     string                          `yaml:",omitempty"`
	Description string                          `yaml:",omitempty"`
	Grade       string                          `yaml:",omitempty"`
	Confinement string                          `yaml:",omitempty"`
	Apps        map[string]SnapcraftAppMetadata `yaml:",omitempty"`
}

// Snapshot config
type Snapshot struct {
	NameTemplate string `yaml:"name_template,omitempty"`
}

// Checksum config
type Checksum struct {
	NameTemplate string `yaml:"name_template,omitempty"`
}

// Docker image config
type Docker struct {
	Binary         string   `yaml:",omitempty"`
	Goos           string   `yaml:",omitempty"`
	Goarch         string   `yaml:",omitempty"`
	Goarm          string   `yaml:",omitempty"`
	Image          string   `yaml:",omitempty"`
	Dockerfile     string   `yaml:",omitempty"`
	Latest         bool     `yaml:",omitempty"`
	OldTagTemplate string   `yaml:"tag_template,omitempty"`
	TagTemplates   []string `yaml:"tag_templates,omitempty"`
	Files          []string `yaml:"extra_files,omitempty"`
}

// Artifactory server configuration
type Artifactory struct {
	Target   string `yaml:",omitempty"`
	Name     string `yaml:",omitempty"`
	Username string `yaml:",omitempty"`
	Mode     string `yaml:",omitempty"`
}

// Filters config
type Filters struct {
	Exclude []string `yaml:",omitempty"`
}

// Changelog Config
type Changelog struct {
	Filters Filters `yaml:",omitempty"`
	Sort    string  `yaml:",omitempty"`
}

// EnvFiles holds paths to files that contains environment variables
// values like the github token for example
type EnvFiles struct {
	GitHubToken string `yaml:"github_token,omitempty"`
}


Project = Новый Структура


// Project includes all project configuration
type Project struct {
	ProjectName   string        `yaml:"project_name,omitempty"`
	Release       Release       `yaml:",omitempty"`
	Brew          Homebrew      `yaml:",omitempty"`
	Builds        []Build       `yaml:",omitempty"`
	Archive       Archive       `yaml:",omitempty"`
	FPM           FPM           `yaml:",omitempty"`
	Snapcraft     Snapcraft     `yaml:",omitempty"`
	Snapshot      Snapshot      `yaml:",omitempty"`
	Checksum      Checksum      `yaml:",omitempty"`
	Dockers       []Docker      `yaml:",omitempty"`
	Artifactories []Artifactory `yaml:",omitempty"`
	Changelog     Changelog     `yaml:",omitempty"`
	Dist          string        `yaml:",omitempty"`
	Sign          Sign          `yaml:",omitempty"`
	EnvFiles      EnvFiles      `yaml:"env_files,omitempty"`

	// this is a hack ¯\_(ツ)_/¯
	SingleBuild Build `yaml:"build,omitempty"`

	// should be set if using github enterprise
	GitHubURLs GitHubURLs `yaml:"github_urls,omitempty"`
}

// Load config file
func Load(file string) (config Project, err error) {
	f, err := os.Open(file)
	if err != nil {
		return
	}
	log.WithField("file", file).Info("loading config file")
	return LoadReader(f)
}

// LoadReader config via io.Reader
func LoadReader(fd io.Reader) (config Project, err error) {
	data, err := ioutil.ReadAll(fd)
	if err != nil {
		return config, err
	}
	err = yaml.UnmarshalStrict(data, &config)
	log.WithField("config", config).Debug("loaded config file")
	return config, err
}