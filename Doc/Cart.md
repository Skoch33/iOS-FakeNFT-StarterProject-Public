Танеев Тимур
<br /> Когорта: 6
<br /> Группа: 5
<br /> Эпик: Корзина
<br /> Ссылка на доску: [https://github.com/users/Skoch33/projects/2](https://github.com/users/Skoch33/projects/2)

# Cart Flow Decomposition


## Итерация 1 (est: 18h; fact: 19.5)
#### Экран "Cart"
- Верстка таблицы (est: 2h; fact: 2h)
- Верстка ячейки (est: 3h; fact: 4h)
- Верстка панели оплаты (est: 2h; fact: 3h)
- Верстка Navigation Bar (est: 1h; fact: 1h)
- Верстка экрана "Пустая корзина" (est: 1h, fact: 0.5h)
- Сервис "Получение заказа `apiV1Orders1Get`" (est: 3h; fact: 3h)
- Сервис "Получение NFT с заданным Id `apiV1NftNftIdGet`" (est: 1h; fact: 2h)
- viewModel логики экрана, подключение viewModel (est: 5h; fact: 4h)

`Total:` est:  18h; fact: 19.5h 

## Итерация 2 (est: 14h; fact: 11.5h)
#### Экран "Cart"
- Реализовать сортировку (est: 1h; fact: 1h)
- Сохранение способа сортировки (est: 1h; fact: 0.5h)

#### Экран "Delete From Cart"
- Верстка экрана (est: 1h; fact: 2h)
- Сервис "Изменение заказа `apiV1Orders1Put`" (est: 3h; fact: 2h)
- viewModel экрана (est: 1h; fact: 1h)

#### Экран "Выбор способа оплаты"
- Сервис "Получение списка валют `apiV1CurrenciesGet`" (est: 3h; fact: 2h)
- Сервис "Получение валюты с заданным id `apiV1CurrenciesCurrencyIdGet`" (est: 2h; fact: 2h)
- Сервис "Оплата заказа валютой с заданным id `apiV1Orders1PaymentCurrencyIdGet`" (est: 2h; fact: 1h)"

`Total:` est: 14h; fact: 11.5h

## Итерация 3 (est: 16h; fact: 14h)
#### Экран "Выбор способа оплаты"
- Верстка: Коллекция валют (est: 2h; fact: 2h)
- Верстка: Ячейка (валюта) (est: 3h; fact: 3h)
- Верстка: Navigation Bar (est: 1h; fact: 0.5h)
- Верстка: Панель оплаты (est: 2h; fact: 1h)
- viewModel экрана, выбор валюты (est: 3h, fact: 3h)
- Оплата (est: 1h,  fact: 0.5h)
- webView "Пользовательское соглашение" (est: 2h, fact: 2h)

#### Экран результатов оплаты "Успех/Упс"
- Верстка всего экрана (est: 1h; fact: 1h)
- viewModel, логика экрана (est: 1h,  fact: 1h)

`Total:` est: 16h; fact: 14h
