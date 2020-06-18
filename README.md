# ПРИБЛИЖЕННЫЙ МЕТОД РАСЧЕТА СУММАРНОГО ИСПАРЕНИЯ В МОДЕЛИ ФОРМИРОВАНИЯ СТОКА ECOMAG
Программный код расчетов и набор исходных данных для статьи, авторы Мотовилов Ю.Г., Морейдо В.М., Миллионщикова Т.Д.
Код разработан В.М. Морейдо.

## Методика расчетов
Для аппроксимации суточных значений дефицита влажности воздуха использовалась общая зависимость вида:
<img src="https://render.githubusercontent.com/render/math?math=d=a*e^{(b*t-c*p)}">

где *d* – среднесуточный дефицит влажности воздуха, мБар; *t* – среднесуточная температура воздуха, °С; *p* – суточная сумма осадков, мм; *a, b, с* – эмпирические коэффициенты. 
Варианты оценки параметров эмпирической зависимости приведены в таблице.
|Вариант	|a|	b|	c|
| --- | --- | --- | --- |
|1	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p=0}" title="{d\|}_{p=0}" />	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p=0}" title="{d\|}_{p=0}" />	|0.0
|2	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p=0}" title="{d\|}_{p=0}" />	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p=0}" title="{d\|}_{p=0}" /> 	|0.1
|3	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p=0}" title="{d\|}_{p=0}" />	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p=0}" title="{d\|}_{p=0}" /> 	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p>0}" title="{d\|}_{p>0}" />
|4	|2.0	|0.08	|0.1
|5	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p>0}" title="{d\|}_{p>0}" />	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p>0}" title="{d\|}_{p>0}" />	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p>0}" title="{d\|}_{p>0}" />
|6	|Подбор по <img src="https://latex.codecogs.com/gif.latex?{d\|}_{p>0}" title="{d\|}_{p>0}" />	|0.08	|0.1
