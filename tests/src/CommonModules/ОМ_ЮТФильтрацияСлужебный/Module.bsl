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
	
	ЮТТесты
		.ДобавитьТест("ЭтоПодходящееРасширение")
		.ДобавитьТест("ЭтоПодходящийМодуль")
		.ДобавитьТест("ОтфильтроватьТестовыеНаборы")
		.Добавитьтест("Фильтр_ПолноеИмяТеста")
		.Добавитьтест("Фильтр_Контексты")
		.Добавитьтест("Фильтр_ТегиМодуля")
		.Добавитьтест("Фильтр_ТегиНабора")
		.Добавитьтест("Фильтр_ТегиТеста")
		.Добавитьтест("Фильтр_Наборы")
	;
	
КонецПроцедуры

Процедура ЭтоПодходящееРасширение() Экспорт
	
	Варианты = ЮТест.Варианты("ИмяРасширения, Параметры, Результат, Описание");
	
	Параметры = ЮТФабрика.ПараметрыЗапуска();
	Параметры.filter.extensions = ЮТКоллекции.ЗначениеВМассиве("test", "тесты");
	Варианты.Добавить("test", Параметры, Истина, "Простой кейс");
	Варианты.Добавить("TeST", Параметры, Истина, "Изменен регистр");
	Варианты.Добавить("тесты", Параметры, Истина, "Второе расширение");
	Варианты.Добавить("_test", Параметры, Ложь, "Отсутствующее расширение");
	
	Параметры = ЮТФабрика.ПараметрыЗапуска();
	Варианты.Добавить("test", Параметры, Истина, "Без фильтр по расширениям 1");
	Варианты.Добавить("_test", Параметры, Истина, "Без фильтр по расширениям 2");
	
	Параметры = ЮТФабрика.ПараметрыЗапуска();
	Параметры.filter.tests = ЮТКоллекции.ЗначениеВМассиве("test.method");
	Варианты.Добавить("test", Параметры, Истина, "Фильтр по пути");
	Варианты.Добавить("_test", Параметры, Истина, "Фильтр по пути, отпустствующее расширение");
	
	Для Каждого Вариант Из Варианты.СписокВариантов() Цикл
		
		УстановитьФильтр(Вариант.Параметры);
		Результат = ЮТФильтрацияСлужебный.ЭтоПодходящееРасширение(Вариант.ИмяРасширения);
		
		ЮТест.ОжидаетЧто(Результат, Вариант.Описание).Равно(Вариант.Результат);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЭтоПодходящийМодуль() Экспорт
	
	Варианты = ЮТест.Варианты("ИмяМодуля, Параметры, Результат, Описание");
	РасширениеПоУмолчанию = "__тесты___";
	
	Параметры = ЮТФабрика.ПараметрыЗапуска();
	Параметры.filter.modules = ЮТКоллекции.ЗначениеВМассиве("test", "тесты");
	
	Варианты.Добавить("test", Параметры, Истина, "Простой кейс");
	Варианты.Добавить("TeST", Параметры, Истина, "Изменен регистр");
	Варианты.Добавить("тесты", Параметры, Истина, "Второй модуль");
	Варианты.Добавить("_test", Параметры, Ложь, "Отсутствующий модуль");
	
	Параметры = ЮТФабрика.ПараметрыЗапуска();
	
	Варианты.Добавить("module", Параметры, Истина, "Без фильтр по `module`");
	Варианты.Добавить("_module", Параметры, Истина, "Без фильтр по `_module`");
	
	Параметры = ЮТФабрика.ПараметрыЗапуска();
	Параметры.filter.modules = ЮТКоллекции.ЗначениеВМассиве("module");
	Параметры.filter.extensions = ЮТКоллекции.ЗначениеВМассиве(РасширениеПоУмолчанию);
	
	Варианты.Добавить("module", Параметры, Истина, "Фильтр по модулю и по расширению с пересечением");
	
	Параметры = ЮТФабрика.ПараметрыЗапуска();
	Параметры.filter.modules = ЮТКоллекции.ЗначениеВМассиве("module");
	Параметры.filter.extensions = ЮТКоллекции.ЗначениеВМассиве("тесты");
	Варианты.Добавить("module", Параметры, Ложь, "Фильтр по модулю и по расширению без пересечения");
	
	// Фильтрация по именам тестовых методов
	Параметры = ЮТФабрика.ПараметрыЗапуска();
	Параметры.filter.tests = ЮТКоллекции.ЗначениеВМассиве("module.method");
	Варианты.Добавить("module", Параметры, Истина, "Фильтр по имени теста");
	Варианты.Добавить("_test", Параметры, Ложь, "Фильтр по имени теста, отсутствующему модулю");
	
	Параметры = ЮТФабрика.ПараметрыЗапуска();
	Параметры.filter.tests = ЮТКоллекции.ЗначениеВМассиве("module.method");
	Параметры.filter.extensions = ЮТКоллекции.ЗначениеВМассиве(РасширениеПоУмолчанию);
	Варианты.Добавить("module", Параметры, Истина, "Фильтр по имени теста и по расширению с пересечением");
	
	Параметры = ЮТФабрика.ПараметрыЗапуска();
	Параметры.filter.tests = ЮТКоллекции.ЗначениеВМассиве("module.method");
	Параметры.filter.extensions = ЮТКоллекции.ЗначениеВМассиве("test");
	Варианты.Добавить("module", Параметры, Ложь, "Фильтр по имени теста и по расширению без пересечения");
	
	Параметры = ЮТФабрика.ПараметрыЗапуска();
	Параметры.filter.tests = ЮТКоллекции.ЗначениеВМассиве("module.method");
	Параметры.filter.modules = ЮТКоллекции.ЗначениеВМассиве("module");
	Варианты.Добавить("module", Параметры, Истина, "Фильтр по имени теста и по модулю с пересечением");
	
	Параметры = ЮТФабрика.ПараметрыЗапуска();
	Параметры.filter.tests = ЮТКоллекции.ЗначениеВМассиве("module.method");
	Параметры.filter.modules = ЮТКоллекции.ЗначениеВМассиве("test");
	Варианты.Добавить("module", Параметры, Ложь, "Фильтр по имени теста и по модулю без пересечения");
	
	Для Каждого Вариант Из Варианты.СписокВариантов() Цикл
		
		УстановитьФильтр(Вариант.Параметры);
		ОписаниеМодуля = МетаданныеМодуля(Вариант.ИмяМодуля, РасширениеПоУмолчанию);
		
		Результат = ЮТФильтрацияСлужебный.ЭтоПодходящийМодуль(ОписаниеМодуля);
		
		ЮТест.ОжидаетЧто(Результат, Вариант.Описание + ". Имя модуля:" + Вариант.ИмяМодуля).Равно(Вариант.Результат);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтфильтроватьТестовыеНаборы() Экспорт
	
	// 1
	Контексты = ЮТФабрика.КонтекстыВызова();
	
	Набор = ОписаниеНабораТестов("Тесты");
	Тест = ОписаниеТеста("Тест1","Сервер, КлиентУправляемоеПриложение");
	Набор.Тесты.Добавить(Тест);
	
	ОписаниеМодуля = ОписаниеМодуля();
	ОписаниеМодуля.МетаданныеМодуля.Сервер = Истина;
	ОписаниеМодуля.МетаданныеМодуля.КлиентУправляемоеПриложение = Истина;
	
	ДобавитьКопиюНабора(ОписаниеМодуля, Набор);
	
	УстановитьНовыйФильтр(, "ТестовыйМодуль.Тест1");
	
	ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(ОписаниеМодуля);
	ЮТест.ОжидаетЧто(ОписаниеМодуля.НаборыТестов, "Результат фильтрации")
		.Заполнено()
		.Свойство("[0].Тесты").Заполнено()
		.Что(ОписаниеМодуля.НаборыТестов[0].Тесты[0], "Тест результата")
			.Свойство("Имя").Равно("Тест1")
			.Свойство("КонтекстВызова").ИмеетДлину(2);
	
	// 2
	ОписаниеМодуля.НаборыТестов.Очистить();
	ДобавитьКопиюНабора(ОписаниеМодуля, Набор);
	УстановитьНовыйФильтр(, "ТестовыйМодуль.Тест1.Сервер");
	
	ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(ОписаниеМодуля);
	ЮТест.ОжидаетЧто(ОписаниеМодуля.НаборыТестов[0].Тесты[0], "Тест с указанием контекста")
		.Свойство("Имя").Равно(Тест.Имя)
		.Свойство("КонтекстВызова").ИмеетДлину(1);
	
	// 3
	ОписаниеМодуля.НаборыТестов.Очистить();
	ДобавитьКопиюНабора(ОписаниеМодуля, Набор);
	УстановитьНовыйФильтр(, "ТестовыйМодуль.Тест1.ВызовСервера");
	
	ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(ОписаниеМодуля);
	ЮТест.ОжидаетЧто(ОписаниеМодуля.НаборыТестов, "Тест с указаниме недоступного контекста")
		.ИмеетДлину(0);
	
	// 4
	ОписаниеМодуля.НаборыТестов.Очистить();
	ДобавитьКопиюНабора(ОписаниеМодуля, Набор);
	УстановитьНовыйФильтр(, "ТестовыйМодуль.Тест1.Сервер", "КлиентУправляемоеПриложение");
	
	ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(ОписаниеМодуля);
	ЮТест.ОжидаетЧто(ОписаниеМодуля.НаборыТестов, "Тест с указаниме контекста и фильтра контекстов")
		.ИмеетДлину(0);
	
КонецПроцедуры

Процедура Фильтр_ПолноеИмяТеста() Экспорт
	
	ИмяМодуля = "ТестовыйМодуль";
	ИмяТеста = "ТестовыйТест";
	
	ОписаниеМодуля = ОписаниеМодуля(ИмяМодуля);
	НаборТестов = ОписаниеНабораТестов();
	НаборТестов.Тесты.Добавить(ОписаниеТеста(ИмяТеста));
	НаборТестов.Тесты.Добавить(ОписаниеТеста(ИмяТеста, "Сервер"));
	НаборТестов.Тесты.Добавить(ОписаниеТеста(ИмяТеста + "_"));
	НаборТестов.Тесты.Добавить(ОписаниеТеста(ИмяТеста, "НеСервер"));
	НаборТестов.Тесты.Добавить(ОписаниеТеста());
	ДобавитьКопиюНабора(ОписаниеМодуля, НаборТестов);
	
	УстановитьНовыйФильтр(, СтрШаблон("%1.%2", ИмяМодуля, ИмяТеста));
	ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(ОписаниеМодуля);
	
	ЮТест.ОжидаетЧто(ОписаниеМодуля.НаборыТестов)
		.ИмеетДлину(1)
		.Свойство("[0].Тесты").ИмеетДлину(2);
	
	УстановитьНовыйФильтр(, СтрШаблон("%1.%2.КлиентУправляемоеПриложение", ИмяМодуля, ИмяТеста));
	ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(ОписаниеМодуля);
	
	ЮТест.ОжидаетЧто(ОписаниеМодуля.НаборыТестов)
		.ИмеетДлину(1)
		.Свойство("[0].Тесты").ИмеетДлину(1);
	
КонецПроцедуры

Процедура Фильтр_Контексты() Экспорт
	
	ОписаниеМодуля = ОписаниеМодуля();
	НаборТестов = ОписаниеНабораТестов();
	НаборТестов.Тесты.Добавить(ОписаниеТеста());                   // +
	НаборТестов.Тесты.Добавить(ОписаниеТеста(, "Сервер"));         // +
	НаборТестов.Тесты.Добавить(ОписаниеТеста(, "Сервер, Сервер")); // +
	НаборТестов.Тесты.Добавить(ОписаниеТеста(, "Клиент"));
	ОписаниеМодуля.НаборыТестов.Добавить(НаборТестов);
	
	УстановитьНовыйФильтр(, , "Сервер");
	ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(ОписаниеМодуля);
	
	ЮТест.ОжидаетЧто(ОписаниеМодуля.НаборыТестов)
		.ИмеетДлину(1)
		.Свойство("[0].Тесты").ИмеетДлину(3);
	
КонецПроцедуры

Процедура Фильтр_ТегиТеста() Экспорт
	
	ОписаниеМодуля = ОписаниеМодуляДляТестированияФильтрации();
	
	УстановитьНовыйФильтр(, , , "Тег Теста1, ТегТеста2, Т, _, Тег111");
	ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(ОписаниеМодуля);
	
	ЮТест.ОжидаетЧто(ОписаниеМодуля.НаборыТестов)
		.ИмеетДлину(2)
		.Свойство("[0].Тесты").ИмеетДлину(3)
		.Свойство("[1].Тесты").ИмеетДлину(1);
	
КонецПроцедуры

Процедура Фильтр_ТегиНабора() Экспорт
	
	ОписаниеМодуля = ОписаниеМодуляДляТестированияФильтрации();
	
	УстановитьНовыйФильтр(, , , "Тег Набора");
	ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(ОписаниеМодуля);
	
	ЮТест.ОжидаетЧто(ОписаниеМодуля.НаборыТестов)
		.ИмеетДлину(1)
		.Свойство("[0].Тесты").ИмеетДлину(5);
	
	ОписаниеМодуля = ОписаниеМодуляДляТестированияФильтрации();
	
	УстановитьНовыйФильтр(, , , "Тег Набора, ТегТеста");
	ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(ОписаниеМодуля);
	
	ЮТест.ОжидаетЧто(ОписаниеМодуля.НаборыТестов)
		.ИмеетДлину(2)
		.Свойство("[0].Тесты").ИмеетДлину(5)
		.Свойство("[1].Тесты").ИмеетДлину(1);
	
КонецПроцедуры

Процедура Фильтр_ТегиМодуля() Экспорт
	
	ОписаниеМодуля = ОписаниеМодуляДляТестированияФильтрации();
	УстановитьНовыйФильтр(, , , "Тег Модуля");
	ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(ОписаниеМодуля);
	
	ЮТест.ОжидаетЧто(ОписаниеМодуля.НаборыТестов)
		.ИмеетДлину(0);
	
	ОписаниеМодуля = ОписаниеМодуляДляТестированияФильтрации();
	ОписаниеМодуля.Теги.Добавить("Тег Модуля");
	
	УстановитьНовыйФильтр(, , , "Тег Модуля");
	ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(ОписаниеМодуля);
	
	ЮТест.ОжидаетЧто(ОписаниеМодуля.НаборыТестов)
		.ИмеетДлину(2)
		.Свойство("[0].Тесты").ИмеетДлину(5)
		.Свойство("[1].Тесты").ИмеетДлину(2);

КонецПроцедуры

Процедура Фильтр_Наборы() Экспорт
	
	ОписаниеМодуля = ОписаниеМодуляДляТестированияФильтрации();
	ОписаниеМодуля.НаборыТестов[1].Имя = "ТестовыйНабор2";
	УстановитьНовыйФильтр(, , , , "ТестовыйНабор");
	ЮТФильтрацияСлужебный.ОтфильтроватьТестовыеНаборы(ОписаниеМодуля);
	
	ЮТест.ОжидаетЧто(ОписаниеМодуля.НаборыТестов)
		.ИмеетДлину(1)
		.Свойство("[0].Тесты").ИмеетДлину(5)
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьНовыйФильтр(Модули = Неопределено,
								Тесты = Неопределено,
								Контексты = Неопределено,
								Теги = Неопределено,
								Наборы = Неопределено)
	
	Параметры = ЮТФабрика.ПараметрыЗапуска();
	
	Если Наборы <> Неопределено Тогда
		Параметры.filter.suites = ЮТСтроки.РазделитьСтроку(Наборы, ",");
	КонецЕсли;
	
	Если Тесты <> Неопределено Тогда
		Параметры.filter.tests = ЮТСтроки.РазделитьСтроку(Тесты, ",");
	КонецЕсли;
	
	Если Модули <> Неопределено Тогда
		Параметры.filter.modules = ЮТСтроки.РазделитьСтроку(Модули, ",");
	КонецЕсли;
	
	Если Теги <> Неопределено Тогда
		Параметры.filter.tags = ЮТСтроки.РазделитьСтроку(Теги, ",");
	КонецЕсли;
	
	Если Контексты <> Неопределено Тогда
		Параметры.filter.contexts = ЮТСтроки.РазделитьСтроку(Контексты, ",");
	КонецЕсли;
	
	УстановитьФильтр(Параметры);
	
КонецПроцедуры

Процедура УстановитьФильтр(Параметры)
	
	ЮТФильтрацияСлужебный.УстановитьКонтекст(Параметры);
	
КонецПроцедуры

Функция МетаданныеМодуля(ИмяМодуля = "ТестовыйМодуль", Расширение = "ТестовоеРасширение")
	
	МетаданныеМодуля = ЮТФабрикаСлужебный.ОписаниеМодуля();
	МетаданныеМодуля.Имя = ИмяМодуля;
	МетаданныеМодуля.Расширение = Расширение;
	
	Возврат МетаданныеМодуля;
	
КонецФункции

Функция ОписаниеМодуля(ИмяМодуля = "ТестовыйМодуль")
	
	Возврат ЮТФабрикаСлужебный.ОписаниеТестовогоМодуля(МетаданныеМодуля(ИмяМодуля), Новый Массив());
	
КонецФункции

Функция ОписаниеНабораТестов(Имя = "ТестовыйНабор", Теги = "")
	
	Возврат ЮТФабрикаСлужебный.ОписаниеТестовогоНабора(Имя, Теги);
	
КонецФункции

Функция ОписаниеТеста(ИмяТеста = Неопределено, КонтекстыВызова = "Сервер, КлиентУправляемоеПриложение", Теги = "")
	
	Если ИмяТеста = Неопределено Тогда
		ИмяТеста = ЮТест.Данные().СлучайнаяСтрока();
	КонецЕсли;
	
	Возврат ЮТФабрикаСлужебный.ОписаниеТеста(ИмяТеста, 
											 ЮТест.Данные().СлучайнаяСтрока(),
											 ЮТСтроки.РазделитьСтроку(КонтекстыВызова, ","),
											 Теги);
	
КонецФункции

Процедура ДобавитьКопиюНабора(ОписаниеМодуля, Набор)
	
	ОписаниеМодуля.НаборыТестов.ДОбавить(ЮТКоллекции.СкопироватьРекурсивно(Набор));
	
КонецПроцедуры

Функция ОписаниеМодуляДляТестированияФильтрации()
	
	Набор1 = ОписаниеНабораТестов();
	Набор1.Теги = ЮТКоллекции.ЗначениеВМассиве("Тег набора");
	Набор1.Тесты.Добавить(ОписаниеТеста());
	Набор1.Тесты.Добавить(ОписаниеТеста(, , "Тег Теста1"));
	Набор1.Тесты.Добавить(ОписаниеТеста(, , "Тег Теста1, ТегТеста2"));
	Набор1.Тесты.Добавить(ОписаниеТеста(, , "ТегТеста"));
	Набор1.Тесты.Добавить(ОписаниеТеста(, , "ТЕГ Теста1"));
	
	Набор2 = ОписаниеНабораТестов();
	Набор2.Тесты.Добавить(ОписаниеТеста(, , "ТегТеста2"));
	Набор2.Тесты.Добавить(ОписаниеТеста(, , "ТегТеста"));
	
	ОписаниеМодуля = ОписаниеМодуля();
	ОписаниеМодуля.НаборыТестов.Добавить(Набор1);
	ОписаниеМодуля.НаборыТестов.Добавить(Набор2);
	
	Возврат ОписаниеМодуля;
	
КонецФункции

#КонецОбласти
