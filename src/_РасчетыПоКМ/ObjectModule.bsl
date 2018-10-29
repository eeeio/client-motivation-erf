﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры
// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
		
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
		И Параметры.Свойство("ОписаниеКоманды")
		И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда  		
		//Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "Продажи" Тогда  			
		//	СформироватьПараметрыФормыПродажи(Параметры.ПараметрКоманды, ЭтаФорма.ФормаПараметры); 			
		//ИначеЕсли Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "ПродажиПоЗаказу" Тогда
		//	ЭтаФорма.ФормаПараметры.Отбор.Вставить("ЗаказКлиента", Параметры.ПараметрКоманды);
		//Иначе
		//Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "ЗадолженностьПоПартнеру" Тогда
		//	ЭтаФорма.ФормаПараметры.Отбор.Вставить("Партнер", Параметры.ПараметрКоманды);
		//ИначеЕсли Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "ЗадолженностьПоСегменту" Тогда 			
		//	Параметры.ФиксированныеНастройки = ПолучитьФиксированныеНастройкиПродажиПоСегменту(Параметры.ПараметрКоманды);
		//	ЭтаФорма.ФормаПараметры.ФиксированныеНастройки = Параметры.ФиксированныеНастройки;     			
		//КонецЕсли;  		
	КонецЕсли;
	
	// Дополнительные команды
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	НастройкиОтчета = ЭтаФорма.НастройкиОтчета;
	
	Если НастройкиОтчета.Свойство("РасширенныйОтбор") Тогда
		РасширенныйОтбор = КомпоновщикНастроекФормы.ФиксированныеНастройки.Отбор.Элементы.Добавить(
			Тип("ЭлементОтбораКомпоновкиДанных"));
		РасширенныйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер");
		Если ТипЗнч(НастройкиОтчета.РасширенныйОтбор) = Тип("Массив") Тогда
			ЭтоМассив = Истина;
			Если НастройкиОтчета.РасширенныйОтбор.Количество() > 0 Тогда
				ПервыйЭлемент = НастройкиОтчета.РасширенныйОтбор[0];
			Иначе
				ПервыйЭлемент = Неопределено;
			КонецЕсли;
		Иначе
			ЭтоМассив = Ложь;
			ПервыйЭлемент = НастройкиОтчета.РасширенныйОтбор;
		КонецЕсли;
		Если ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.Партнеры") Тогда
			Если ЭтоМассив Тогда
				ЕстьПодчиненныеПартнеры = Ложь;
				Для Каждого ЭлементПараметраКоманды Из НастройкиОтчета.РасширенныйОтбор Цикл
					Если ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ЭлементПараметраКоманды) Тогда
						ЕстьПодчиненныеПартнеры = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			Иначе
				ЕстьПодчиненныеПартнеры = ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(НастройкиОтчета.РасширенныйОтбор);
			КонецЕсли;
			Если ЕстьПодчиненныеПартнеры И ЭтоМассив Тогда
				РасширенныйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
			ИначеЕсли ЕстьПодчиненныеПартнеры Тогда
				РасширенныйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			ИначеЕсли ЭтоМассив Тогда
				РасширенныйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			Иначе
				РасширенныйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			КонецЕсли;
			РасширенныйОтбор.ПравоеЗначение = НастройкиОтчета.РасширенныйОтбор;
		ИначеЕсли ТипЗнч(НастройкиОтчета.РасширенныйОтбор) = Тип("СправочникСсылка.СегментыПартнеров") Тогда
			РасширенныйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			РасширенныйОтбор.ПравоеЗначение = СегментыСервер.МассивЭлементов(
				ПервыйЭлемент);
		КонецЕсли;
		РасширенныйОтбор.Использование = Истина;
	КонецЕсли;

КонецПроцедуры
// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	НовыеНастройкиКД.ДополнительныеСвойства.Вставить("КлючТекущегоВарианта", ЭтаФорма.КлючТекущегоВарианта);
	НастроитьПараметрыОтборыПоФункциональнымОпциям(НовыеНастройкиКД);

КонецПроцедуры
// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПриЗагрузкеВариантаНаСервере
//
Процедура ПриЗагрузкеВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	Параметры = ЭтаФорма.НастройкиОтчета;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	Если Параметры.Свойство("Расшифровка") И Параметры.Расшифровка <> Неопределено
		И Параметры.Расшифровка.ПрименяемыеНастройки.ДополнительныеСвойства.Свойство("ФиксированныеНастройки") Тогда
		КомпоновщикНастроекФормы.ЗагрузитьНастройки(Параметры.Расшифровка.ПрименяемыеНастройки);
		НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	КонецЕсли;
	

КонецПроцедуры
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если ТипЗнч(Контекст) = Тип("УправляемаяФорма") Тогда
		НастроитьПараметрыОтчетаПоВариантуОтчета(Контекст.НастройкиОтчета, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытий
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ПровестиПоРегиструРасчетовПоКМПодготовленныеНачисленияКМ();  // костыль от 21.08.2018, нужен до обновления <-
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	//ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.ВыручкаИСебестоимостьПродаж.Запрос;
	//
	//ТекстЗапроса = СтрЗаменить(
	//	ТекстЗапроса, 
	//	"&ТекстЗапросаВесНоменклатуры1", 
	//	Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("Таблица.Номенклатура.ЕдиницаИзмерения", "Таблица.Номенклатура"));
	//	
	//ТекстЗапроса = СтрЗаменить(
	//	ТекстЗапроса, 
	//	"&ТекстЗапросаОбъемНоменклатуры1", 
	//	Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("Таблица.Номенклатура.ЕдиницаИзмерения", "Таблица.Номенклатура"));
	//
	//СхемаКомпоновкиДанных.НаборыДанных.ВыручкаИСебестоимостьПродаж.Запрос = ТекстЗапроса;	
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(СтруктураЗаголовковПолей(), МакетКомпоновки);
	
	// Проверим, что хотя бы одна группировка отчета включена
	Если МакетКомпоновки.НаборыДанных.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru= 'Отчет не сформирован. Включите хотя бы одну группировку в ""Элементы оформления и группировки"".'") ;
	КонецЕсли;
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	//ПроверяемыеПоля = Новый Массив;
	//ПроверяемыеПоля.Добавить("Поставщик");
	//УниверсальныеМеханизмыПартийИСебестоимости.ДобавитьПредупреждениеОбОсобенностяхФормированияОтчета(ДокументРезультат, КомпоновщикНастроек, ПроверяемыеПоля);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.ОформитьДиаграммыОтчета(КомпоновщикНастроек, ДокументРезультат);
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции 
Процедура НастроитьПараметрыОтчетаПоВариантуОтчета(НастройкиОтчета, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД)
	
	Если НовыеНастройкиКД = Неопределено
		Или НовыеПользовательскиеНастройкиКД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//ПредопределенныйВариант = ПолучитьПредопределенныйВариант(НастройкиОтчета.ВариантСсылка);
	//
	//ПараметрДанныеОтчета = СхемаКомпоновкиДанных.Параметры.Найти("ДанныеОтчета");
	//ЗначениеПараметраДанныеОтчета = НовыеНастройкиКД.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДанныеОтчета"));
	//
	//ПараметрПоПредприятию = СхемаКомпоновкиДанных.Параметры.Найти("ПоПредприятию");
	//
	//СписокВыбора = Новый СписокЗначений;
	//
	//Если ПредопределенныйВариант.КлючВарианта = "ПродажиПоСделкамПоПредприятию"
	//	Или ПредопределенныйВариант.КлючВарианта = "ПродажиПоПартнерамПоПредприятию"
	//	Или ПредопределенныйВариант.КлючВарианта = "ПродажиСводно" Тогда
	//	
	//	СписокВыбора.Добавить(1, НСтр("ru = 'В валюте упр. учета с НДС'"));
	//	СписокВыбора.Добавить(2, НСтр("ru = 'В валюте упр. учета без НДС'"));
	//	ПараметрПоПредприятию.Значение = Истина;
	//	
	//ИначеЕсли ПредопределенныйВариант.КлючВарианта = "ПродажиПоСделкамПоОрганизациям"
	//	Или ПредопределенныйВариант.КлючВарианта = "ПродажиПоПартнерамПоОрганизациям"
	//	Или ПредопределенныйВариант.КлючВарианта = "ПродажиОрганизаций" Тогда	
	//	
	//	Если ПолучитьФункциональнуюОпцию("ВестиУправленческийУчетОрганизаций") Тогда
	//		СписокВыбора.Добавить(3, НСтр("ru = 'В валюте упр. учета'"));
	//	КонецЕсли;
	//	СписокВыбора.Добавить(4, НСтр("ru = 'В валюте регл. учета'"));
	//	ПараметрПоПредприятию.Значение = Ложь;
	//	
	//Иначе
	//	
	//	СписокВыбора.Добавить(1, НСтр("ru = 'В валюте упр. учета с НДС'"));
	//	СписокВыбора.Добавить(2, НСтр("ru = 'В валюте упр. учета без НДС'"));
	//	СписокВыбора.Добавить(4, НСтр("ru = 'В валюте регл. учета'"));
	//	ПараметрПоПредприятию.Значение = Истина;
	//	
	//КонецЕсли;
	//
	//ПараметрДанныеОтчета.УстановитьДоступныеЗначения(СписокВыбора);
	//
	//НастройкаДанныеОтчета = НовыеПользовательскиеНастройкиКД.Элементы.Найти(ЗначениеПараметраДанныеОтчета.ИдентификаторПользовательскойНастройки);
	//Если Не НастройкаДанныеОтчета = Неопределено
	//	И СписокВыбора.НайтиПоЗначению(НастройкаДанныеОтчета.Значение) = Неопределено Тогда
	//	НастройкаДанныеОтчета.Значение = СписокВыбора[0].Значение;
	//КонецЕсли;
	
КонецПроцедуры
Функция ПолучитьПредопределенныйВариант(Знач Вариант)
	
	КлючиВариантов = Новый Массив;
	КлючиВариантов.Добавить("РасчетыПоКМ");
	//КлючиВариантов.Добавить("ПлоскийСписок");
	
	Пока КлючиВариантов.Найти(Вариант.КлючВарианта) = Неопределено
		И ЗначениеЗаполнено(Вариант.Родитель) Цикл
		Вариант = Вариант.Родитель;
	КонецЦикла;
	
	Возврат Вариант;
	
КонецФункции
Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	//КомпоновкаДанныхСервер.УстановитьПараметрыВалютыОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	//КомпоновкаДанныхСервер.НастроитьДинамическийПериод(СхемаКомпоновкиДанных, КомпоновщикНастроек, Истина);
	//
	//ПараметрПоказыватьПродажи = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ПоказыватьПродажи");
	//Если ПараметрПоказыватьПродажи <> Неопределено 
	//	И ПараметрПоказыватьПродажи.Значение = Неопределено Тогда
	//	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПоказыватьПродажи", 1);
	//			
	//	ПользовательскиеНастройкиМодифицированы = Истина;
	//КонецЕсли;
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	//СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	
	// Строковые литералы
	//КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаПродажиПоЗаказам", НСтр("ru='Продажи по заказам'"));
	//КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаПродажиБезЗаказов", НСтр("ru='Продажи без заказов'"));
	
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПолныеПрава", 		(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("_РедактированиеКМ")));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ТекущийПользователь", Пользователи.ТекущийПользователь());
	
КонецПроцедуры
Функция ВспомогательныеПараметрыОтчета()
	
	ВспомогательныеПараметры = Новый Массив;
	
	КлючТекущегоВарианта = "";
	//Если КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("КлючТекущегоВарианта", КлючТекущегоВарианта) Тогда
	//	Если Не КлючТекущегоВарианта = "ДинамикаПродаж"
	//		И Не КлючТекущегоВарианта = "ДинамикаПродажБизнесРегионы" Тогда
	//		ВспомогательныеПараметры.Добавить("Периодичность");
	//	КонецЕсли;
	//КонецЕсли;
	//
	//ВспомогательныеПараметры.Добавить("КоличественныеИтогиПоЕдИзм");
	//ВспомогательныеПараметры.Добавить("МаксимумСерийКоличество");
	//ВспомогательныеПараметры.Добавить("ВыделениеСерийДиаграмм");
	//ВспомогательныеПараметры.Добавить("ОтслеживаемыеАналитики");
	//ВспомогательныеПараметры.Добавить("ГрадиентСерийДиаграмм");
	//ВспомогательныеПараметры.Добавить("ОтображениеМаркеровТочекДиаграмм");
	//
	//КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;

КонецФункции
Функция СтруктураЗаголовковПолей()
	СтруктураЗаголовковПолей = Новый Структура;
	
	//СтруктураЗаголовковВалют = КомпоновкаДанныхСервер.СтруктураЗаголовковВалютСквознаяСебестоимость(КомпоновщикНастроек);
	//ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураЗаголовковПолей, СтруктураЗаголовковВалют, Ложь);
	//
	//СтруктуруЗаголовковПолейЕдиницИзмерений = КомпоновкаДанныхСервер.СтруктураЗаголовковПолейЕдиницИзмерений(КомпоновщикНастроек);
	//ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураЗаголовковПолей, СтруктуруЗаголовковПолейЕдиницИзмерений, Ложь);
	
	Возврат СтруктураЗаголовковПолей;
КонецФункции
Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Организация");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Склад");
	КонецЕсли;
	
	//Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов") Тогда
	//	КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(КомпоновщикНастроекФормы, "ЕдиницыКоличества");
	//КонецЕсли;
	
КонецПроцедуры
Функция ПолучитьФиксированныеНастройкиПродажиПоСегменту(ПараметрКоманды)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		ЭтоМассив = Истина;
		Если ПараметрКоманды.Количество() > 0 Тогда
			ПервыйЭлемент = ПараметрКоманды[0];
		Иначе
			ПервыйЭлемент = Неопределено;
		КонецЕсли;
	Иначе
		ЭтоМассив = Ложь;
		ПервыйЭлемент = ПараметрКоманды;
	КонецЕсли;
	
	ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных();
	ЭлементОтбора = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	
	ЭлементОтбора.ПравоеЗначение = СегментыВызовСервера.СписокЗначений(ПервыйЭлемент);
	
	Возврат ФиксированныеНастройки;
	
КонецФункции
#КонецОбласти

#КонецЕсли

#Область СведенияОВнешнейОбработке
Функция СведенияОВнешнейОбработке() Экспорт 

	ПараметрыРегистрации = Новый Структура;
	
	ПараметрыРегистрации.Вставить("Вид", 				"ДополнительныйОтчет");
	ПараметрыРегистрации.Вставить("Назначение", 		"");
	ПараметрыРегистрации.Вставить("Наименование", 		НСтр("ru = '<АМ> Расчеты по КМ (версия 3.6)'"));
	ПараметрыРегистрации.Вставить("Версия", 			"3.6");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", 	ИСТИНА);
	ПараметрыРегистрации.Вставить("Информация", 		НСтр("ru = 'Отчет: ""Расчеты по КМ (версия 3.6)""'"));
	
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	
	ДобавитьКоманду(ТаблицаКоманд,
					НСтр("ru = '<АМ> Расчеты по КМ (версия 3.6)'"),
					"<АМ> Расчеты по КМ (версия 3.6)",
					"ОткрытиеФормы",
					Истина,
					"");
	
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;       	
	
КонецФункции
Функция ПолучитьПараметрыРегистрации(ОбъектыНазначенияФормы = Неопределено, НаименованиеОбработки = "", Информация = "", Версия = "1.0.0") 
	
	Если ТипЗнч(ОбъектыНазначенияФормы) = Тип("Строка") Тогда 
		ОбъектНазначенияФормы = ОбъектыНазначенияФормы; 
		ОбъектыНазначенияФормы = Новый Массив; 
		ОбъектыНазначенияФормы.Добавить(ОбъектНазначенияФормы); 
	КонецЕсли; 
	ПараметрыРегистрации = Новый Структура; 
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма"); 
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Истина); 
	ПараметрыРегистрации.Вставить("Назначение", ОбъектыНазначенияФормы); 
	Если Не ЗначениеЗаполнено(НаименованиеОбработки) Тогда 
		НаименованиеОбработки = ЭтотОбъект.Метаданные().Представление();
	КонецЕсли; 
	ПараметрыРегистрации.Вставить("Наименование", НаименованиеОбработки); 
	Если Не ЗначениеЗаполнено(Информация) Тогда 
		Информация = ЭтотОбъект.Метаданные().Комментарий; 
	КонецЕсли; ПараметрыРегистрации.Вставить("Информация", Информация); 
	ПараметрыРегистрации.Вставить("Версия", Версия); 
	
	Возврат ПараметрыРегистрации;
	
КонецФункции
Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений; 
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка")); 
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка")); 
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка")); 
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево")); 
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка")); 
	
	Возврат Команды; 
	
КонецФункции
Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	
	// Добавляем команду в таблицу команд по переданному описанию. 
	// Параметры и их значения можно посмотреть в функции ПолучитьТаблицуКоманд 
	НоваяКоманда 						= ТаблицаКоманд.Добавить(); 
	НоваяКоманда.Представление 			= Представление; 
	НоваяКоманда.Идентификатор 			= Идентификатор; 
	НоваяКоманда.Использование 			= Использование; 
	НоваяКоманда.ПоказыватьОповещение 	= ПоказыватьОповещение; 
	НоваяКоманда.Модификатор 			= Модификатор; 
	
КонецПроцедуры
#КонецОбласти

#Область ВременныйКостыль
// временный костыль от 21.08.2018 (действует до обновления рабочей базы)
Процедура ПровестиПоРегиструРасчетовПоКМПодготовленныеНачисленияКМ()
	
	Если НЕ РольДоступна("ПолныеПрава") И НЕ РольДоступна("_РедактированиеКМ") Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	_НачислениеКМ.Ссылка КАК Ссылка,
	|	_НачислениеКМ.Дата КАК Дата
	|ПОМЕСТИТЬ втНачисленияКМ
	|ИЗ
	|	Документ._НачислениеКМ КАК _НачислениеКМ
	|ГДЕ
	|	_НачислениеКМ.Статус В(&АктивныеСтатусы)
	|	И _НачислениеКМ.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	_РасчетыПоКМОбороты.Регистратор КАК Регистратор
	|ПОМЕСТИТЬ втРегистраторы
	|ИЗ
	|	РегистрНакопления._РасчетыПоКМ.Обороты(, , Регистратор, ) КАК _РасчетыПоКМОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНачисленияКМ.Ссылка КАК Регистратор,
	|	втНачисленияКМ.Дата КАК Дата
	|ИЗ
	|	втНачисленияКМ КАК втНачисленияКМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ втРегистраторы КАК втРегистраторы
	|		ПО втНачисленияКМ.Ссылка = втРегистраторы.Регистратор
	|ГДЕ
	|	втРегистраторы.Регистратор ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Ссылка
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	АктивныеСтатусы = Новый Массив;
	АктивныеСтатусы.Добавить(Перечисления.СтатусыПланов.ВПодготовке);
	АктивныеСтатусы.Добавить(Перечисления.СтатусыПланов.НаУтверждении);
	АктивныеСтатусы.Добавить(Перечисления.СтатусыПланов.Утвержден);
	
	Запрос.УстановитьПараметр("АктивныеСтатусы", АктивныеСтатусы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ПровестиПоРегиструРасчетовПоКМДокументНачисленияКМ(Выборка.Регистратор);
	КонецЦикла;

	
КонецПроцедуры
Процедура ПровестиПоРегиструРасчетовПоКМДокументНачисленияКМ(Ссылка)
	
	ДокументОбъект = Ссылка.ПолучитьОбъект();
	ДополнительныеСвойства = ДокументОбъект.ДополнительныеСвойства;

	ДополнительныеСвойства.Вставить("ЭтоНовый",    				Ложь);
	ДополнительныеСвойства.Вставить("РежимЗаписи", 				РежимЗаписиДокумента.Проведение);  
	ДополнительныеСвойства.Вставить("ПерепровестиОтвязанные", 	ПолучитьОтвязанныеДокументыоплаты(ДокументОбъект));    
	
	ТаблицаДвижений = АльтернативноИнициализироватьДанныеДокумента(Ссылка);
	
	Если ТаблицаДвижений.Количество() > 0 Тогда
		
		ДвиженияРасчеты = ДокументОбъект.Движения._РасчетыПоКМ;
		ДвиженияРасчеты.Загрузить(ТаблицаДвижений);
		ДвиженияРасчеты.Записать();

	КонецЕсли;

	// тут же сформируем движения по регистру КМ по всем заявкам, привязанным к начислению ->
	ДополнительныеСвойства.Вставить("ДвиженияПоЗаявкамИзНачисленияКМ_РасчетыПоКМ", Новый Соответствие);	
	_КМ.ИнициализироватьДанныеДокумента_ЗаявкаНаРасходованиеСредств(ДокументОбъект.ДокументыОплаты.ВыгрузитьКолонку("ДокументОплаты"), ДополнительныеСвойства);		
	Если ДополнительныеСвойства.Свойство("ПерепровестиОтвязанные") Тогда 
		_КМ.ИнициализироватьДанныеДокумента_ЗаявкаНаРасходованиеСредств(ДополнительныеСвойства.ПерепровестиОтвязанные, ДополнительныеСвойства);
	КонецЕсли;
	Если ДополнительныеСвойства.ДвиженияПоЗаявкамИзНачисленияКМ_РасчетыПоКМ.Количество() >0 Тогда 
		Рег = РегистрыНакопления._РасчетыПоКМ.СоздатьНаборЗаписей();
		Для Каждого ТаблицаДвиженийПоЗаявке Из ДополнительныеСвойства.ДвиженияПоЗаявкамИзНачисленияКМ_РасчетыПоКМ Цикл
			Рег.Отбор.Регистратор.Установить(ТаблицаДвиженийПоЗаявке.Ключ);
			Рег.Загрузить(ТаблицаДвиженийПоЗаявке.Значение);
			Рег.Записать(Истина);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры
Функция АльтернативноИнициализироватьДанныеДокумента(ДокументСсылка) 
		
	Запрос = Новый Запрос; 	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	ИСТИНА КАК Активность,
	|	0 КАК ЗаявленоКВыплате,
	|	НачислениеПоДокументамПродажи.Ссылка.Дата КАК Период,
	|	НачислениеПоДокументамПродажи.Ссылка.Партнер КАК Партнер,
	|	НачислениеПоДокументамПродажи.Ссылка.УсловиеКМ КАК Условие,
	|	НачислениеПоДокументамПродажи.ДокументПродажи КАК ДокументПродажи,
	|	СУММА(НачислениеПоДокументамПродажи.СуммаКМ) КАК Начислено
	|ИЗ
	|	Документ._НачислениеКМ.НачислениеПоДокументамПродажи КАК НачислениеПоДокументамПродажи
	|ГДЕ
	|	НачислениеПоДокументамПродажи.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	НачислениеПоДокументамПродажи.ДокументПродажи,
	|	НачислениеПоДокументамПродажи.Ссылка.УсловиеКМ,
	|	НачислениеПоДокументамПродажи.Ссылка.Партнер,
	|	НачислениеПоДокументамПродажи.Ссылка.Дата
	|
	|ИМЕЮЩИЕ
	|	СУММА(НачислениеПоДокументамПродажи.СуммаКМ) <> 0";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);

	Возврат Запрос.Выполнить().Выгрузить();
		
КонецФункции
Функция ПолучитьОтвязанныеДокументыоплаты(ДокОбъект)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	_НачислениеКМДокументыОплаты.ДокументОплаты КАК ДокументОплаты
	|ПОМЕСТИТЬ СтароеСостояниеТабличнойЧасти
	|ИЗ
	|	Документ._НачислениеКМ.ДокументыОплаты КАК _НачислениеКМДокументыОплаты
	|ГДЕ
	|	_НачислениеКМДокументыОплаты.Ссылка = &Ссылка
	|	И _НачислениеКМДокументыОплаты.Ссылка.Статус = &Утвержден
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущаяТЧ.ДокументОплаты КАК ДокументОплаты
	|ПОМЕСТИТЬ НовоеСостояниеТабличнойЧасти
	|ИЗ
	|	&ТекущаяТЧ КАК ТекущаяТЧ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтароеСостояниеТабличнойЧасти.ДокументОплаты КАК ДокументОплаты
	|ИЗ
	|	СтароеСостояниеТабличнойЧасти КАК СтароеСостояниеТабличнойЧасти
	|		ЛЕВОЕ СОЕДИНЕНИЕ НовоеСостояниеТабличнойЧасти КАК НовоеСостояниеТабличнойЧасти
	|		ПО СтароеСостояниеТабличнойЧасти.ДокументОплаты = НовоеСостояниеТабличнойЧасти.ДокументОплаты
	|ГДЕ
	|	НовоеСостояниеТабличнойЧасти.ДокументОплаты ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("Ссылка", 	ДокОбъект.Ссылка);
	Запрос.УстановитьПараметр("Утвержден", 	Перечисления.СтатусыПланов.Утвержден);
	Запрос.УстановитьПараметр("ТекущаяТЧ", 	ДокОбъект.ДокументыОплаты.Выгрузить());
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДокументОплаты");
	
КонецФункции

#КонецОбласти


