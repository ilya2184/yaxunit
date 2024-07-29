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
	
	ЮТТесты.Тег("ТестовыеДанные").УдалениеТестовыхДанных()
		.ДобавитьТест("Удалить")
		.ДобавитьТест("ВариантыПараметров")
		.ДобавитьТест("СоздатьГруппу")
		.ДобавитьСерверныйТест("СоздатьОбъектСПередачейПараметров")
			.СПараметрами("СоздатьЭлемент")
			.СПараметрами("СоздатьГруппу")
			.СПараметрами("СоздатьДокумент")
		.ДобавитьТест("ЗагрузитьИзМакета_ТабличныйДокумент")
		.ДобавитьТест("ЗагрузитьИзМакета_MarkDown")
		.ДобавитьТест("ЗагрузитьИзМакета_ЧастичнаяЗагрузкаДанных")
		.ДобавитьТест("ЗагрузитьИзМакета_Проверки")
		.ДобавитьТест("ЗагрузитьИзМакета_ЦепочкаЗагрузок")
		.ДобавитьТест("ЗагрузитьИзМакета_ОбменДаннымиЗагрузка")
		.ДобавитьТест("СлучайныйИдентификатор")
		.ДобавитьТест("СлучайноеЗначениеПеречисления")
		.ДобавитьТест("УстановитьЗначениеРеквизита")
		.ДобавитьТест("СлучайноеОтрицательноеЧисло")
		.ДобавитьТест("СлучайныйНомерТелефона")
		.ДобавитьТест("Фикция")
			.СПараметрами(Тип("Строка"))
			.СПараметрами(Тип("СправочникСсылка.Банки"))
			.СПараметрами(Новый ОписаниеТипов("СправочникСсылка.Банки"))
			.СПараметрами(Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(3, 1, ДопустимыйЗнак.Неотрицательный)))
			.СПараметрами(Новый ОписаниеТипов("СправочникСсылка.Банки, ДокументСсылка.Заказ"))
		.ДобавитьТест("СлучайноеПредопределенноеЗначение")
		.ДобавитьТест("СлучайнаяДата")
		.ДобавитьТест("СлучайноеВремя")
		.ДобавитьТест("СлучайнаяДатаПосле")
		.ДобавитьТест("СлучайнаяДатаДо")
		.ДобавитьСерверныйТест("УстановитьФоновуюБлокировку")
	;
	
КонецПроцедуры

Процедура Удалить() Экспорт
	
	Ссылки = Новый Массив;
	Ссылки.Добавить(ЮТест.Данные().СоздатьЭлемент("Справочники.Банки"));
	Ссылки.Добавить(ЮТест.Данные().СоздатьДокумент("Документы.ПриходТовара"));
	Ссылки.Добавить(ЮТест.Данные().КонструкторОбъекта("Документы.ПриходТовара").Провести());
	
	Для Каждого Ссылка Из Ссылки Цикл
		
		СсылкаСуществует = ПомощникТестированияВызовСервера.СсылкаСуществует(Ссылка);
		ЮТест.ОжидаетЧто(СсылкаСуществует, "Ссылка на несуществующий объект").ЭтоИстина();
		
	КонецЦикла;
	
	ЮТест.Данные().Удалить(Ссылки);
	
	Для Каждого Ссылка Из Ссылки Цикл
		
		СсылкаСуществует = ПомощникТестированияВызовСервера.СсылкаСуществует(Ссылка);
		ЮТест.ОжидаетЧто(СсылкаСуществует, "Объект не удален по ссылке").ЭтоЛожь();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВариантыПараметров() Экспорт
	
	Ключи = "Числа, Строки";
	БазоваяСтруктура = Новый Структура(Ключи);
	Значения = Новый Структура(Ключи, ЮТКоллекции.ЗначениеВМассиве(1, 2), ЮТКоллекции.ЗначениеВМассиве("1", "2"));
	
	Результат = ЮТест.Данные().ВариантыПараметров(БазоваяСтруктура, Значения);
	
	ЮТест.ОжидаетЧто(Результат)
		.ИмеетТип("Массив")
		.ИмеетДлину(7)
		.Элемент(0).Равно(БазоваяСтруктура)
		.Элемент(1).Равно(Новый Структура(Ключи, 1))
		.Элемент(2).Равно(Новый Структура(Ключи, 1, "1"))
		.Элемент(3).Равно(Новый Структура(Ключи, 1, "2"))
		.Элемент(5).Равно(Новый Структура(Ключи, 2, "1"))
		.Элемент(6).Равно(Новый Структура(Ключи, 2, "2"));
	
КонецПроцедуры

Процедура СоздатьГруппу() Экспорт
	
	Группа = ЮТест.Данные().СоздатьГруппу("Справочники.Товары");
	
	ЭтоГруппа = ЮТЗапросы.ЗначениеРеквизита(Группа, "ЭтоГруппа");
	ЮТест.ОжидаетЧто(ЭтоГруппа).ЭтоИстина();
	
КонецПроцедуры

#Если Сервер Тогда

Процедура СоздатьОбъектСПередачейПараметров(ТестируемыйМетод) Экспорт
	
	ЭтоСозданиеДокумента = (ТестируемыйМетод = "СоздатьДокумент");
	Если ЭтоСозданиеДокумента Тогда
		ТестируемыйТип = "ДокументОбъект.ПриходТовара";
		ТестируемыйМенеджер = "Документ.ПриходТовара";
		МокируемыйМетод = "ПередЗаписьюДокумента";
	Иначе
		ТестируемыйТип = "СправочникОбъект.Товары";
		ТестируемыйМенеджер = "Справочник.Товары";
		МокируемыйМетод = "ПередЗаписьюСправочника";
	КонецЕсли;
	
	СлучайноеСвойство = "Свойство" + ЮТест.Данные().СлучайнаяСтрока();
	СлучайноеЗначение = Новый УникальныйИдентификатор();
	ТекстИсключения = "Проверка прошла успешна";
	
	ЛюбойПараметр = Мокито.ЛюбойПараметр();
	УсловиеПредикат = ЮТест.Предикат()
		.ИмеетТип(ТестируемыйТип)
		.Реквизит("ОбменДанными.Загрузка").Равно(Истина)
		.Реквизит("ДополнительныеСвойства." + СлучайноеСвойство).Равно(СлучайноеЗначение)
		.Получить();
	
	Мокито.Обучение(ПодпискиНаСобытия)
		.Когда(МокируемыйМетод,
			Мокито.МассивПараметров(УсловиеПредикат))
		.ВыброситьИсключение(ТекстИсключения)
		.Прогон();
	
	ПараметрыЗаписи = ЮТОбщий.ПараметрыЗаписи();
	ПараметрыЗаписи.ОбменДаннымиЗагрузка = Истина;
	ПараметрыЗаписи.ДополнительныеСвойства.Вставить(СлучайноеСвойство, СлучайноеЗначение);
	
	ПараметрыМетода = ЮТКоллекции.ЗначениеВМассиве(
			ТестируемыйМенеджер, Неопределено, ПараметрыЗаписи);
	
	Если НЕ ЭтоСозданиеДокумента Тогда
		ПараметрыМетода.Вставить(1, "Тестовое наименование");
	КонецЕсли;
	
	ЮТУтверждения.Что(ЮТТестовыеДанные)
		.Метод(ТестируемыйМетод, ПараметрыМетода)
		.ВыбрасываетИсключение(ТекстИсключения);
	
	Мокито.Сбросить();
	
КонецПроцедуры

#КонецЕсли

Процедура СлучайныйИдентификатор() Экспорт
	
	Проверка = Новый Структура();
	
	Для Инд = 1 По 100 Цикл
		
		Идентификатор = ЮТест.Данные().СлучайныйИдентификатор(Инд);
		
		ЮТест.ОжидаетЧто(Проверка)
			.Метод("Вставить").Параметр(Идентификатор)
			.НеВыбрасываетИсключение( , "Сформирован не валидный идентификатор: " + Идентификатор);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗагрузитьИзМакета_ТабличныйДокумент() Экспорт
	
	// Подготовка тестового окружения
	
	ОписанияТипов = Новый Соответствие;
	ОписанияТипов.Вставить("Период", Новый ОписаниеТипов("Дата"));
	ОписанияТипов.Вставить("Товар", Новый ОписаниеТипов("СправочникСсылка.Товары"));
	ОписанияТипов.Вставить("Цена", Новый ОписаниеТипов("Число"));
	ОписанияТипов.Вставить("Количество", Новый ОписаниеТипов("Число"));
	
	КэшЗначений = Неопределено;
	
	Поставщик = ЮТест.Данные().СоздатьЭлемент("Справочники.Контрагенты", "Поставщик");
	
	ЗаменяемыеЗначения = Новый Соответствие;
	ЗаменяемыеЗначения.Вставить("Поставщик 1", Поставщик);
	
	ТаблицаРезультатов = ЮТест.Данные().ЗагрузитьИзМакета("ОбщийМакет.ЮТ_МакетТестовыхДанных.R2C1:R5C11",
														  ОписанияТипов,
														  КэшЗначений,
														  ЗаменяемыеЗначения);
	
	// Проверка поведения и результатов
	
#Если Сервер Тогда
	Ютест.ОжидаетЧто(ТаблицаРезультатов)
		.ИмеетТип("ТаблицаЗначений")
		.ИмеетДлину(3)
		.Свойство("[0].Товар.Поставщик").Равно(Поставщик)
		.Свойство("[0].Товар.Артикул").Равно("Артикул 1")
		.Свойство("[0].Товар.Вид").Равно(ПредопределенноеЗначение("Перечисление.ВидыТоваров.Товар"))
		.Свойство("[0].Товар.Описание").Заполнено()
		.Свойство("[0].Количество").Равно(1)
		.Свойство("[0].Цена").Равно(100.55)
		.Свойство("[1].Товар.Поставщик").Заполнено().НеРавно(Поставщик)
		.Свойство("[1].Товар.Артикул").Равно("Артикул 2")
		.Свойство("[1].Товар.Вид").Равно(ПредопределенноеЗначение("Перечисление.ВидыТоваров.Товар"))
		.Свойство("[1].Товар.Описание").НеЗаполнено()
		.Свойство("[1].Количество").Равно(1)
		.Свойство("[1].Цена").Равно(1500.2)
		.Свойство("[2].Товар.Поставщик").НеЗаполнено()
		.Свойство("[2].Товар.Артикул").Равно("Артикул 3")
		.Свойство("[2].Товар.Вид").Равно(ПредопределенноеЗначение("Перечисление.ВидыТоваров.Услуга"))
		.Свойство("[2].Товар.Описание").Заполнено()
		.Свойство("[2].Количество").Равно(1)
		.Свойство("[2].Цена").Равно(1000000)
		;
#Иначе
	Ютест.ОжидаетЧто(ТаблицаРезультатов)
		.ИмеетТип("Массив")
		.ИмеетДлину(3)
		.КаждыйЭлементСоответствуетПредикату(ЮТест.Предикат()
			.Реквизит("Товар").Заполнено().ИмеетТип("СправочникСсылка.Товары")
			.Реквизит("Период").Заполнено().ИмеетТип("Дата")
			.Реквизит("Количество").Заполнено().ИмеетТип("Число")
			.Реквизит("Цена").Заполнено().ИмеетТип("Число")
		)
		.Свойство("[0].Количество").Равно(1)
		.Свойство("[0].Цена").Равно(100.55)
		.Свойство("[1].Количество").Равно(1)
		.Свойство("[1].Цена").Равно(1500.2)
		.Свойство("[2].Количество").Равно(1)
		.Свойство("[2].Цена").Равно(1000000)
		;
#КонецЕсли
	
КонецПроцедуры

Процедура ЗагрузитьИзМакета_MarkDown() Экспорт
	
	ИмяМакета = "ОбщийМакет.ЮТ_ТестовыеДанныеMarkdown";
	Макет = ЮТОбщий.Макет(ИмяМакета);
	
	Варианты = ЮТест.Варианты("Данные, Описание")
		.Добавить(ИмяМакета, "По имени макета")
		.Добавить(Макет, "Из текстового документа")
		.Добавить(Макет.ПолучитьТекст(), "Из строки")
		;
	
	Для Каждого Вариант Из Варианты.СписокВариантов() Цикл
		
		ОписанияТипов = Новый Соответствие;
		ОписанияТипов.Вставить("Товар", Новый ОписаниеТипов("СправочникСсылка.Товары"));
		ОписанияТипов.Вставить("Цена", Новый ОписаниеТипов("Число"));
		ОписанияТипов.Вставить("Количество", Новый ОписаниеТипов("Число"));
		ОписанияТипов.Вставить("Сумма", Новый ОписаниеТипов("Число"));
		
		// Вызов тестируемого сценария
		
		ТаблицаРезультатов = ЮТест.Данные().ЗагрузитьИзМакета(Вариант.Данные, ОписанияТипов);
		
		// Проверка поведения и результатов
		
#Если Сервер Тогда
		Ютест.ОжидаетЧто(ТаблицаРезультатов, Вариант.Описание)
			.ИмеетТип("ТаблицаЗначений")
			.ИмеетДлину(3)
			.Свойство("[0].Товар.Наименование").Равно("Товар 1")
			.Свойство("[0].Количество").Равно(1)
			.Свойство("[0].Цена").Равно(100)
			.Свойство("[0].Сумма").Равно(100)
			.Свойство("[1].Товар.Наименование").Равно("Товар 2")
			.Свойство("[1].Количество").Равно(1)
			.Свойство("[1].Цена").Равно(2000)
			.Свойство("[1].Сумма").Равно(2000)
			.Свойство("[2].Товар.Наименование").Равно("Услуга")
			.Свойство("[2].Количество").Равно(1)
			.Свойство("[2].Цена").Равно(300.9)
			.Свойство("[2].Сумма").Равно(300.9)
		;
#Иначе
		Ютест.ОжидаетЧто(ТаблицаРезультатов, Вариант.Описание)
			.ИмеетТип("Массив")
			.ИмеетДлину(3)
			.КаждыйЭлементСоответствуетПредикату(ЮТест.Предикат()
				.Реквизит("Товар").Заполнено().ИмеетТип("СправочникСсылка.Товары")
				.Реквизит("Количество").Равно(1)
				.Реквизит("Цена").Заполнено().ИмеетТип("Число")
				.Реквизит("Сумма").Заполнено().ИмеетТип("Число"))
			.Свойство("[0].Количество").Равно(1)
			.Свойство("[0].Цена").Равно(100)
			.Свойство("[0].Сумма").Равно(100)
			.Свойство("[1].Цена").Равно(2000)
			.Свойство("[1].Сумма").Равно(2000)
			.Свойство("[2].Цена").Равно(300.9)
			.Свойство("[2].Сумма").Равно(300.9)
		;
#КонецЕсли
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗагрузитьИзМакета_ЧастичнаяЗагрузкаДанных() Экспорт
	
	ОписанияТипов = Новый Структура;
	ОписанияТипов.Вставить("Период", Новый ОписаниеТипов("Дата"));
	ОписанияТипов.Вставить("Количество", Новый ОписаниеТипов("Число"));
	
	ТаблицаРезультатов = ЮТест.Данные().ЗагрузитьИзМакета("ОбщийМакет.ЮТ_МакетТестовыхДанных.R2C1:R5C11", ОписанияТипов);
	
#Если Сервер Тогда
	Ютест.ОжидаетЧто(ТаблицаРезультатов)
		.ИмеетДлину(3)
		.Свойство("Колонки").ИмеетДлину(2)
		.Содержит("Период")
		.Содержит("Количество")
	;
#Иначе
	Ютест.ОжидаетЧто(ТаблицаРезультатов)
		.ИмеетТип("Массив")
		.ИмеетДлину(3)
		.КаждыйЭлементСоответствуетПредикату(ЮТест.Предикат()
			.ИмеетДлину(2)
			.ИмеетСвойство("Период")
			.ИмеетСвойство("Количество"))
	;
#КонецЕсли
КонецПроцедуры

Процедура ЗагрузитьИзМакета_Проверки() Экспорт
	
	ЮТест.ОжидаетЧто(ЮТест.Данные())
		.Метод("ЗагрузитьИзМакета")
			.Параметр(Неопределено)
			.Параметр(Новый Массив)
		.ВыбрасываетИсключение("Укажите источник данных (Макет)");
	
	ЮТест.ОжидаетЧто(ЮТест.Данные())
		.Метод("ЗагрузитьИзМакета")
			.Параметр("ОбщийМакет.ЮТ_ТестовыеДанныеMarkdown")
			.Параметр(Новый Массив)
		.ВыбрасываетИсключение("Укажите описание загружаемых колонок (ОписанияТипов)");
	
	ОжидаемоеСообщение = СтрШаблон("Некорректный тип параметра `ОписанияТипов` метода `ЮТТестовыеДанные.ЗагрузитьИзМакета`. Метод принимает `%1, %2`, а получили `%3` (1)",
								   Тип("Соответствие"),
								   Тип("Структура"),
								   Тип("Число"));
	ЮТест.ОжидаетЧто(ЮТест.Данные())
		.Метод("ЗагрузитьИзМакета")
			.Параметр("ОбщийМакет.ЮТ_ТестовыеДанныеMarkdown")
			.Параметр(1)
		.ВыбрасываетИсключение(ОжидаемоеСообщение);
	
	ЮТест.ОжидаетЧто(ЮТест.Данные())
		.Метод("ЗагрузитьИзМакета")
			.Параметр("ОбщийМакет.ЮТ_ТестовыеДанныеMarkdown")
			.Параметр(Новый Структура("Количество, Резерв", Новый ОписаниеТипов("Число"), Новый ОписаниеТипов("Число")))
		.ВыбрасываетИсключение("Макет не содержит колонку `Резерв`");
	
	ЮТест.ОжидаетЧто(ЮТест.Данные())
		.Метод("ЗагрузитьИзМакета")
			.Параметр("ОбщийМакет.ЮТ_ТестовыеДанныеMarkdown")
			.Параметр(Новый Структура("Количество, Резерв", Новый ОписаниеТипов("Число"), Новый ОписаниеТипов("Число")))
		.ВыбрасываетИсключение("Макет не содержит колонку `Резерв`");
	
	ЮТест.ОжидаетЧто(ЮТест.Данные())
		.Метод("ЗагрузитьИзМакета")
			.Параметр("ОбщийМакет.ЮТ_МакетТестовыхДанных.R2C4:R5C5")
			.Параметр(Новый Структура("Товар", Новый ОписаниеТипов("СправочникСсылка.Товары")))
		.ВыбрасываетИсключение("не найдена в макете основная колонка с именем `Товар`");
	
	ОжидаемоеСообщение = ?(ЮТОкружение.ИспользуетсяАнглийскаяЛокальПлатформы(), "Section not found", "Область не найдена");
	ЮТест.ОжидаетЧто(ЮТест.Данные())
		.Метод("ЗагрузитьИзМакета")
			.Параметр("ОбщийМакет.ЮТ_МакетТестовыхДанных.ОсновнаяТаблица")
			.Параметр(Новый Структура("Цена", Новый ОписаниеТипов("Дата")))
		.ВыбрасываетИсключение(ОжидаемоеСообщение + ": ОсновнаяТаблица");
	
КонецПроцедуры

Процедура ЗагрузитьИзМакета_ЦепочкаЗагрузок() Экспорт
	
	ОписанияТипов = Новый Соответствие;
	ОписанияТипов.Вставить("Период", Новый ОписаниеТипов("Дата"));
	ОписанияТипов.Вставить("Товар", Новый ОписаниеТипов("СправочникСсылка.Товары"));
	ОписанияТипов.Вставить("Цена", Новый ОписаниеТипов("Число"));
	ОписанияТипов.Вставить("Количество", Новый ОписаниеТипов("Число"));
	
	КэшЗначений = Неопределено;
	
	ТаблицаРезультатов = ЮТест.Данные().ЗагрузитьИзМакета("ОбщийМакет.ЮТ_МакетТестовыхДанных.R2C1:R5C11",
														  ОписанияТипов,
														  КэшЗначений);
	
	ОписанияТипов = Новый Соответствие;
	ОписанияТипов.Вставить("Период", Новый ОписаниеТипов("Дата"));
	ОписанияТипов.Вставить("Активность", Новый ОписаниеТипов("Булево"));
	ОписанияТипов.Вставить("Товар", Новый ОписаниеТипов("СправочникСсылка.Товары"));
	ОписанияТипов.Вставить("Цена", Новый ОписаниеТипов("Число"));
	ОписанияТипов.Вставить("Количество", Новый ОписаниеТипов("Число"));
	ОписанияТипов.Вставить("Сумма", Новый ОписаниеТипов("Число"));
	
	ОжидаемыеЗначения = ЮТест.Данные().ЗагрузитьИзМакета("ОбщийМакет.ЮТ_МакетТестовыхДанных.R8C1:R11C6",
														 ОписанияТипов,
														 КэшЗначений);
	
	ЮТест.ОжидаетЧто(КэшЗначений).НеРавно(Неопределено);
	
	Для Каждого Строка Из ТаблицаРезультатов Цикл
		
		ЮТест.ОжидаетЧто(ОжидаемыеЗначения)
			.Содержит(ЮТест.Предикат().Реквизит("Товар").Равно(Строка.Товар));
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗагрузитьИзМакета_ОбменДаннымиЗагрузка() Экспорт
	
	ОписанияТипов = Новый Соответствие;
	ОписанияТипов.Вставить("Счет", Новый ОписаниеТипов("СправочникСсылка.РасчетныеСчета"));
	
	ПараметрыСозданияОбъектов = ЮТФабрика.ПараметрыСозданияОбъектов();
	ПараметрыСозданияОбъектов.ПараметрыЗаписи.ОбменДаннымиЗагрузка = Истина;
	
	Параметры = ЮТКоллекции.ЗначениеВМассиве("ОбщийМакет.ЮТ_МакетТестовыхДанных.R14C1:R16C3", ОписанияТипов, Неопределено, Неопределено, ПараметрыСозданияОбъектов);
	ЮТест.ОжидаетЧто(ЮТест.Данные())
		.Метод("ЗагрузитьИзМакета", Параметры)
		.НеВыбрасываетИсключение();
	
	ТекстСообщения = ЮТСтроки.ЛокализованноеСообщениеПлатформы("ru = 'не заполнено или заполнено неверно'; en = 'is blank or has an invalid value'");
	ЮТест.ОжидаетЧто(ЮТест.Данные())
		.Метод("ЗагрузитьИзМакета").Параметр("ОбщийМакет.ЮТ_МакетТестовыхДанных.R14C1:R16C3").Параметр(ОписанияТипов)
		.ВыбрасываетИсключение(ТекстСообщения);
	
КонецПроцедуры

Процедура СлучайноеЗначениеПеречисления() Экспорт
	
	Варианты = ЮТест.Варианты("Перечисление, Описание")
		.Добавить("Перечисление.PushУведомления", "По имени")
		.Добавить("Перечисления.PushУведомления", "По имени коллекции");
#Если Сервер Тогда
	Варианты.Добавить(Перечисления.PushУведомления, "Через менеджер");
#КонецЕсли
	
	Для Каждого Вариант Из Варианты.СписокВариантов() Цикл
		
		ЮТест.ОжидаетЧто(ЮТест.Данные().СлучайноеЗначениеПеречисления(Вариант.Перечисление))
			.Заполнено()
			.ИмеетТип("ПеречислениеСсылка.PushУведомления");
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьЗначениеРеквизита() Экспорт
	
	Контрагент = ЮТест.Данные().СоздатьЭлемент("Справочники.Контрагенты");
	
	ЮТест.ОжидаетЧТо(ЮТЗапросы.ЗначениеРеквизита(Контрагент, "Индекс"))
		.НеЗаполнено();
	
	Индекс = ЮТест.Данные().СлучайнаяСтрока();
	ЮТест.Данные().УстановитьЗначениеРеквизита(Контрагент, "Индекс", Индекс);
	
	ЮТест.ОжидаетЧто(ЮТЗапросы.ЗначениеРеквизита(Контрагент, "Индекс"))
		.Заполнено()
		.Равно(Индекс);
	
КонецПроцедуры

Процедура СлучайноеОтрицательноеЧисло() Экспорт
	
	ЮТест.ОжидаетЧто(ЮТест.Данные().СлучайноеОтрицательноеЧисло())
		.ИмеетТип("Число")
		.Меньше(0);
	
КонецПроцедуры

Процедура СлучайныйНомерТелефона() Экспорт
	
	ЮТест.ОжидаетЧто(ЮТест.Данные().СлучайныйНомерТелефона())
		.ИмеетТип("Строка")
		.ИмеетДлину(16)
		;
	
	ЮТест.ОжидаетЧто(ЮТест.Данные().СлучайныйНомерТелефона("997"))
		.ИмеетТип("Строка")
		.ИмеетДлину(18)
		.НачинаетсяС("+997")
		;
	
КонецПроцедуры

Процедура Фикция(ТипЗначения) Экспорт
	
	Значение = ЮТест.Данные().Фикция(ТипЗначения);
	
	ЮТест.ОжидаетЧто(Значение)
		.Заполнено()
		.ИмеетТип(ТипЗначения);
	
КонецПроцедуры

Процедура СлучайноеПредопределенноеЗначение() Экспорт
	
	ОжидаемоеЗначение = ПредопределенноеЗначение("Справочник.ВидыЦен.Закупочная");
	Значение = ЮТест.Данные().СлучайноеПредопределенноеЗначение("Справочники.ВидыЦен");
	ЮТест.ОжидаетЧто(Значение).Равно(ОжидаемоеЗначение);
	
	Значение = ЮТест.Данные().СлучайноеПредопределенноеЗначение("Справочники.ВидыЦен", Новый Структура("ПометкаУдаления", Ложь));
	ЮТест.ОжидаетЧто(Значение).Равно(ОжидаемоеЗначение);
	
	Значение = ЮТест.Данные().СлучайноеПредопределенноеЗначение("Справочники.ВидыЦен", Новый Структура("ПометкаУдаления", Истина));
	ЮТест.ОжидаетЧто(Значение).Равно(Неопределено);
	
КонецПроцедуры

Процедура СлучайнаяДата() Экспорт
	
	Варианты = ЮТест.Варианты("Начало, Окончание")
		.Добавить('20000101', '20000101')
		.Добавить('20000101', '20000102')
		.Добавить('20000101', '20000101235959')
		.Добавить('20000101', '20000101010000')
		.Добавить('20000101', '20000101000001');
	
	Для Каждого Вариант Из Варианты.СписокВариантов() Цикл
		
		Результат = ЮТТестовыеДанные.СлучайнаяДата(Вариант.Начало, Вариант.Окончание);
		
		ЮТест.ОжидаетЧто(Результат)
			.ИмеетТип("Дата")
			.МеждуВключаяГраницы(Вариант.Начало, Вариант.Окончание);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СлучайноеВремя() Экспорт
	
	Для Инд = 1 По 50 Цикл
		
		Результат = ЮТТестовыеДанные.СлучайноеВремя();
		
		ЮТест.ОжидаетЧто(Результат)
			.ИмеетТип("Дата")
			.МеждуВключаяГраницы('00010101000000', '00010101235959');
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СлучайнаяДатаПосле() Экспорт
	
	Варианты = ЮТест.Варианты("Начало, Интервал, ТипИнтервала, Максимум")
		.Добавить('20000101', 1, "час", '20000101010000')
		.Добавить('20000101', 7, "дней", '20000108')
		.Добавить('20000101', 12, "месяцев", '20010101')
		.Добавить('20000101', 3, "секунды", '20000101000003')
		.Добавить('20000101', Неопределено, Неопределено, '39991231');
	
	Для Каждого Вариант Из Варианты.СписокВариантов() Цикл
		
		Результат = ЮТТестовыеДанные.СлучайнаяДатаПосле(Вариант.Начало, Вариант.Интервал, Вариант.ТипИнтервала);
		
		ЮТест.ОжидаетЧто(Результат)
			.ИмеетТип("Дата")
			.МеждуВключаяОкончаниеГраницы(Вариант.Начало, Вариант.Максимум);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СлучайнаяДатаДо() Экспорт
	
	Варианты = ЮТест.Варианты("Дата, Интервал, ТипИнтервала, Минимум")
		.Добавить('20010101', 1, "час", '20001231230000')
		.Добавить('20010101', 7, "дней", '20001225')
		.Добавить('20010101', 12, "месяцев", '20000101')
		.Добавить('20010101', 3, "секунды", '20001231235957')
		.Добавить('20010101', Неопределено, Неопределено, '00010101');
	
	Для Каждого Вариант Из Варианты.СписокВариантов() Цикл
		
		Результат = ЮТТестовыеДанные.СлучайнаяДатаДо(Вариант.Дата, Вариант.Интервал, Вариант.ТипИнтервала);
		
		ЮТест.ОжидаетЧто(Результат)
			.ИмеетТип("Дата")
			.МеждуВключаяНачалоГраницы(Вариант.Минимум, Вариант.Дата);
		
	КонецЦикла;
	
КонецПроцедуры

#Если Сервер Тогда
Процедура УстановитьФоновуюБлокировку() Экспорт
	
	Валюта = ЮТест.Данные().СоздатьЭлемент(Справочники.Валюты);
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("РегистрСведений.КурсыВалют")
		.Установить("Валюта", Валюта)
		.Фикция("Период")
		.Фикция("Курс");
	
	Блокировка = Новый БлокировкаДанных();
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.КурсыВалют");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Валюта", Валюта);
	
	ЮТест.Данные().УстановитьФоновуюБлокировку(Блокировка);
	
	ОжидаемаяОшибка = ?(ЮТОкружение.ИспользуетсяАнглийскаяЛокальПлатформы(),
		"Lock conflict during the transaction", 
		"Конфликт блокировок при выполнении транзакции");
	
	ЮТест.ОжидаетЧто(Конструктор)
		.Метод("Записать")
		.ВыбрасываетИсключение(ОжидаемаяОшибка);
	
КонецПроцедуры
#КонецЕсли

#КонецОбласти
