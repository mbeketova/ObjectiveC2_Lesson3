# ObjectiveC2_Lesson3
v1
/*ДЗ : реализовать TableView поверх MapView.
По Лог Пресс добавлять адрес точки касания в массив. При нажатии на кнопку перезагружать таблицу и добовлять аннотации на карту.
При нажатии на табличную ячейку должен происходить фокус на конкретную аннотацию*/


//Примечание: Реализовала TableView,  MapView. По Лонг Пресс добавляется адрес точки касания в массив и устанавливается маркер.
//Добавила две кнопки. При нажатии на кнопку: Добавить - добавляются все отмеченные маркером аннотации в массив, а
//сама карта от аннотаций очищается.
//При нажатии на кнопку: Очистить - очищаются все аннотации (кроме того, очищается массив и таблица убирается).
//При нажатии на табличную ячейку происходит фокус на конкретную аннотацию (устанавливается маркер). Кроме того, в таблице можно удалить адрес (при удалении так же удаляется и аннотация с карты).

//--------------------------------------------------------------------------------------------------------------------------
