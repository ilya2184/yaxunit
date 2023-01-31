//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2023 BIA-Technologies Limited Liability Company
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

/////////////////////////////////////////////////////////////////////////////////
// Экспортные процедуры и функции, предназначенные для использования другими 
// объектами конфигурации или другими программами
///////////////////////////////////////////////////////////////////////////////// 
#Область ПрограммныйИнтерфейс

#Если Клиент Тогда

// ВыполнитьМодульноеТестирование
//  Метод, по параметрам запуска, запускает выполнение всего процесса тестирования.
// 
// Параметры:
//  Параметры - См. ЮТФабрика.ПараметрыЗапуска
Процедура ВыполнитьМодульноеТестирование(Параметры = Неопределено) Экспорт
	
	Если Параметры = Неопределено Тогда
		Параметры = ЮТПараметры.ПараметрыЗапуска(ПараметрЗапуска);
	КонецЕсли;
	
	Если НЕ Параметры.ВыполнятьМодульноеТестирование Тогда
		Возврат;
	КонецЕсли;
	
	ЮТКонтекст.ИнициализироватьКонтекст();
	ЮТКонтекст.УстановитьГлобальныеНастройкиВыполнения(Параметры.settings);
	ЮТСобытия.Инициализация(Параметры);
	// Повторно сохраним для передачи на сервер
	ЮТКонтекст.УстановитьГлобальныеНастройкиВыполнения(ЮТКонтекст.ГлобальныеНастройкиВыполнения());
	ЮТКонтекст.УстановитьКонтекстИсполнения(ДанныеКонтекстаИсполнения());
	
	ЮТСобытия.ПередЧтениеСценариев();
	ТестовыеМодули = ЮТЧитатель.ЗагрузитьТесты(Параметры);
	ЮТСобытия.ПослеЧтенияСценариев(ТестовыеМодули);
	
	РезультатыТестирования = Новый Массив();
	
	КоллекцияКатегорийНаборов = Новый Массив();
	Для Каждого ТестовыйМодуль Из ТестовыеМодули Цикл
		
		КатегорииНаборов = КатегорииНаборовТестовМодуля(ТестовыйМодуль);
		КоллекцияКатегорийНаборов.Добавить(КатегорииНаборов);
		
	КонецЦикла;
	
	ЮТСобытия.ПослеФормированияИсполняемыхНаборовТестов(КоллекцияКатегорийНаборов);
	
	Для Каждого КатегорииНаборов Из КоллекцияКатегорийНаборов Цикл
		
		Результат = ВыполнитьГруппуНаборовТестов(КатегорииНаборов.Клиентские, КатегорииНаборов.ТестовыйМодуль);
		ЮТОбщий.ДополнитьМассив(РезультатыТестирования, Результат);
		
		Результат = ЮТИсполнительСервер.ВыполнитьГруппуНаборовТестов(КатегорииНаборов.Серверные, КатегорииНаборов.ТестовыйМодуль);
		ЮТЛогирование.ВывестиСерверныеСообщения();
		
		ЮТОбщий.ДополнитьМассив(РезультатыТестирования, Результат);
		
		ЮТОбщий.ДополнитьМассив(РезультатыТестирования, КатегорииНаборов.Пропущенные);
		
	КонецЦикла;
	
	ЮТОтчет.СформироватьОтчет(РезультатыТестирования, Параметры);
	
	Если Параметры.showReport Тогда
		ПоказатьОтчет(РезультатыТестирования, Параметры);
	ИначеЕсли Параметры.CloseAfterTests Тогда
		ПрекратитьРаботуСистемы(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли

#КонецОбласти

/////////////////////////////////////////////////////////////////////////////////
// Экспортные процедуры и функции для служебного использования внутри подсистемы
///////////////////////////////////////////////////////////////////////////////// 

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет тесты группы наборов, соответствующих одному режиму выполнения (клиент/сервер) 
// Параметры:
//  Наборы - Массив из см. ЮТФабрика.ОписаниеИсполняемогоНабораТестов 
//  ТестовыйМодуль - см. ЮТФабрика.ОписаниеТестовогоМодуля
// 
// Возвращаемое значение:
//  Массив из см. ЮТФабрика.ОписаниеИсполняемогоНабораТестов - Результат прогона наборов тестов с заполненной информацией о выполнении
Функция ВыполнитьГруппуНаборовТестов(Наборы, ТестовыйМодуль) Экспорт
	
	Если Наборы.Количество() = 0 Тогда
		Возврат Наборы;
	КонецЕсли;
	
	Уровни = ЮТФабрика.УровниИсполнения();
	ЮТКонтекст.КонтекстИсполнения().Уровень = Уровни.Модуль;
	
	ЮТСобытия.ПередВсемиТестамиМодуля(ТестовыйМодуль);
	
	Если ЕстьОшибки(ТестовыйМодуль) Тогда
		СкопироватьОшибкиВ(Наборы, ТестовыйМодуль.Ошибки);
		Возврат Наборы;
	КонецЕсли;
	
	Для Каждого Набор Из Наборы Цикл
		
		Результат = ВыполнитьНаборТестов(Набор, ТестовыйМодуль);
		
		Если Результат <> Неопределено Тогда
			Набор.Тесты = Результат;
		КонецЕсли;
		
	КонецЦикла;
	
	ЮТКонтекст.КонтекстИсполнения().Уровень = Уровни.Модуль;
	
	ЮТСобытия.ПослеВсехТестовМодуля(ТестовыйМодуль);
	
	Если ЕстьОшибки(ТестовыйМодуль) Тогда
		СкопироватьОшибкиВ(Наборы, ТестовыйМодуль.Ошибки);
	КонецЕсли;
	
	ТестовыйМодуль.Ошибки.Очистить(); // Эти ошибки используются как буфер и уже скопированы в наборы, но ломают последующие наборы
	
	Возврат Наборы;
	
КонецФункции

#КонецОбласти

/////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции, составляющие внутреннюю реализацию модуля 
///////////////////////////////////////////////////////////////////////////////// 

#Область СлужебныеПроцедурыИФункции

Функция ВыполнитьНаборТестов(Набор, ТестовыйМодуль)
	
	Уровни = ЮТФабрика.УровниИсполнения();
	ЮТКонтекст.КонтекстИсполнения().Уровень = Уровни.НаборТестов;
	
	Набор.ДатаСтарта = ТекущаяУниверсальнаяДатаВМиллисекундах();
	ЮТСобытия.ПередТестовымНабором(ТестовыйМодуль, Набор);
	
	Если ЕстьОшибки(Набор) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результаты = Новый Массив();
	ЮТКонтекст.КонтекстИсполнения().Уровень = Уровни.Тест;
	
	Для Каждого Тест Из Набор.Тесты Цикл
		
		Тест.ДатаСтарта = ТекущаяУниверсальнаяДатаВМиллисекундах();
		
		ЮТСобытия.ПередКаждымТестом(ТестовыйМодуль, Набор, Тест);
		ВыполнитьТестовыйМетод(Тест);
		ЮТСобытия.ПослеКаждогоТеста(ТестовыйМодуль, Набор, Тест);
		
		ОбработатьЗавершениеТеста(Тест);
		
		Результаты.Добавить(Тест);
		
	КонецЦикла;
	
	ЮТКонтекст.КонтекстИсполнения().Уровень = Уровни.НаборТестов;
	ЮТСобытия.ПослеТестовогоНабора(ТестовыйМодуль, Набор);
	
	Набор.Длительность = ТекущаяУниверсальнаяДатаВМиллисекундах() - Набор.ДатаСтарта;
		
	Возврат Результаты;
	
КонецФункции

Процедура ОбработатьЗавершениеТеста(Тест)
	
	Тест.Длительность = ТекущаяУниверсальнаяДатаВМиллисекундах() - Тест.ДатаСтарта;
	Тест.Статус = ЮТРегистрацияОшибок.СтатусВыполненияТеста(Тест);
	
КонецПроцедуры

Функция КатегорииНаборовТестовМодуля(ТестовыйМодуль)
	
	КатегорииНаборов = ОписаниеКатегорияНабораТестов(ТестовыйМодуль);
	
	ИсполняемыеТестовыеНаборы = Новый Массив;
	
	Для Каждого ТестовыйНабор Из ТестовыйМодуль.НаборыТестов Цикл
		
		НаборыКонтекстов = Новый Структура;
		
		ТестыНабора = ЮТОбщий.ЗначениеСтруктуры(ТестовыйНабор, "Тесты", Новый Массив());
		
		Для Каждого Тест Из ТестыНабора Цикл
			
			Для Каждого Контекст Из Тест.КонтекстВызова Цикл
				
				Если НЕ НаборыКонтекстов.Свойство(Контекст) Тогда
					ИсполняемыйНабор = ЮТФабрика.ОписаниеИсполняемогоНабораТестов(ТестовыйНабор, ТестовыйМодуль);
					ИсполняемыйНабор.Режим = Контекст;
					НаборыКонтекстов.Вставить(Контекст, ИсполняемыйНабор);
				Иначе
					ИсполняемыйНабор = НаборыКонтекстов[Контекст];
				КонецЕсли;
				
				ИсполняемыйТест = ЮТФабрика.ОписаниеИсполняемогоТеста(Тест, Контекст, ТестовыйМодуль);
				ИсполняемыйНабор.Тесты.Добавить(ИсполняемыйТест);
				
			КонецЦикла;
			
		КонецЦикла;
		
		Если НаборыКонтекстов.Количество() Тогда
			
			Для Каждого Элемент Из НаборыКонтекстов Цикл
				ИсполняемыеТестовыеНаборы.Добавить(Элемент.Значение);
			КонецЦикла;
			
		Иначе
			
			// TODO. Корякин А. 2021.11.24 А надо ли добавлять при отсутствии тестов
			ИсполняемыеТестовыеНаборы.Добавить(ЮТФабрика.ОписаниеИсполняемогоНабораТестов(ТестовыйНабор, ТестовыйМодуль));
			
		КонецЕсли;
		
	КонецЦикла;
	
	КонтекстыПриложения = ЮТФабрика.КонтекстыПриложения();
	КонтекстыМодуля = ЮТФабрика.КонтекстыМодуля(ТестовыйМодуль.МетаданныеМодуля);
	КонтекстыИсполнения = ЮТФабрика.КонтекстыИсполнения();
	
	Для Каждого Набор Из ИсполняемыеТестовыеНаборы Цикл
		
		КонтекстИсполнения = ЮТФабрика.КонтекстИсполнения(Набор.Режим);
		
		ОшибкаКонтекста = Неопределено;
		Если КонтекстыПриложения.Найти(Набор.Режим) = Неопределено Тогда
			ОшибкаКонтекста = "Неподдерживаемый режим запуска";
		ИначеЕсли КонтекстыМодуля.Найти(Набор.Режим) = Неопределено Тогда
			ОшибкаКонтекста = "Модуль не доступен в этом контексте";
		ИначеЕсли КонтекстИсполнения <> КонтекстыИсполнения.Сервер И КонтекстИсполнения <> КонтекстыИсполнения.Клиент Тогда
			ОшибкаКонтекста = "Неизвестный контекст/режим исполнения";
		КонецЕсли;
		
		Если ОшибкаКонтекста <> Неопределено Тогда
			Набор.Выполнять = Ложь;
			ЮТРегистрацияОшибок.ЗарегистрироватьОшибкуРежимаВыполнения(Набор, ОшибкаКонтекста);
			Для Каждого Тест Из Набор.Тесты Цикл
				ЮТРегистрацияОшибок.ЗарегистрироватьОшибкуРежимаВыполнения(Тест, ОшибкаКонтекста);
			КонецЦикла;
		КонецЕсли;
		
		Если НЕ Набор.Выполнять Тогда
			КатегорииНаборов.Пропущенные.Добавить(Набор);
			Продолжить;
		КонецЕсли;
		
		Если КонтекстИсполнения = КонтекстыИсполнения.Сервер Тогда
			
			КатегорииНаборов.Серверные.Добавить(Набор);
			
		ИначеЕсли КонтекстИсполнения = КонтекстыИсполнения.Клиент Тогда
			
			КатегорииНаборов.Клиентские.Добавить(Набор);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КатегорииНаборов;
	
КонецФункции

Функция ЕстьОшибки(Объект)
	Возврат ЗначениеЗаполнено(Объект.Ошибки);
КонецФункции

Процедура ВыполнитьТестовыйМетод(Тест)
	
	Если ЕстьОшибки(Тест) Тогда
		Возврат;
	КонецЕсли;
	
	СтатусыИсполненияТеста = ЮТФабрика.СтатусыИсполненияТеста();
	Тест.Статус = СтатусыИсполненияТеста.Исполнение;
	
	Ошибка = ЮТОбщий.ВыполнитьМетод(Тест.ПолноеИмяМетода, Тест.Параметры);
	
	Если Ошибка <> Неопределено Тогда
		ЮТРегистрацияОшибок.ЗарегистрироватьОшибкуВыполненияТеста(Тест, Ошибка);
	КонецЕсли;
	
КонецПроцедуры

Процедура СкопироватьОшибкиВ(Объекты, Ошибки)
	
	Для Каждого Объект Из Объекты Цикл
		
		ЮТОбщий.ДополнитьМассив(Объект.Ошибки, Ошибки);
		
		Если Объект.Свойство("Статус") Тогда
			Объект.Статус = ЮТФабрика.СтатусыИсполненияТеста().Сломан;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Данные контекста исполнения.
// 
// Возвращаемое значение:
//  Структура - Данные контекста исполнения:
//  * Уровень - Строка
Функция ДанныеКонтекстаИсполнения()
	
	Контекст = Новый Структура();
	Контекст.Вставить("Уровень", "");
	
	Возврат Контекст;
	
КонецФункции

// Описание категория набора тестов.
// 
// Параметры:
//  ТестовыйМодуль - см. ЮТФабрика.ОписаниеТестовогоМодуля
// 
// Возвращаемое значение:
//  Структура - Описание категория набора тестов:
// * ТестовыйМодуль - см. ЮТФабрика.ОписаниеТестовогоМодуля
// * Клиентские - Массив из ЮТФабрика.ОписаниеИсполняемогоНабораТестов
// * Серверные - Массив из ЮТФабрика.ОписаниеИсполняемогоНабораТестов
// * Пропущенные - Массив из ЮТФабрика.ОписаниеИсполняемогоНабораТестов
Функция ОписаниеКатегорияНабораТестов(ТестовыйМодуль)
	
	КатегорииНаборов = Новый Структура();
	КатегорииНаборов.Вставить("ТестовыйМодуль",  ТестовыйМодуль);
	КатегорииНаборов.Вставить("Клиентские",  Новый Массив());
	КатегорииНаборов.Вставить("Серверные",   Новый Массив());
	КатегорииНаборов.Вставить("Пропущенные", Новый Массив());
	
	Возврат КатегорииНаборов;
	
КонецФункции

#Если Клиент Тогда
Процедура ПоказатьОтчет(РезультатыТестирования, Параметры)
	
	Данные = Новый Структура("РезультатыТестирования, ПараметрыЗапуска", РезультатыТестирования, Параметры);
	АдресДанных = ПоместитьВоВременноеХранилище(Данные);
	
	ОткрытьФорму("Обработка.ЮТЮнитТесты.Форма.Основная", Новый Структура("АдресХранилища", АдресДанных));
	
КонецПроцедуры
#КонецЕсли

#КонецОбласти
