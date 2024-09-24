//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2024 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область СлужебныйПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт
	
	ЮТТесты.УдалениеТестовыхДанных()
		.ДобавитьТест("ЗначенияРеквизитов")
		.ДобавитьТест("ЗначениеРеквизита")
		.ДобавитьТест("ТаблицаСодержитЗаписи")
		.ДобавитьТест("РезультатЗапроса")
		.ДобавитьТест("РезультатПустой")
		.ДобавитьТест("Запись")
		.ДобавитьТест("Записи")
		.ДобавитьТест("Запись_Субконто")
		.ДобавитьТест("Записи_Субконто")
		.ДобавитьТест("ЗначенияРеквизитовЗаписи")
		.ДобавитьТест("ЗначениеРеквизитаЗаписи")
		.ДобавитьТест("ДвиженияДокумента")
		.ДобавитьТест("Записи_Условие_ВСписке")
		.ДобавитьТест("Записи_Условие_Между")
	;
	
КонецПроцедуры

Процедура ЗначенияРеквизитов() Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Штрихкод")
		.Фикция("Поставщик");
	Данные = Конструктор.ДанныеОбъекта();
	Ссылка = Конструктор.Записать();
	
	ДанныеСсылки = ЮТЗапросы.ЗначенияРеквизитов(Ссылка, "Наименование");
	ЮТест.ОжидаетЧто(ДанныеСсылки)
		.ИмеетТип("Структура")
		.Заполнено()
		.Свойство("Наименование").Равно(Данные.Наименование);
	
	ДанныеСсылки = ЮТЗапросы.ЗначенияРеквизитов(Ссылка, "Штрихкод, Поставщик");
	ЮТест.ОжидаетЧто(ДанныеСсылки)
		.ИмеетТип("Структура")
		.Заполнено()
		.Свойство("Штрихкод").Равно(Данные.Штрихкод)
		.Свойство("Поставщик").Равно(Данные.Поставщик);
	
	ДанныеСсылки = ЮТЗапросы.ЗначенияРеквизитов(ПредопределенноеЗначение("Справочник.Товары.ПустаяСсылка"), "Код, Поставщик");
	ЮТест.ОжидаетЧто(ДанныеСсылки)
		.ИмеетТип("Структура")
		.Заполнено()
		.Свойство("Код").Равно(Неопределено)
		.Свойство("Поставщик").Равно(Неопределено);
	
КонецПроцедуры

Процедура ЗначениеРеквизита() Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Поставщик");
	Данные = Конструктор.ДанныеОбъекта();
	Ссылка = Конструктор.Записать();
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.ЗначениеРеквизита(Ссылка, "Наименование"))
		.ИмеетТип("Строка")
		.Заполнено()
		.Равно(Данные.Наименование);
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.ЗначениеРеквизита(Ссылка, "Поставщик"))
		.Равно(Данные.Поставщик);
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.ЗначениеРеквизита(Ссылка, "Наименование, Поставщик"))
		.Равно(Данные.Наименование);
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.ЗначениеРеквизита(ПредопределенноеЗначение("Справочник.Товары.ПустаяСсылка"), "Наименование"))
		.Равно(Неопределено);
	
КонецПроцедуры

Процедура ТаблицаСодержитЗаписи() Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Поставщик");
	Конструктор.Записать();
	ДанныеСправочника = Конструктор.ДанныеОбъекта();
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.ТаблицаСодержитЗаписи("Справочник.Товары")).ЭтоИстина();
	ЮТест.ОжидаетЧто(ЮТЗапросы.ТаблицаСодержитЗаписи("Справочник.МобильныеУстройства")).ЭтоЛожь();
	
	ЮТест.ОжидаетЧто(
		ЮТЗапросы.ТаблицаСодержитЗаписи("Справочник.Товары",
			ЮТест.Предикат()
				.Реквизит("Наименование").Равно(ДанныеСправочника.Наименование)))
		.ЭтоИстина();
	
	ЮТест.ОжидаетЧто(
		ЮТЗапросы.ТаблицаСодержитЗаписи("Справочник.Товары",
			ЮТест.Предикат()
				.Реквизит("Наименование").Равно(1)))
		.ЭтоЛожь();
	
КонецПроцедуры

Процедура РезультатЗапроса() Экспорт
	
	Товар = НовыйТовар();
	
	ОписаниеЗапроса = ЮТЗапросы.ОписаниеЗапроса();
	ОписаниеЗапроса.ИмяТаблицы = "Справочник.Товары";
	ОписаниеЗапроса.Условия.Добавить("Ссылка = &Ссылка");
	ОписаниеЗапроса.Условия.Добавить("НЕ ПометкаУдаления");
	ОписаниеЗапроса.ЗначенияПараметров.Вставить("Ссылка", Товар);
	ОписаниеЗапроса.ВыбираемыеПоля.Добавить("Ссылка");
	ОписаниеЗапроса.ВыбираемыеПоля.Добавить("1+1 КАК Число");
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.РезультатЗапроса(ОписаниеЗапроса))
		.ИмеетДлину(1)
		.Свойство("[0].Ссылка").Равно(Товар)
		.Свойство("[0].Число").Равно(2);
	
КонецПроцедуры

Процедура РезультатПустой() Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Поставщик");
	Ссылка = Конструктор.Записать();
	Конструктор.ДанныеОбъекта();
	
	ОписаниеЗапроса = ЮТЗапросы.ОписаниеЗапроса();
	ОписаниеЗапроса.ИмяТаблицы = "Справочник.Товары";
	ОписаниеЗапроса.Условия.Добавить("Ссылка = &Ссылка");
	ОписаниеЗапроса.ЗначенияПараметров.Вставить("Ссылка", Ссылка);
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.РезультатПустой(ОписаниеЗапроса)).ЭтоЛожь();
	
	ОписаниеЗапроса.Условия.Добавить("ПометкаУдаления");
	ЮТест.ОжидаетЧто(ЮТЗапросы.РезультатПустой(ОписаниеЗапроса)).ЭтоИстина();
	
КонецПроцедуры

Процедура Запись() Экспорт
	
	// Справочник
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Поставщик");
	Ссылка = Конструктор.Записать();
	ДанныеОбъекта = Конструктор.ДанныеОбъекта();
	
	ДанныеЗаписи = ЮТЗапросы.Запись("Справочник.Товары", ЮТест.Предикат()
		.Реквизит("Ссылка").Равно(Ссылка));
	
	ДанныеЗаписи = ЮТЗапросы.Запись("Справочник.Товары", ЮТест.Предикат()
		.Реквизит("Поставщик").Равно(ДанныеОбъекта.Поставщик));
	
	ЮТест.ОжидаетЧто(ДанныеЗаписи)
		.ИмеетТип("Структура")
		.Заполнено()
		.Свойство("Ссылка").Равно(Ссылка)
		.Свойство("Наименование").Равно(ДанныеОбъекта.Наименование)
		.Свойство("Поставщик").Равно(ДанныеОбъекта.Поставщик);
	
	// Справочник поиск по реквизиту
	ДанныеЗаписи = ЮТЗапросы.Запись("Справочник.Товары", ЮТест.Предикат()
		.Реквизит("Поставщик").Равно(ДанныеОбъекта.Поставщик));
	
	ЮТест.ОжидаетЧто(ДанныеЗаписи)
		.Свойство("Ссылка").Равно(Ссылка);
	
	// Поиск по неограниченной строке
	ИмяФайла = ЮТест.Данные().СлучайнаяСтрока();
	Ссылка = ЮТест.Данные().КонструкторОбъекта("Справочники.ХранимыеФайлы")
		.ФикцияОбязательныхПолей()
		.Установить("ИмяФайла", ИмяФайла)
		.Записать();
	
	ДанныеЗаписи = ЮТЗапросы.Запись("Справочник.ХранимыеФайлы", ЮТест.Предикат()
		.Реквизит("ИмяФайла").Равно(ИмяФайла));
	
	ЮТест.ОжидаетЧто(ДанныеЗаписи, "Поиск по неограниченной строке")
		.Свойство("Ссылка").Равно(Ссылка);
	
	ДанныеЗаписи = ЮТЗапросы.Запись("Справочник.ХранимыеФайлы", ЮТест.Предикат()
		.Реквизит("ИмяФайла").Равно(5));
	ЮТест.ОжидаетЧто(ДанныеЗаписи, "Поиск по неограниченной строке, число")
		.НеЗаполнено();
		
	ДанныеЗаписи = ЮТЗапросы.Запись("Справочник.ХранимыеФайлы", ЮТест.Предикат()
		.Реквизит("ИмяФайла").Равно(Неопределено));
	ЮТест.ОжидаетЧто(ДанныеЗаписи, "Поиск по неограниченной строке, Неопределено")
		.НеЗаполнено();
		
	// Документ, тест на табличную часть
	Конструктор = ПриходТовара();
	
	Ссылка = Конструктор.Записать();
	ДанныеОбъекта = Конструктор.ДанныеОбъекта();
	
	ДанныеЗаписи = ЮТЗапросы.Запись("Документ.ПриходТовара", ЮТест.Предикат()
		.Реквизит("Ссылка").Равно(Ссылка));
	
	ЮТест.ОжидаетЧто(ДанныеЗаписи)
		.Свойство("Ссылка").Равно(Ссылка)
		.Свойство("Поставщик").Равно(ДанныеОбъекта.Поставщик)
		.Свойство("Товары")
			.ИмеетТип("Массив")
			.ИмеетДлину(2)
			.Свойство("Товары[0].НомерСтроки").Равно(1)
			.Свойство("Товары[0].Товар").Равно(ДанныеОбъекта.Товары[0].Товар);
	
	ДанныеЗаписи = ЮТЗапросы.Запись("Документ.ПриходТовара.Товары", ЮТест.Предикат()
		.Реквизит("Товар").Равно(ДанныеОбъекта.Товары[0].Товар));
	ЮТест.ОжидаетЧто(ДанныеЗаписи)
		.Свойство("Ссылка").Равно(Ссылка)
		.Свойство("Товар").Равно(ДанныеОбъекта.Товары[0].Товар);
	
	// Регистры
	Курс = ЮТест.Данные().СлучайноеПоложительноеЧисло(99999);
	Конструктор = ЮТест.Данные().КонструкторОбъекта("РегистрыСведений.КурсыВалют")
		.Фикция("Период")
		.Фикция("Валюта")
		.Установить("Курс", Курс);
	Конструктор.Записать();
	ДанныеОбъекта = Конструктор.ДанныеОбъекта();
	
	ДанныеЗаписи = ЮТЗапросы.Запись("РегистрСведений.КурсыВалют", ЮТест.Предикат()
		.Реквизит("Валюта").Равно(ДанныеОбъекта.Валюта));
	
	ЮТест.ОжидаетЧто(ДанныеЗаписи)
		.Свойство("Валюта").Равно(ДанныеОбъекта.Валюта)
		.Свойство("Курс").Равно(Курс);
	
КонецПроцедуры

Процедура Записи() Экспорт
	
	ТоварыПоставщика = Новый Соответствие();
	Поставщик = ЮТест.Данные().СоздатьЭлемент("Справочники.Контрагенты");
	
	Для Инд = 1 По 5 Цикл
		Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
			.Фикция("Наименование")
			.Установить("Поставщик", Поставщик);
		ТоварыПоставщика.Вставить(Конструктор.Записать(), Конструктор.ДанныеОбъекта());
	КонецЦикла;
	
	Записи = ЮТЗапросы.Записи("Справочник.Товары", ЮТест.Предикат()
		.Реквизит("Поставщик").Равно(Поставщик));
	
	ЮТест.ОжидаетЧто(Записи)
		.ИмеетТип("Массив")
		.ИмеетДлину(5);
	
	Для Каждого Запись Из Записи Цикл
		ЮТест.ОжидаетЧто(Запись)
			.ИмеетТип("Структура")
			.Свойство("Ссылка")
			.Свойство("Поставщик").Равно(Поставщик)
			.Свойство("Код");
	КонецЦикла;
	
КонецПроцедуры

Процедура Запись_Субконто() Экспорт
	
	Ссылка = ПриходТовара().Провести();
	Запись = ЮТЗапросы.Запись("РегистрБухгалтерии.Основной.ДвиженияССубконто", ЮТест.Предикат()
		.Реквизит("Регистратор").Равно(Ссылка));
	
	ЮТест.ОжидаетЧто(Запись)
		.ИмеетТип("Структура")
		.ИмеетСвойство("ВидСубконто1")
		.ИмеетСвойство("ВидСубконто2")
		.ИмеетСвойство("ВидСубконто3")
		.ИмеетСвойство("Субконто1")
		.ИмеетСвойство("Субконто2")
		.ИмеетСвойство("Субконто3");
	
КонецПроцедуры

Процедура Записи_Субконто() Экспорт
	
	Ссылка = ПриходТовара().Провести();
	Записи = ЮТЗапросы.Записи("РегистрБухгалтерии.Основной.ДвиженияССубконто", ЮТест.Предикат()
		.Реквизит("Регистратор").Равно(Ссылка));
	
	ЮТест.ОжидаетЧто(Записи)
		.ИмеетТип("Массив")
		.ИмеетДлину(2)
		.КаждыйЭлементСодержитСвойство("ВидСубконто1")
		.КаждыйЭлементСодержитСвойство("ВидСубконто2")
		.КаждыйЭлементСодержитСвойство("ВидСубконто3")
		.КаждыйЭлементСодержитСвойство("Субконто1")
		.КаждыйЭлементСодержитСвойство("Субконто2")
		.КаждыйЭлементСодержитСвойство("Субконто3")
	;
	
КонецПроцедуры

Процедура ЗначенияРеквизитовЗаписи() Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Штрихкод")
		.Фикция("Поставщик");
	Данные = Конструктор.ДанныеОбъекта();
	Конструктор.Записать();
	
	Предикат = ЮТест.Предикат().Реквизит("Наименование").Равно(Данные.Наименование);
	ДанныеСсылки = ЮТЗапросы.ЗначенияРеквизитовЗаписи("Справочник.Товары", Предикат, "Наименование");
	ЮТест.ОжидаетЧто(ДанныеСсылки)
		.ИмеетТип("Структура")
		.Заполнено()
		.Свойство("Наименование").Равно(Данные.Наименование);
	
	Предикат = ЮТест.Предикат()
		.Реквизит("Штрихкод").Равно(Данные.Штрихкод)
		.Реквизит("Поставщик").Равно(Данные.Поставщик);
	ДанныеСсылки = ЮТЗапросы.ЗначенияРеквизитовЗаписи("Справочник.Товары", Предикат, "Штрихкод, Поставщик, Поставщик.Наименование");
	ЮТест.ОжидаетЧто(ДанныеСсылки)
		.ИмеетТип("Структура")
		.Заполнено()
		.Свойство("Штрихкод").Равно(Данные.Штрихкод)
		.Свойство("Поставщик").Равно(Данные.Поставщик)
		.Свойство("ПоставщикНаименование").Равно(Строка(Данные.Поставщик));
	
	Предикат = ЮТест.Предикат().Реквизит("Ссылка").Равно(ПредопределенноеЗначение("Справочник.Товары.ПустаяСсылка"));
	ДанныеСсылки = ЮТЗапросы.ЗначенияРеквизитовЗаписи("Справочник.Товары", Предикат, "Код, Поставщик");
	ЮТест.ОжидаетЧто(ДанныеСсылки)
		.ИмеетТип("Структура")
		.Заполнено()
		.Свойство("Код").Равно(Неопределено)
		.Свойство("Поставщик").Равно(Неопределено);
	
КонецПроцедуры

Процедура ЗначениеРеквизитаЗаписи() Экспорт
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Поставщик");
	Данные = Конструктор.ДанныеОбъекта();
	Конструктор.Записать();
	
	Предикат = ЮТест.Предикат().Реквизит("Наименование").Равно(Данные.Наименование);
	ЮТест.ОжидаетЧто(ЮТЗапросы.ЗначениеРеквизитаЗаписи("Справочник.Товары", Предикат, "Наименование"))
		.ИмеетТип("Строка")
		.Заполнено()
		.Равно(Данные.Наименование);
	
	Предикат = ЮТест.Предикат().Реквизит("Поставщик").Равно(Данные.Поставщик);
	ЮТест.ОжидаетЧто(ЮТЗапросы.ЗначениеРеквизитаЗаписи("Справочник.Товары", Предикат, "Поставщик"))
		.Равно(Данные.Поставщик);
	
	Предикат = ЮТест.Предикат()
		.Реквизит("Наименование").Равно(Данные.Наименование)
		.Реквизит("Поставщик").Равно(Данные.Поставщик);
	ЮТест.ОжидаетЧто(ЮТЗапросы.ЗначениеРеквизитаЗаписи("Справочник.Товары", Предикат, "Наименование, Поставщик"))
		.Равно(Данные.Наименование);
	
	Предикат = ЮТест.Предикат().Реквизит("Ссылка").Равно(ПредопределенноеЗначение("Справочник.Товары.ПустаяСсылка"));
	ЮТест.ОжидаетЧто(ЮТЗапросы.ЗначениеРеквизитаЗаписи("Справочник.Товары", Предикат, "Наименование"))
		.Равно(Неопределено);
	
КонецПроцедуры

Процедура ДвиженияДокумента() Экспорт
	
	Конструктор = ПриходТовара();
	Документ = Конструктор.Провести();
	ДанныеОбъекта = Конструктор.ДанныеОбъекта();
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.ДвиженияДокумента(Документ, "Взаиморасчеты"))
		.Заполнено()
		.ИмеетДлину(1)
		.Свойство("[0].Регистратор").Равно(Документ)
		.Свойство("[0].НомерСтроки").Равно(1)
		.Свойство("[0].Контрагент").Равно(ДанныеОбъекта.Поставщик)
		.Свойство("[0].Валюта")
		.Свойство("[0].Сумма").Равно(ДанныеОбъекта.Товары[0].Сумма + ДанныеОбъекта.Товары[1].Сумма)
	;
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.ДвиженияДокумента(Документ, "ТоварныеЗапасы"))
		.Заполнено()
		.ИмеетДлину(2)
		.Свойство("[0].Регистратор").Равно(Документ)
		.Свойство("[0].НомерСтроки").Равно(1)
		.Свойство("[0].Товар").Равно(ДанныеОбъекта.Товары[0].Товар)
		.Свойство("[0].Склад").Равно(ДанныеОбъекта.Склад)
		.Свойство("[0].Количество").Равно(ДанныеОбъекта.Товары[0].Количество)
		.Свойство("[1].Регистратор").Равно(Документ)
		.Свойство("[1].НомерСтроки").Равно(2)
		.Свойство("[1].Товар").Равно(ДанныеОбъекта.Товары[1].Товар)
		.Свойство("[1].Склад").Равно(ДанныеОбъекта.Склад)
		.Свойство("[1].Количество").Равно(ДанныеОбъекта.Товары[1].Количество)
	;
	
КонецПроцедуры

Процедура Записи_Условие_ВСписке() Экспорт
	
	ИмяТаблицы = "Справочник.Товары";
	ВидТовар = ПредопределенноеЗначение("Перечисление.ВидыТоваров.Товар");
	ВидУслуга = ПредопределенноеЗначение("Перечисление.ВидыТоваров.Услуга");
	Товар = НовыйТовар(ВидТовар);
	Услуга = НовыйТовар(ВидУслуга);
	
	Результат = ЮТЗапросы.Записи(ИмяТаблицы, ЮТест.Предикат()
		.Свойство("Вид").ВСписке(ЮТКоллекции.ЗначениеВМассиве(ВидТовар, ВидУслуга)));
	
	ЮТест.ОжидаетЧто(Результат)
		.ИмеетДлину(2)
		.ЛюбойЭлементСодержитСвойствоСоЗначением("Ссылка", Товар)
		.ЛюбойЭлементСодержитСвойствоСоЗначением("Ссылка", Услуга);
	
	Результат = ЮТЗапросы.Записи(ИмяТаблицы, ЮТест.Предикат()
		.Свойство("Вид").ВСписке(ЮТКоллекции.ЗначениеВМассиве(ВидТовар)));
	
	ЮТест.ОжидаетЧто(Результат)
		.ИмеетДлину(1)
		.Свойство("[0].Ссылка", Товар);
	
КонецПроцедуры

Процедура Записи_Условие_Между() Экспорт
	
	День = 24*3600;
	
	ИмяТаблицы = "РегистрСведений.КурсыВалют";
	Валюта = ЮТест.Данные().СоздатьЭлемент("Справочник.Валюты");
	Период = НачалоДня(ЮТест.Данные().СлучайнаяДата());
	ПериодПосле = Период + День;
	ПериодДо = Период - День;
	
	ЮТест.Данные().КонструкторОбъекта(ИмяТаблицы)
		.Установить("Валюта", Валюта)
		.Установить("Период", ПериодДо).Установить("Курс", 5)
		.ДобавитьЗапись()
		.Установить("Период", Период).Установить("Курс", 10)
		.ДобавитьЗапись()
		.Установить("Период", ПериодПосле).Установить("Курс", 15)
		.ДобавитьЗапись()
	;
	
	Результат = ЮТЗапросы.Записи(ИмяТаблицы, ЮТест.Предикат()
		.Свойство("Валюта").Равно(Валюта))
	;
	ЮТест.ОжидаетЧто(Результат, "Проверка записей в регистре")
		.ИмеетДлину(3)
	;
	// Между
	Результат = ЮТЗапросы.Записи(ИмяТаблицы, ЮТест.Предикат()
		.Свойство("Валюта").Равно(Валюта)
		.Свойство("Период").Между(Период, ПериодПосле))
	;
	ЮТест.ОжидаетЧто(Результат, "Между")
		.ИмеетДлину(2)
		.Свойство("[0].Курс").Равно(10)
		.Свойство("[1].Курс").Равно(15)
	;
	// МеждуИсключаяГраницы
	Результат = ЮТЗапросы.Записи(ИмяТаблицы, ЮТест.Предикат()
		.Свойство("Валюта").Равно(Валюта)
		.Свойство("Период").МеждуИсключаяГраницы(Период, ПериодПосле))
	;
	ЮТест.ОжидаетЧто(Результат, "МеждуИсключаяГраницы")
		.ИмеетДлину(0)
	;
	Результат = ЮТЗапросы.Записи(ИмяТаблицы, ЮТест.Предикат()
		.Свойство("Валюта").Равно(Валюта)
		.Свойство("Период").МеждуИсключаяГраницы(Период, ПериодПосле + 1))
	;
	ЮТест.ОжидаетЧто(Результат, "МеждуИсключаяГраницы со смещенной датой")
		.ИмеетДлину(1)
		.Свойство("[0].Курс").Равно(15)
	;
	
	// МеждуВключаяНачалоГраницы
	Результат = ЮТЗапросы.Записи(ИмяТаблицы, ЮТест.Предикат()
		.Свойство("Валюта").Равно(Валюта)
		.Свойство("Период").МеждуВключаяНачалоГраницы(ПериодДо, Период))
	;
	ЮТест.ОжидаетЧто(Результат, "МеждуВключаяНачалоГраницы")
		.ИмеетДлину(1)
		.Свойство("[0].Курс").Равно(5)
	;
	
	// МеждуВключаяОкончаниеГраницы
	Результат = ЮТЗапросы.Записи(ИмяТаблицы, ЮТест.Предикат()
		.Свойство("Валюта").Равно(Валюта)
		.Свойство("Период").МеждуВключаяОкончаниеГраницы(Период, ПериодПосле))
	;
	ЮТест.ОжидаетЧто(Результат, "МеждуВключаяОкончаниеГраницы")
		.ИмеетДлину(1)
		.Свойство("[0].Курс").Равно(15)
	;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйТовар(ВидТовара = Неопределено)
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Фикция("Наименование")
		.Фикция("Поставщик");
	
	Если ЗначениеЗаполнено(ВидТовара) Тогда
		Конструктор.Установить("Вид", ВидТовара);
	Иначе
		Конструктор.Фикция("Вид");
	КонецЕсли;
	
	Возврат Конструктор.Записать();
	
КонецФункции

Функция ПриходТовара()
	
	Возврат ЮТест.Данные().КонструкторОбъекта("Документы.ПриходТовара")
		.Фикция("Склад")
		.Фикция("Организация")
		.Фикция("Поставщик")
		.Фикция("Валюта")
		.ТабличнаяЧасть("Товары")
			.ДобавитьСтроку()
				.Установить("Сумма", ЮТест.Данные().СлучайноеПоложительноеЧисло(999999)) // иначе возможно переполнение
				.ФикцияОбязательныхПолей()
			.ДобавитьСтроку()
				.Установить("Сумма", ЮТест.Данные().СлучайноеПоложительноеЧисло(999999)) // иначе возможно переполнение
				.ФикцияОбязательныхПолей();
	
КонецФункции

#КонецОбласти
