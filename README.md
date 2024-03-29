# ПРИБЛИЖЕННЫЙ МЕТОД РАСЧЕТА СУММАРНОГО ИСПАРЕНИЯ В МОДЕЛИ ФОРМИРОВАНИЯ СТОКА ECOMAG
Программный код расчетов и набор исходных данных для одноименной научной статьи, 
авторы Мотовилов Ю.Г., Морейдо В.М., Миллионщикова Т.Д.
Код разработан В.М. Морейдо.

## Методика расчетов
Для аппроксимации суточных значений дефицита влажности воздуха использовалась общая зависимость вида:

$$d=a*e^{(b*t-c*p)}$$

где *d* – среднесуточный дефицит влажности воздуха, мБар; *t* – среднесуточная температура воздуха, °С; *p* – суточная сумма осадков, мм; *a, b, с* – эмпирические коэффициенты. 
Варианты оценки параметров эмпирической зависимости приведены в таблице.
|Вариант	|*a*|	*b*|	*c*|
| --- | --- | --- | --- |
|1	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p=0}" title="{d\|}_{p=0}" />	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p=0}" title="{d\|}_{p=0}" />	|0.0
|2	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p=0}" title="{d\|}_{p=0}" />	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p=0}" title="{d\|}_{p=0}" /> 	|0.1
|3	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p=0}" title="{d\|}_{p=0}" />	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p=0}" title="{d\|}_{p=0}" /> 	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p>0}" title="{d\|}_{p>0}" />
|4	|2.0	|0.08	|0.1
|5	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p>0}" title="{d\|}_{p>0}" />	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p>0}" title="{d\|}_{p>0}" />	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p>0}" title="{d\|}_{p>0}" />
|6	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p>0}" title="{d\|}_{p>0}" />	|0.08	|0.1


В вариантах 1 – 3 подбор коэффициентов *a* и *b* производился по значениям дефицита влажности воздуха только в дни без осадков. Подбор коэффициента *c* в вариантах 3, 5 и 6, а также коэффициентов *a* и *b* в вариантах 5 и 6 – по значениям дефицита влажности во все дни во все дни. 

## Программная реализация
Код для расчетов написан на языке R. Для подбора коэффициентов нелинейной аппроксимации используется встроенная в base R функция `nls` - 
нелинейных наименьших квадратов. 

## Исходные данные и ограничения
В качестве исходной информации для проведения статистических расчетов послужил выверенный архив массив данных ВНИИГМИ-МЦД ([Булыгина и др., 2014](http://meteo.ru/data/163-basic-parameters#описание-массива-данных)), содержащий среднесуточные данные по температуре, осадкам и дефицитам влажности воздуха на 1719-ти метеорологических станциях России за период с 1966 по 2014 г.

*В связи с ограничениями, авторы не могут распространять весь использованный архив данных. С целью воспроизводимости расчетов, мы предоставляем часть архива - данные за весь период наблюдений по 16 случайно выбранным из массива станциям.*

