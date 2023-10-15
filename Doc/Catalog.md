Алексей Тиньков
<br /> Кагорта: 6
<br /> Группа: 5
<br /> Эпик: Каталог

# Catalog Flow Decomposition

## I. Экран Catalogue (est: 390 min; fact: 370 min).

### Верстка
- навигационный бар и кнопка сортировки (est: 20 min; fact: 20 min).
- коллекция (est: 30 min; fact: 20 min).
- ячейки коллекции: картинка, название, количество NFT (est: 60 min; fact: 90 min).
- алерт сортировки (est: 30 min; fact: 10 min).

`Total:` est: 140 min; fact: 140 min).

### Логика
- загрузка каталога, индикатор загрузки (est: 180 min; fact: 150 min).
- сортировка (est: 30 min; fact: 30 min).
- сохранение порядка сортировки (est: 30 min; fact: 30 min).
- переход на экран коллекции (est: 10 min; fact: 10 min).
- алерт сетевых ошибок (fact: 10 min).

`Total:` est: 250 min; fact: 230 min).

## II. Экран Collection (est: 250 min; fact: 375 min) - верстка.
- обложка (est: 20 min; fact: 15 min).
- кнопка возврата на предыдущий экран (est: 20 min; fact: 40 min).
- название (est: 20 min; fact: 15 min).
- автор (est: 20 min; fact: 40 min).
- описание (est: 20 min; fact: 15 min).
- колекция (est: 30 min; fact: 30 min).
- ячейки коллкции: картинка, лайк, рейтинг, название, цена, корзина (est: 120 min; fact: 180 min).

`Total:` est: 250 min; fact: 335 min).

- WebView для страницы автора (not planned, fact: 40 min).


## III. Экран Collection (est: 590 min; fact: x min) - логика
- загрузка коллекции, индикатор загрузки (est: 180 min; fact: x min).
- возврат к экрану каталога (est: 20 min; fact: x min).
- переход на страницу автора (est: 20 min; fact: x min).
- лайк (est: 60 min; fact: x min).
- корзина (est: 60 min; fact: x min).

`Total:` est: 340 min; fact: x min).

# Дополнительные задачи, пересекающиеся с другими эпиками
- лаунчскрин
- определить цвета в ассетах
- верстка таббара кодом
- класс для работы с API

	
