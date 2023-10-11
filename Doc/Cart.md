Танеев Тимур
<br /> Когорта: 6
<br /> Группа: 5
<br /> Эпик: Корзина
<br /> Ссылка на доску: [https://github.com/users/Skoch33/projects/2](https://github.com/users/Skoch33/projects/2)

# Cart Flow Decomposition


## Экран "Cart" (est: 19h; fact: )

#### Верстка
- Таблица (est: 2h; fact: 2h)
- Ячейка (est: 3h; fact: 4h)
- Панель оплаты (est: 2h; fact: 3h)
- Navigation Bar (est: 1h; fact: 1h)
- Пустая корзина (est: 1h, fact: 0.5h)

`Total:` est:  9h; fact: 10.5h 

#### Логика
- Сервис "Получение заказа `apiV1Orders1Get`" (est: 3h; fact: 3h)
- Сервис "Получение NFT с заданным Id `apiV1NftNftIdGet`" (est: 1h; fact: 2h)
- viewModel логики экрана, подключение viewModel (est: 5h; fact: )
- Сортировка (est: 1h; fact: )
- Сохранить способ сортировки (est: 1h; fact: )

`Total:` est: 11h; fact: 

## Экран "Delete From Cart" (est 5h; fact: )

#### Верстка
- Верстка всего экрана (est: 1h; fact: )

`Total:` est: 1h; fact: 

#### Логика
- Сервис "Изменение заказа `apiV1Orders1Put`" (est: 3h; fact: )
- viewModel экрана (est: 1h; fact: )

`Total:` est: 4h; fact: 

## Экран "Выбор способа оплаты" (est: 16h; fact: )

#### Верстка
- Коллекция валют (est: 2h; fact: )
- Ячейка (валюта) (est: 1h; fact: )
- Navigation Bar (est: 1h; fact: )
- Панель оплаты (est: 1h; fact: )

`Total:` est: 5h; fact: 

#### Логика
- Сервис "Получение списка валют `apiV1CurrenciesGet`" (est: 3h; fact: )
- Сервис "Получение валюты с заданным id `apiV1CurrenciesCurrencyIdGet`" (est: 2h; fact: )
- Сервис "Оплата заказа валютой с заданным id `apiV1Orders1PaymentCurrencyIdGet`" (est: 2h; fact: )"
- viewModel экрана, выбор валюты (est: 3h, fact: )
- Оплата (est: 1h,  fact: )

`Total:` est: 11h; fact: 

## Экран результатов оплаты "Успех/Упс" (est: 2h; fact: )

#### Верстка
- Верстка всего экрана (est: 1h; fact: )

`Total:` est: 1h; fact: 

#### Логика
- viewModel, логика экрана (est: 1h,  fact: )

`Total:` est: 2h; fact: 

