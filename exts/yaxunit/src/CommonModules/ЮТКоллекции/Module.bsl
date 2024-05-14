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

#Область ПрограммныйИнтерфейс

// Возвращает требуемое поле структуры. В случае отсутствия поля возвращает значение по умолчанию
// 
// Параметры:
//  ИсходнаяСтруктура - Структура - Исходная структура
//  ИмяПоля - Строка - Имя поля структуры
//  ЗначениеПоУмолчанию - Произвольный - Значение, которое будет возвращено, если поля в структуре нет
// 
// Возвращаемое значение:
//  Произвольный - Значение искомого поля структуры
Функция ЗначениеСтруктуры(ИсходнаяСтруктура, ИмяПоля, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ИсходнаяСтруктура) ИЛИ ПустаяСтрока(ИмяПоля) Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	ЗначениеПоля = Неопределено;
	
	Если ИсходнаяСтруктура.Свойство(ИмяПоля, ЗначениеПоля) Тогда
		Возврат ЗначениеПоля;
	КонецЕсли;
	
	Возврат ЗначениеПоУмолчанию;
	
КонецФункции

// Добавляет в приемник данные из источника, при совпадении ключей значения заменяются
// 
// Параметры:
//  Приемник - Структура
//  Источник - Соответствие из Произвольный
//           - Структура
Процедура ДополнитьСтруктуру(Приемник, Источник) Экспорт
	
	Для Каждого Элемент Из Источник Цикл
		Приемник.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	
КонецПроцедуры

// Добавляет в приемник все элементы источника
// 
// Параметры:
//  Приемник - Массив из Произвольный
//  Источник - Массив из Произвольный
Процедура ДополнитьМассив(Приемник, Источник) Экспорт
	
	Для Каждого Элемент Из Источник Цикл
		Приемник.Добавить(Элемент);
	КонецЦикла;
	
КонецПроцедуры

// Содает новый массив путем объединия входных.
// 
// Параметры:
//  Коллекция1 - Массив Из Произвольный
//  Коллекция2 - Массив Из Произвольный
//  Коллекция3 - Массив Из Произвольный
//  Коллекция4 - Массив Из Произвольный
// 
// Возвращаемое значение:
//  Массив из Произвольный - Результат объединения
Функция ОбъединитьМассивы(Коллекция1, Коллекция2, Коллекция3 = Неопределено, Коллекция4 = Неопределено) Экспорт
	
	Коллекции = Новый Массив;
	Если ЗначениеЗаполнено(Коллекция1) Тогда
		Коллекции.Добавить(Коллекция1);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Коллекция2) Тогда
		Коллекции.Добавить(Коллекция2);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Коллекция3) Тогда
		Коллекции.Добавить(Коллекция3);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Коллекция4) Тогда
		Коллекции.Добавить(Коллекция4);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Коллекции) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Размер = 0;
	Для Каждого Коллекция Из Коллекции Цикл
		Размер = Размер + Коллекция.Количество();
	КонецЦикла;
	
	Результат = Новый Массив(Размер);
	Позиция = 0;
	
	Для Каждого Коллекция Из Коллекции Цикл
		Размер = Размер + Коллекция.Количество();
		
		Для Инд = 0 По Коллекция.ВГраница() Цикл
			Результат[Позиция] = Коллекция[Инд];
			Позиция = Позиция + 1;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Создает копию экземпляра указанного объекта.
// Примечание:
// Функцию нельзя использовать для объектных типов (СправочникОбъект, ДокументОбъект и т.п.).
//
// Параметры:
//  Источник - Произвольный	 - объект, который необходимо скопировать.
// 
// Возвращаемое значение:
//  Произвольный - копия объекта, переданного в параметре Источник.
//
Функция СкопироватьРекурсивно(Источник) Экспорт
	
	Перем Приемник;
	
	СкопироватьПрисвоением = Ложь;
	
	ТипИсточника = ТипЗнч(Источник);
	
	Если ЮТТипыДанныхСлужебный.ЭтоСтруктура(ТипИсточника) Тогда
		Приемник = СкопироватьСтруктуру(Источник);
	ИначеЕсли ЮТТипыДанныхСлужебный.ЭтоСоответствие(ТипИсточника) Тогда
		Приемник = СкопироватьСоответствие(Источник);
	ИначеЕсли ЮТТипыДанныхСлужебный.ЭтоМассива(ТипИсточника) Тогда
		Приемник = СкопироватьМассив(Источник);
	ИначеЕсли ТипИсточника = Тип("СписокЗначений") Тогда
		Приемник = СкопироватьСписокЗначений(Источник);
	Иначе
		
		СкопироватьПрисвоением = Истина;
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		
		Если ТипИсточника = Тип("ТаблицаЗначений") Или ТипИсточника = Тип("ДеревоЗначений") Тогда
			
			СкопироватьПрисвоением = Ложь;
			Приемник = Источник.Скопировать();
			
		КонецЕсли;
#КонецЕсли
		
	КонецЕсли;
	
	Если СкопироватьПрисвоением Тогда
		Приемник = Источник;
	КонецЕсли;
	
	Возврат Приемник;
	
КонецФункции

// Создает копию структуры
//
// Параметры:
//  Источник - Структура, ФиксированнаяСтруктура - копируемая структура
// 
// Возвращаемое значение:
//  Структура - копия исходной структуры.
Функция СкопироватьСтруктуру(Источник) Экспорт
	
	Результат = Новый Структура;
	
	Для Каждого КлючИЗначение Из Источник Цикл
		Результат.Вставить(КлючИЗначение.Ключ, СкопироватьРекурсивно(КлючИЗначение.Значение));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Создает копию соответствия
//
// Параметры:
//  Источник - Соответствие из Произвольный
//           - ФиксированноеСоответствие из Произвольный
// 
// Возвращаемое значение:
//  Соответствие Из Произвольный - копия исходного соответствия.
//
Функция СкопироватьСоответствие(Источник) Экспорт
	
	Результат = Новый Соответствие;
	
	Для Каждого КлючИЗначение Из Источник Цикл
		
		НовыйКлюч = СкопироватьРекурсивно(КлючИЗначение.Ключ);
		НовоеЗначение = СкопироватьРекурсивно(КлючИЗначение.Значение);
		Результат.Вставить(НовыйКлюч, НовоеЗначение);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Создает копию массива
//
// Параметры:
//  Источник - Массив Из Произвольный
//           - ФиксированныйМассив из Произвольный
// 
// Возвращаемое значение:
//  Массив Из Произвольный - копия исходного массива.
Функция СкопироватьМассив(Источник) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Источник) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Размер = Источник.Количество();
	Результат = Новый Массив(Размер);
	
	Для Инд = 0 По Размер - 1 Цикл
		Результат[Инд] = СкопироватьРекурсивно(Источник[Инд]);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Создает копию списка значений
//
// Параметры:
//  Источник - СписокЗначений Из Произвольный
// 
// Возвращаемое значение:
//  СписокЗначений Из Произвольный
//
Функция СкопироватьСписокЗначений(Источник) Экспорт
	
	Результат = Новый СписокЗначений;
	
	Для Каждого ЭлементСписка Из Источник Цикл
		
		НовоеЗначение = СкопироватьРекурсивно(ЭлементСписка.Значение);
		Результат.Добавить(НовоеЗначение, ЭлементСписка.Представление, ЭлементСписка.Пометка, ЭлементСписка.Картинка);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Выгружает значения "колонки" коллекции элементов.
// 
// Параметры:
//  Коллекция - Произвольный - Итерируемая коллекция
//  ИмяРеквизита - Строка - Имя реквизата элементов коллекции
// 
// Возвращаемое значение:
//  Массив из Произвольный
Функция ВыгрузитьЗначения(Коллекция, ИмяРеквизита) Экспорт
	
	Результат = Новый Массив();
	
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		Результат.Добавить(ЭлементКоллекции[ИмяРеквизита]);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Вычисляет двух массивов, коллекцию содержащую общие элементы.
// 
// Параметры:
//  Коллекция1 - Массив из Произвольный
//  Коллекция2 - Массив из Произвольный
// 
// Возвращаемое значение:
//  Массив из Произвольный - Пересечение массивов
Функция ПересечениеМассивов(Коллекция1, Коллекция2) Экспорт
	
	Результат = Новый Массив;
	
	Для Каждого Элемент Из Коллекция1 Цикл
		
		Если Коллекция2.Найти(Элемент) <> Неопределено Тогда
			Результат.Добавить(Элемент);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Создает массив с переданными значениями
// 
// Параметры:
//  Значение - Произвольный
//  Значение2 - Произвольный 
//  Значение3 - Произвольный 
//  Значение4 - Произвольный 
//  Значение5 - Произвольный 
//  Значение6 - Произвольный 
//  Значение7 - Произвольный 
//  Значение8 - Произвольный 
//  Значение9 - Произвольный 
//  Значение10 - Произвольный
// 
// Возвращаемое значение:
//  Массив из Произвольный 
//@skip-check method-too-many-params
Функция ЗначениеВМассиве(Значение,
							Значение2 = "_!%*",
							Значение3 = "_!%*",
							Значение4 = "_!%*",
							Значение5 = "_!%*",
							Значение6 = "_!%*",
							Значение7 = "_!%*",
							Значение8 = "_!%*",
							Значение9 = "_!%*",
							Значение10 = "_!%*") Экспорт
	
	Значения = Новый Массив;
	
	Если Не ДобавитьНеПоследнее(Значения, Значение) Тогда
		Возврат Значения;
	КонецЕсли;
	
	Если Не ДобавитьНеПоследнее(Значения, Значение2) Тогда
		Возврат Значения;
	КонецЕсли;
	
	Если Не ДобавитьНеПоследнее(Значения, Значение3) Тогда
		Возврат Значения;
	КонецЕсли;
	
	Если Не ДобавитьНеПоследнее(Значения, Значение4) Тогда
		Возврат Значения;
	КонецЕсли;
	
	Если Не ДобавитьНеПоследнее(Значения, Значение5) Тогда
		Возврат Значения;
	КонецЕсли;
	
	Если Не ДобавитьНеПоследнее(Значения, Значение6) Тогда
		Возврат Значения;
	КонецЕсли;

	Если Не ДобавитьНеПоследнее(Значения, Значение7) Тогда
		Возврат Значения;
	КонецЕсли;

	Если Не ДобавитьНеПоследнее(Значения, Значение8) Тогда
		Возврат Значения;
	КонецЕсли;

	Если Не ДобавитьНеПоследнее(Значения, Значение9) Тогда
		Возврат Значения;
	КонецЕсли;

	Если Не ДобавитьНеПоследнее(Значения, Значение10) Тогда
		Возврат Значения;
	КонецЕсли;
	
	Возврат Значения;
	
КонецФункции

// Возвращает соответствие элементов переданной коллекции, в качестве ключей выступают значения указанного поля элементов коллекции.
// 
// Параметры:
// 	Коллекция - Произвольный - значение, для которого определен итератор, и возможно обращение к полям элементов через квадратные скобки.
// 	ИмяПоляКлюча - Строка - имя поля элемента коллекции, которое будет ключом соответствия.
// 	ИмяПоляЗначения - Строка - если указан, значениями результата будут не элементы, а значения соответствующих полей элементов коллекции.
// Возвращаемое значение:
// 	Соответствие Из Произвольный - полученное соответствие.
Функция ВСоответствие(Коллекция, ИмяПоляКлюча, ИмяПоляЗначения = Неопределено) Экспорт
	
	Результат = Новый Соответствие();
	
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		
		Значение = ?(ИмяПоляЗначения = Неопределено, ЭлементКоллекции, ЭлементКоллекции[ИмяПоляЗначения]);
		
		Результат.Вставить(ЭлементКоллекции[ИмяПоляКлюча], Значение);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру элементов переданной коллекции, в качестве ключей выступают значения указанного поля элементов коллекции.
// 
// Параметры:
// 	Коллекция - Произвольный - значение, для которого определен итератор, и возможно обращение к полям элементов через квадратные скобки.
// 	ИмяПоляКлюча - Строка - имя поля элемента коллекции, которое будет ключом соответствия.
// 	ИмяПоляЗначения - Строка - если указан, значениями результата будут не элементы, а значения соответствующих полей элементов коллекции.
// Возвращаемое значение:
// 	Структура Из Произвольный - полученная структура.
Функция ВСтруктуру(Коллекция, ИмяПоляКлюча, ИмяПоляЗначения = Неопределено) Экспорт
	
	Результат = Новый Структура();
	
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		
		Значение = ?(ИмяПоляЗначения = Неопределено, ЭлементКоллекции, ЭлементКоллекции[ИмяПоляЗначения]);
		
		Результат.Вставить(ЭлементКоллекции[ИмяПоляКлюча], Значение);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Формирует текстовое представление массива.
// Пример результата - "[1, 2, 3]"
// 
// Параметры:
//  Данные - Массив из Строка
// 
// Возвращаемое значение:
//  Строка
Функция ПредставлениеМассива(Данные) Экспорт
	
	Возврат СтрШаблон("[%1]", СтрСоединить(Данные, ", "));
	
КонецФункции

Функция МассивВСтруктуру(Значения, ЗначениеСтруктуры = Неопределено) Экспорт
	
	Результат = Новый Структура();
	
	Если НЕ ЗначениеЗаполнено(Значения) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого Значение Из Значения Цикл
		
		Результат.Вставить(Значение, ЗначениеСтруктуры);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьНеПоследнее(Значения, Значение, ФлагОкончания = "_!%*")
	
	Если Значение <> ФлагОкончания Тогда
		Значения.Добавить(Значение);
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти
