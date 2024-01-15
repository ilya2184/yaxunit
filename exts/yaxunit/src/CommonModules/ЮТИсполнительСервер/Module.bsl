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

#Область СлужебныйПрограммныйИнтерфейс

// ПрогонНаборов
//  Выполняет тесты наборов модуля. Возвращает результат прогона
//  Это обертка для прогона на сервере
// Параметры:
//  Наборы - Массив из см. ЮТФабрика.ОписаниеИсполняемогоНабораТестов - Наборы исполняемых тестов, структуру набора см. ЮТФабрика.ОписаниеИсполняемогоНабораТестов 
//  ТестовыйМодуль - см. ЮТФабрика.ОписаниеТестовогоМодуля
// 
// Возвращаемое значение:
//  Массив из см. ЮТФабрика.ОписаниеИсполняемогоНабораТестов - Результат прогона наборов тестов, структура набора см. ЮТФабрика.ОписаниеИсполняемогоНабораТестов
Функция ВыполнитьГруппуНаборовТестов(Знач Наборы, Знач ТестовыйМодуль) Экспорт
	
	Возврат ЮТИсполнительКлиентСервер.ВыполнитьГруппуНаборовТестов(Наборы, ТестовыйМодуль);
	
КонецФункции

#КонецОбласти
