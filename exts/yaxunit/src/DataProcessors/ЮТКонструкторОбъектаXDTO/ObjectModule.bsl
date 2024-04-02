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

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда

#Область ОписаниеПеременных

Перем ТекущийОбъект;
Перем ТекущийТип;
Перем СтекОбъектов;
Перем Фабрика;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Устанавливает значение реквизита объекта.
// 
// Параметры:
//  ИмяРеквизита - Строка - Имя реквизита объекта
//  Значение - Произвольный - Значение реквизита объекта
// 
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТКонструкторОбъектаXDTO - Конструктор
Функция Установить(ИмяРеквизита, Значение) Экспорт
	
	ТекущийОбъект[ИмяРеквизита] = Значение;
	
	Возврат ЭтотОбъект;
	
КонецФункции

// Устанавливает значения реквизитов объекта.
// 
// Параметры:
//  ЗначенияРеквизитов - Структура - Устанавливаемые значения реквизитов
// 
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТКонструкторОбъектаXDTO - Конструктор
Функция УстановитьРеквизиты(ЗначенияРеквизитов) Экспорт
	
	Для Каждого ЗначениеРеквизита Из ЗначенияРеквизитов Цикл
		ТекущийОбъект[ЗначениеРеквизита.Ключ] = ЗначениеРеквизита.Значение;
	КонецЦикла;
	
	Возврат ЭтотОбъект;
	
КонецФункции

// Устанавливает фиктивное значение реквизита объекта.
// 
// На основании типа реквизита генерируется фиктивное значение.
// 
// * Для примитивных значение генерируется случайное значение
// * Для объектных типов создается новый объект
// * Для коллекций - генерируется случайно количество случайных элементов (на основании типа)
// 
// Параметры:
//  ИмяРеквизита - Строка - Имя реквизита объекта
// 
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТКонструкторОбъектаXDTO - Конструктор
Функция Фикция(ИмяРеквизита) Экспорт
	
	Свойство = Свойство(ИмяРеквизита);
	Значение = СлучайноеЗначениеСвойства(Свойство, 0);
	Установить(ИмяРеквизита, Значение);
	
	Возврат ЭтотОбъект;
	
КонецФункции

// Заполняет обязательные реквизиты объекта фиктивными значениями
// 
// На основании типа объекта определяются обязательные поля.
// Для них генерируются и устанавливаются фиктивные значение.
// 
// * Для примитивных значение генерируется случайное значение
// * Для объектных типов создается новый объект
// * Для коллекций - генерируется случайно количество случайных элементов (на основании типа)
// 
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТКонструкторОбъектаXDTO - Конструктор
Функция ФикцияОбязательныхПолей() Экспорт
	
	Для Каждого Свойство Из ТекущийТип.Свойства Цикл
		
		Если НЕ Свойство.ВозможноПустое И НеЗаполнено(Свойство, ТекущийОбъект[Свойство.Имя]) Тогда
			УстановитьСлучайноеЗначениеСвойства(ТекущийОбъект, Свойство, 0);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЭтотОбъект;
	
КонецФункции

// Заполняет неустановленные реквизиты объекта фиктивными значениями
// 
// На основании типа объекта определяются обязательные поля.
// Для них генерируются и устанавливаются фиктивные значение.
// 
// * Для примитивных значение генерируется случайное значение
// * Для объектных типов создается новый объект
// * Для коллекций - генерируется случайно количество случайных элементов (на основании типа)
// 
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТКонструкторОбъектаXDTO - Конструктор
Функция ФикцияНезаполненных() Экспорт
	
	Для Каждого Свойство Из ТекущийТип.Свойства Цикл
		
		Если НеЗаполнено(Свойство, ТекущийОбъект[Свойство.Имя]) Тогда
			УстановитьСлучайноеЗначениеСвойства(ТекущийОбъект, Свойство, 0);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЭтотОбъект;
	
КонецФункции

// Возвращает основной объект XDTO
// 
// Возвращаемое значение:
//  ОбъектXDTO
Функция ДанныеОбъекта() Экспорт
	
	Возврат СтекОбъектов[0];
	
КонецФункции

// Добавляет новый объект в реквизит-коллекцию 
// 
// Параметры:
//  ИмяРеквизита - Строка - Имя реквизиты коллекции
// 
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТКонструкторОбъектаXDTO - Добавить новый
Функция ДобавитьНовый(ИмяРеквизита) Экспорт
	
	Свойство = Свойство(ИмяРеквизита);
	
	Если НЕ ЭтоТипОбъектаXDTO(Свойство.Тип) Тогда
		ВызватьИсключение СтрШаблон("Метод применяется только для свойств-объектов. Реквизит: %1 имеет тип %2", ИмяРеквизита, Свойство.Тип);
	КонецЕсли;
	
	Коллекция = ТекущийОбъект[Свойство.Имя];
	ДобавитьНовыйОбъектВСтек(Свойство.Тип);
	
	Коллекция.Добавить(ТекущийОбъект);
	
	Возврат ЭтотОбъект;
	
КонецФункции

// Переходит на уровень выше по стеку.
// 
// Возвращаемое значение:
//  ОбработкаОбъект.ЮТКонструкторОбъектаXDTO - Перейти к владельцу
Функция ПерейтиКВладельцу() Экспорт
	
	УдалитьПоследнийИзСтека();
	
	Возврат ЭтотОбъект;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура Инициализировать(ИмяТипаОбъекта, ПространствоИмен, ФабрикаОбъектов = Неопределено) Экспорт
	
	Если ФабрикаОбъектов = Неопределено Тогда
		Фабрика = ФабрикаXDTO;
	Иначе
		Фабрика = ФабрикаОбъектов;
	КонецЕсли;
	
	СтекОбъектов = Новый Массив();
	
	ТипОбъекта = Фабрика.Тип(ПространствоИмен, ИмяТипаОбъекта);
	Если ТипОбъекта = Неопределено Тогда
		ВызватьИсключение СтрШаблон("Неизвестный тип `%1`; пространство имен: `%2`", ИмяТипаОбъекта, ПространствоИмен);
	КонецЕсли;
	
	ДобавитьНовыйОбъектВСтек(ТипОбъекта);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция Свойство(ИмяСвойства)
	
	Свойство = ТекущийТип.Свойства.Получить(ИмяСвойства);
	
	Если Свойство = Неопределено Тогда
		Сообщение = СтрШаблон("Тип XDTO `%1` не содержит свойства `%2`", ТекущийТип.Имя, ИмяСвойства);
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
	Возврат Свойство;
	
КонецФункции

Процедура ДобавитьНовыйОбъектВСтек(Тип)
	
	Объект = НовыйОбъект(Тип);
	СтекОбъектов.Добавить(Объект);
	ТекущийОбъект = Объект;
	ТекущийТип = Тип;
	
КонецПроцедуры

Процедура УдалитьПоследнийИзСтека()
	
	ИндексПоследнего = СтекОбъектов.ВГраница();
	
	ТекущийОбъект = СтекОбъектов[ИндексПоследнего - 1];
	ТекущийТип = ТекущийОбъект.Тип();
	
	СтекОбъектов.Удалить(ИндексПоследнего);
	
КонецПроцедуры

Функция СлучайноеЗначениеСвойства(Свойство, Уровень = 0)
	
	ТипСвойства = Свойство.Тип;

	Если ТипЗнч(ТипСвойства) = Тип("ТипЗначенияXDTO") Тогда
		Возврат СлучайноеЗначениеПримитива(Свойство);
	ИначеЕсли Уровень < 3 Тогда
		Возврат СлучайноеЗначениеОбъекта(Свойство, Уровень + 1);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция СлучайноеЗначениеПримитива(Свойство)
	
	Тип = Свойство.Тип;
	
	Если Тип.Имя = "string" И СтрНайти(НРег(Свойство.Имя), "uid") Тогда
		Возврат ЮТест.Данные().УникальнаяСтрока();
	ИначеЕсли Тип.Имя = "string" Тогда
		Возврат ЮТест.Данные().СлучайнаяСтрока();
	ИначеЕсли Тип.Имя = "boolean" Тогда
		Возврат ЮТест.Данные().СлучайноеБулево();
	ИначеЕсли Тип.Имя = "integer" Тогда
		Возврат ЮТест.Данные().СлучайноеЧисло();
	ИначеЕсли Тип.Имя = "decimal" Тогда
		Возврат ЮТест.Данные().СлучайноеЧисло(, , 3);
	ИначеЕсли Тип.Имя = "time" Тогда
		Возврат ЮТест.Данные().СлучайноеВремя();
	ИначеЕсли Тип.Имя = "date" Тогда
		Возврат НачалоДня(ЮТест.Данные().СлучайнаяДата());
	ИначеЕсли Тип.Имя = "dateTime" Тогда
		Возврат ЮТест.Данные().СлучайнаяДата();
	ИначеЕсли Тип.БазовыйТип.Имя = "AnyRef" Тогда
		Возврат ЮТест.Данные().УникальнаяСтрока();
	ИначеЕсли ЗначениеЗаполнено(Тип.Фасеты) И Тип.Фасеты[0].Вид = ВидФасетаXDTO.Перечисление Тогда
		Возврат СлучайноеЗначениеПеречисления(Тип);
	Иначе
		ВызватьИсключение "Неподдерживаемый тип примитива XDTO: " + Тип;
	КонецЕсли;
	
КонецФункции

Функция СлучайноеЗначениеОбъекта(Свойство, Уровень)
	
	Пакет = НовыйОбъект(Свойство.Тип);
	ЗаполнитьПакетСлучайнымиЗначениями(Пакет, Уровень);
	
	Возврат Пакет;
	
КонецФункции

Процедура ЗаполнитьПакетСлучайнымиЗначениями(Пакет, Уровень = 0)
	
	Тип = Пакет.Тип();
	Для Каждого Свойство Из Тип.Свойства Цикл
		
		Если НеЗаполнено(Свойство, Пакет[Свойство.Имя]) Тогда
			УстановитьСлучайноеЗначениеСвойства(Пакет, Свойство, Уровень);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьСлучайноеЗначениеСвойства(Пакет, Свойство, Уровень)
	
	ЭтоСписок = ЭтоСписок(Свойство);
	
	Если ЭтоСписок Тогда
		СписокСлучайныхЗначений(Пакет[Свойство.Имя], Свойство, Уровень);
	Иначе
		Пакет[Свойство.Имя] = СлучайноеЗначениеСвойства(Свойство, Уровень);
	КонецЕсли;
	
КонецПроцедуры

Функция НеЗаполнено(Свойство, Значение)
	
	ЭтоСписок = ЭтоСписок(Свойство);
	
	Если ЭтоСписок И Значение.Количество() Тогда
		Возврат Значение.Количество() = 0;
	Иначе
		Возврат НЕ ЗначениеЗаполнено(Значение);
	КонецЕсли;
	
КонецФункции

Функция ЭтоСписок(Свойство)
	
	Возврат Свойство.ВерхняяГраница = -1 ИЛИ Свойство.ВерхняяГраница > 1;
	
КонецФункции

Процедура СписокСлучайныхЗначений(Список, Свойство, Уровень)
	
	Если Свойство.ВерхняяГраница = -1 Тогда
		Количество = ЮТест.Данные().СлучайноеЧисло(Свойство.НижняяГраница, 10);
	Иначе
		Количество = ЮТест.Данные().СлучайноеЧисло(Свойство.НижняяГраница, Свойство.ВерхняяГраница);
	КонецЕсли;
	
	Для Инд = 0 По Количество Цикл
		Значение = СлучайноеЗначениеСвойства(Свойство, Уровень);
		Список.Добавить(Значение);
	КонецЦикла;
	
КонецПроцедуры

Функция НовыйОбъект(Тип)
	
	Возврат Фабрика.Создать(Тип);
	
КонецФункции

Функция ЭтоТипОбъектаXDTO(ТипСвойства)
	
	Возврат ТипЗнч(ТипСвойства) = Тип("ТипОбъектаXDTO");
	
КонецФункции

Функция СлучайноеЗначениеПеречисления(Тип)
	
	Значения = Новый Массив();
	
	Для Каждого Фасет Из Тип.Фасеты Цикл
		Если Фасет.Вид = ВидФасетаXDTO.Перечисление Тогда
			Значения.Добавить(Фасет.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЮТест.Данные().СлучайноеЗначениеИзСписка(Значения);
	
КонецФункции

#КонецОбласти

#КонецЕсли
