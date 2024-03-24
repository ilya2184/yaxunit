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
	
	ЮТТесты.ВТранзакции().УдалениеТестовыхДанных()
		.ДобавитьТест("ЗаполнитьСправочник")
		.ДобавитьТест("ЗаполнитьДокумент")
		.ДобавитьТест("СоздатьЗаписьРегистраСведений")
		.ДобавитьТест("Фикция")
		.ДобавитьТест("Фикция_Типизированная")
		.ДобавитьТест("Фикция_ОбщийРеквизит")
		.ДобавитьТест("ФикцияОбязательныхПолей")
		.ДобавитьТест("СоздатьГруппу")
		.ДобавитьТест("УстановитьРеквизиты")
		;
	
КонецПроцедуры

Процедура ЗаполнитьСправочник() Экспорт
	
#Если Клиент Тогда
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары");
#Иначе
	Конструктор = ЮТест.Данные().КонструкторОбъекта(Справочники.Товары);
#КонецЕсли
	
	НаименованиеПоставщика = ЮТест.Данные().СлучайнаяСтрока(20);
	Конструктор
		.Фикция("Наименование")
		.Фикция("Артикул")
		.Установить("Поставщик", ЮТест.Данные().КонструкторОбъекта("Справочники.Контрагенты")
			.Установить("Наименование", НаименованиеПоставщика)
			.Записать())
		.Фикция("Вид");
	
	ДанныеОбъекта = Конструктор.ДанныеОбъекта();
	ЮТест.ОжидаетЧто(ДанныеОбъекта, "Данные создаваемого объекта")
		.Свойство("Наименование").Заполнено().НеРавно(НаименованиеПоставщика)
		.Свойство("Артикул").Заполнено()
		.Свойство("Поставщик").Заполнено()
		.Свойство("Вид").Заполнено();
	
	Ссылка = Конструктор.Записать();
#Если НЕ Клиент Тогда
	ЮТест.ОжидаетЧто(Ссылка, "Созданный объект")
		.Заполнено()
		.ИмеетТип("СправочникСсылка.Товары")
		.Свойство("Наименование").Заполнено().Равно(ДанныеОбъекта.Наименование)
		.Свойство("Артикул").Заполнено().Равно(ДанныеОбъекта.Артикул)
		.Свойство("Поставщик").Заполнено().Равно(ДанныеОбъекта.Поставщик)
		.Свойство("Вид").Заполнено().Равно(ДанныеОбъекта.Вид);
#КонецЕсли
	
	УстановленноеНаименованиеПоставщика = ЮТЗапросы.ЗначениеРеквизита(Ссылка, "Поставщик.Наименование");
	ЮТест.ОжидаетЧто(УстановленноеНаименованиеПоставщика).Равно(НаименованиеПоставщика);
КонецПроцедуры

Процедура ЗаполнитьДокумент() Экспорт
	
#Если Клиент Тогда
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Документы.ПриходТовара");
#Иначе
	Конструктор = ЮТест.Данные().КонструкторОбъекта(Документы.ПриходТовара);
#КонецЕсли
	
	Ссылка = Конструктор
		.Фикция("Поставщик")
		.Фикция("Склад")
		.ТабличнаяЧасть("Товары")
		.ДобавитьСтроку()
			.Фикция("Товар")
			.Установить("Цена", ЮТест.Данные().СлучайноеПоложительноеЧисло(9999, 2))
			.Установить("Количество", ЮТест.Данные().СлучайноеПоложительноеЧисло(20))
			.Установить("Сумма", Конструктор.ДанныеСтроки().Цена * Конструктор.ДанныеСтроки().Количество)
		.ДобавитьСтроку()
			.Фикция("Товар")
			.Установить("Цена", ЮТест.Данные().СлучайноеПоложительноеЧисло(9999, 2))
			.Установить("Количество", ЮТест.Данные().СлучайноеПоложительноеЧисло(20))
			.Установить("Сумма", Конструктор.ДанныеСтроки().Цена * Конструктор.ДанныеСтроки().Количество)
		.Объект()
			.Фикция("Валюта")
			.Фикция("Организация")
		.Провести();
	
#Если НЕ Клиент Тогда
	ЮТест.ОжидаетЧто(Ссылка, "Созданный объект")
		.Заполнено()
		.ИмеетТип("ДокументСсылка.ПриходТовара")
		.Свойство("Номер").Заполнено()
		.Свойство("Поставщик").Заполнено()
		.Свойство("Склад").Заполнено()
		.Свойство("Валюта").Заполнено()
		.Свойство("Организация").Заполнено()
		.Свойство("Товары").ИмеетДлину(2)
		.Свойство("Товары[0].Товар").Заполнено()
		.Свойство("Товары[0].Цена").Заполнено()
		.Свойство("Товары[0].Количество").Заполнено()
		.Свойство("Товары[0].Сумма").Заполнено()
		.Свойство("Товары[1].Товар").Заполнено()
		.Свойство("Товары[1].Цена").Заполнено()
		.Свойство("Товары[1].Количество").Заполнено()
		.Свойство("Товары[1].Сумма").Заполнено()
		.Свойство("Проведен").ЭтоИстина()
		;
#КонецЕсли
	
КонецПроцедуры

Процедура СоздатьЗаписьРегистраСведений() Экспорт
	
	Результат = ЮТест.Данные().КонструкторОбъекта("РегистрыСведений.КурсыВалют")
		.Фикция("Валюта")
		.Фикция("Курс")
		.Установить("Период", ТекущаяДата())
		.Записать();
	
	ЮТест.ОжидаетЧто(Результат)
		.ИмеетТип(Тип("РегистрСведенийКлючЗаписи.КурсыВалют"))
		.Заполнено();
	
КонецПроцедуры

Процедура Фикция() Экспорт
	
	Поставщик = Ютест.Данные().СоздатьЭлемент("Справочники.Контрагенты");
	
	Данные = ЮТест.Данные().КонструкторОбъекта("Документы.ПриходТовара")
		.Установить("Поставщик", Поставщик)
		.Фикция("Дата")
		.Фикция("Номер")
		.Фикция("Склад")
		.Фикция("Валюта")
		.ТабличнаяЧасть("Товары")
			.ДобавитьСтроку()
			.Фикция("Товар", Новый Структура("Поставщик", Поставщик))
			.Фикция("Цена")
		.ДанныеОбъекта();
	
	ЮТест.ОжидаетЧто(Данные)
		.Свойство("Дата").Заполнено()
		.Свойство("Номер").Заполнено()
		.Свойство("Склад").Заполнено()
		.Свойство("Валюта").Заполнено()
		.Свойство("Товары[0].Товар").Заполнено();
	
	ПоставщикТовара = ЮТЗапросы.ЗначениеРеквизита(Данные.Товары[0].Товар, "Поставщик");
	ЮТест.ОжидаетЧто(ПоставщикТовара).Равно(Поставщик);
	
КонецПроцедуры

Процедура Фикция_Типизированная() Экспорт
	
	ИмяТипа = "ПланОбменаСсылка.Мобильные";
	Тип = Тип(ИмяТипа);
	
	Варианты = ЮТест.Варианты("Тип, ОжилаемыйТип, Описание")
		.Добавить(ИмяТипа, Тип, "По представлению типа")
		.Добавить(Тип, Тип, "По типу")
		.Добавить(Новый ОписаниеТипов(ИмяТипа), Тип, "По описаниею типов")
		.Добавить("Строка", Тип("Строка"), "Другой тип")
		;
	
	Для Каждого Вариант Из Варианты.СписокВариантов() Цикл
		
		Данные = ЮТест.Данные().КонструкторОбъекта("Справочник.МобильныеУстройства")
			.Фикция("Подписчик", , Вариант.Тип)
			.ДанныеОбъекта();
		
		ЮТест.ОжидаетЧто(Данные, Вариант.Описание).Свойство("Подписчик")
			.Заполнено()
			.ИмеетТип(Вариант.ОжилаемыйТип);
		
	КонецЦикла;
	//
	Варианты = ЮТест.Варианты("Тип, Описание")
		.Добавить("Дата", "Неподходящий тип")
		.Добавить(Новый ОписаниеТипов("Число, Дата"), "Неподходящее описание типов")
		.Добавить("Неопределено", "Неопределено")
		.Добавить(Тип("Неопределено"), "Тип Неопределено")
		;
	
	Конструктор = ЮТест.Данные().КонструкторОбъекта("Справочник.МобильныеУстройства");
	
	Для Каждого Вариант Из Варианты.СписокВариантов() Цикл
		
		ЮТест.ОжидаетЧто(Конструктор, Вариант.Описание).Метод("Фикция", ЮТКоллекции.ЗначениеВМассиве("Подписчик", Неопределено, Вариант.Тип))
			.ВыбрасываетИсключение("Исправьте ограничение типов для реквизита `Подписчик`");
		
	КонецЦикла;
	
КонецПроцедуры

Процедура Фикция_ОбщийРеквизит() Экспорт
	
	Склад = ЮТест.Данные().КонструкторОбъекта("Справочник.Склады")
		.Фикция("Организация")
		.ДанныеОбъекта();
	
	ЮТест.ОжидаетЧто(Склад)
		.Свойство("Организация").Заполнено();
	
КонецПроцедуры

Процедура ФикцияОбязательныхПолей() Экспорт
	
	Данные = ЮТест.Данные().КонструкторОбъекта("Справочники.Контрагенты")
		.ФикцияОбязательныхПолей()
		.ДанныеОбъекта();
	
	ЮТест.ОжидаетЧто(Данные)
		.ИмеетДлину(2)
		.Свойство("ВидЦен").Заполнено()
		.Свойство("Наименование").Заполнено();
	
	Данные = ЮТест.Данные().КонструкторОбъекта("Документы.ПриходТовара")
		.ФикцияОбязательныхПолей()
		.ТабличнаяЧасть("Товары")
			.ДобавитьСтроку()
			.ФикцияОбязательныхПолей()
		.ДанныеОбъекта();
	
	ЮТест.ОжидаетЧто(Данные)
		.ИмеетДлину(6)
		.Свойство("Дата").Заполнено()
		.Свойство("Поставщик").Заполнено()
		.Свойство("Склад").Заполнено()
		.Свойство("Валюта").Заполнено()
		.Свойство("Организация").Заполнено()
		.Свойство("Товары").Заполнено()
		.Свойство("Товары[0]").ИмеетДлину(4);
	
	Данные = ЮТест.Данные().КонструкторОбъекта("РегистрыСведений.КурсыВалют")
		.ФикцияОбязательныхПолей()
		.ДанныеОбъекта();
	
	ЮТест.ОжидаетЧто(Данные)
		.ИмеетДлину(3)
		.Свойство("Период").Заполнено()
		.Свойство("Валюта").Заполнено()
		.Свойство("Курс").Заполнено();
КонецПроцедуры

Процедура СоздатьГруппу() Экспорт
	
	Группа = ЮТест.Данные().КонструкторОбъекта("Справочники.Товары")
		.Установить("ЭтоГруппа", Истина)
		.Записать();
	
	ЭтоГруппа = ЮТЗапросы.ЗначениеРеквизита(Группа, "ЭтоГруппа");
	ЮТест.ОжидаетЧто(ЭтоГруппа).ЭтоИстина();
	
КонецПроцедуры

Процедура УстановитьРеквизиты() Экспорт
	
	Поставщик = ЮТест.Данные().СоздатьЭлемент("Справочник.Контрагенты");
	Склад = ЮТест.Данные().СоздатьЭлемент("Справочник.Склады");
	Товар = ЮТест.Данные().СоздатьЭлемент("Справочник.Товары");
	Цена = ЮТест.Данные().СлучайноеЧисло(99, 2);
	
	Реквизиты = Новый Структура("Поставщик, Склад", Поставщик, Склад);
	РеквизитыСтроки = Новый Структура("Товар, Цена", Товар, Цена);
	
	Данные = ЮТест.Данные().КонструкторОбъекта("Документы.ПриходТовара")
		.УстановитьРеквизиты(Реквизиты)
		.ТабличнаяЧасть("Товары")
			.ДобавитьСтроку()
				.УстановитьРеквизиты(РеквизитыСтроки)
			.ДобавитьСтроку(РеквизитыСтроки)
		.ДанныеОбъекта();
	
	ЮТест.ОжидаетЧто(Данные)
		.Свойство("Поставщик").Равно(Поставщик)
		.Свойство("Склад").Равно(Склад)
		.Свойство("Товары[0].Товар").Равно(Товар)
		.Свойство("Товары[0].Цена").Равно(Цена)
		.Свойство("Товары[1].Товар").Равно(Товар)
		.Свойство("Товары[1].Цена").Равно(Цена);
	
КонецПроцедуры

#КонецОбласти
