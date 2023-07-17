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

#Область ПрограммныйИнтерфейс

// Возвращает случайное имя компании
//
// Возвращаемое значение:
//	Строка
Функция Наименование() Экспорт

	СловарьИмен = СловарьИменаКомпаний();
	СловарьПрефиксов = СловарьПрефиксыИменКомпаний();

	Возврат СтрШаблон(
		"%1 %2",
		СловарьПрефиксов.Получить(ЮТТестовыеДанные.СлучайноеЧисло(0, СловарьПрефиксов.ВГраница())),
		СловарьИмен.Получить(ЮТТестовыеДанные.СлучайноеЧисло(0, СловарьИмен.ВГраница()))
	);

КонецФункции

// Формирует случайный валидный ИНН РФ.
//
// Параметры:
//  КодРегиона - Строка - Код региона это первые две цифры кода ИНН. Список действующих кодов регионов
//    можно подсмотреть: https://www.nalog.gov.ru/html/docs/kods_regions.doc . Если код региона задан
//    как "00" то будет сформирован случайный код региона. По умолчанию "00" (случайный код региона)
//  ЭтоИННФизическогоЛица - Булево - Если Истина, то это ИНН физического лица, иначе ИНН юридического
//    лица. По умолчанию Ложь (ИНН юридического лица)
//
// Возвращаемое значение:
//  Строка - Случайный ИНН, например 3444140904
Функция ИНН(КодРегиона = "00", ЭтоИННФизическогоЛица = Ложь) Экспорт

	СлучайныйИНН = "";

	Если ЭтоИННФизическогоЛица Тогда
		ИННМассив = Новый Массив(12);
		ВесовыеКоэффициенты1 = СтрРазделить("7, 2, 4, 10, 3, 5, 9, 4, 6, 8", ",");
		ВесовыеКоэффициенты2 = СтрРазделить("3, 7, 2, 4, 10, 3, 5, 9, 4, 6, 8", ",");
	Иначе
		ИННМассив = Новый Массив(10);
		ВесовыеКоэффициенты1 = СтрРазделить("2, 4, 10, 3, 5, 9, 4, 6, 8", ",");
		ВесовыеКоэффициенты2 = Новый Массив;
	КонецЕсли;

	Если КодРегиона = "00" Или СтрДлина(КодРегиона) <> 2 Тогда
		ИННМассив.Установить(0, ЮТТестовыеДанные.СлучайноеЧисло(0, 9, 0));
		ИННМассив.Установить(1, ЮТТестовыеДанные.СлучайноеЧисло(0, 9, 0));
	Иначе
		ИННМассив.Установить(0, Число(Сред(КодРегиона, 1, 1)));
		ИННМассив.Установить(1, Число(Сред(КодРегиона, 2, 1)));
	КонецЕсли;

	Для Индекс = 2 По ИННМассив.ВГраница() Цикл
		ИННМассив.Установить(Индекс, ЮТТестовыеДанные.СлучайноеЧисло(0, 9, 0));
	КонецЦикла;

	Сумма1 = 0;
	Для Индекс = 0 По ВесовыеКоэффициенты1.ВГраница() Цикл
		Элемент = ИННМассив.Получить(Индекс) * Число(ВесовыеКоэффициенты1.Получить(Индекс));
		Сумма1 = Сумма1 + Элемент;
	КонецЦикла;
	ИННМассив.Установить(ВесовыеКоэффициенты1.Количество(), Сумма1 % 11 % 10);

	Если ВесовыеКоэффициенты2.Количество() <> 0 Тогда
		Сумма2 = 0;
		Для Индекс = 0 По ВесовыеКоэффициенты2.ВГраница() Цикл
			Элемент = ИННМассив.Получить(Индекс) * Число(ВесовыеКоэффициенты2.Получить(Индекс));
			Сумма2 = Сумма2 + Элемент;
		КонецЦикла;
		ИННМассив.Установить(ВесовыеКоэффициенты2.Количество(), Сумма1 % 11 % 10);
	КонецЕсли;

	СлучайныйИНН = СтрСоединить(ИННМассив);

	Возврат СлучайныйИНН;
КонецФункции

// Формирует случайный валидный КПП РФ
//
// Параметры:
//  КодНалоговогоОргана - Строка - Код налогового органа, первые четыре цифры КПП.
//  Причина - Число - Причина постановки. Поддерживаются следующие варианты
//    # 2 - код причины "43" постановка на учет филиала российской организации
//    # любая другая цифра - код причины "01" постановка на учет российской организации
//    по месту ее нахождения
//
// Возвращаемое значение:
//  Строка - Случайный КПП, например 344401001
Функция КПП(КодНалоговогоОргана = "0000", Причина = 1) Экспорт

	СлучайныйКПП = "";

	Если ТипЗнч(Причина) = Тип("Число") И Причина = 2 Тогда
		Код2 = "43";
	Иначе
		Код2 = "01";
	КонецЕсли;

	Если ТипЗнч(КодНалоговогоОргана) = Тип("Строка") И СтрДлина(КодНалоговогоОргана) = 4 Тогда
		Код1 = КодНалоговогоОргана;
	Иначе
		МассивКод1 = Новый Массив(4);
		Для Индекс = 0 По МассивКод1.ВГраница() Цикл
			МассивКод1.Установить(Индекс, ЮТТестовыеДанные.СлучайноеЧисло(0, 9, 0));
		КонецЦикла;
		Код1 = СтрСоединить(МассивКод1);
	КонецЕсли;

	Код3 = "00" + Строка(ЮТТестовыеДанные.СлучайноеЧисло(0, 9, 0));

	СлучайныйКПП = СтрШаблон("%1%2%3", Код1, Код2, Код3);

	Возврат СлучайныйКПП;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяРеализации()
	Возврат "Компании";
КонецФункции

Функция СловарьИменаКомпаний()
	Возврат ЮТПодражатель.Словарь(ИмяРеализации(), "Наименования");
КонецФункции

Функция СловарьПрефиксыИменКомпаний()
	Возврат ЮТПодражатель.Словарь(ИмяРеализации(), "ПрефиксыНаименований");
КонецФункции

#КонецОбласти
