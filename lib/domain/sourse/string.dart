abstract class TypeTransaction {
  static const expense = 'Расход';
  static const income = 'Приход';
  static const addIncome = 'Добавить приход';
  static const addExpense = 'Добавить расход';
  static const all = 'Все категории';
}

class ItemsDrawer {
 final String name;
final   int idex;
  ItemsDrawer(
     this.name,
     this.idex,
  );
}
final itemsDrawer = <ItemsDrawer>[ItemsDrawer('Транзакции',0),ItemsDrawer('Отчет по категориям',1),ItemsDrawer('Доходы/Расходы',3)];
