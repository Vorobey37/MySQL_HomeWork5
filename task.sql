
/*Для решения задач используйте базу данных lesson_4
(скрипт создания, прикреплен к 4 семинару).
*/
use semimar_4;

/*1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия,
город и пол), которые не старше 20 лет.
*/
select * from users;
select * from profiles;

create or replace view info as 
select u.firstname, u.lastname, p.hometown, p.gender
from users as u
join profiles as p
on u.id = p.user_id
where TIMESTAMPDIFF(year, p.birthday, curdate()) <= 20;

select * from info;

/*2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите
ранжированный список пользователей, указав имя и фамилию пользователя, количество
отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным
количеством сообщений) . (используйте DENSE_RANK)
*/
select * from users;
select * from messages;

create or replace view sum_of_messages as
select 
	u.firstname, 
    u.lastname,
	sum(m.id) over (partition by m.from_user_id) as sum    
from users as u
join messages as m
on u.id = m.from_user_id;

select 
	distinct firstname,
    lastname,
	sum,
    dense_rank() over (order by sum desc) as "рейтинг"
from sum_of_messages;

/*3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления
(created_at) и найдите разницу дат отправления между соседними сообщениями, получившегося
списка. (используйте LEAD или LAG)
*/
select * from messages;

# Способ с использованием представления
create or replace view dates as
select 
	body,
    created_at,
	lag(created_at) over (order by created_at) as lag_date
from messages;

select
	body,
    created_at,
    timestampdiff(minute, lag_date, created_at) as "разница в минутах между временем предыдущего сообщения"
from dates;

#Способ без использования представления
select 
	body,
    created_at,
	timestampdiff(minute, lag(created_at) over (order by created_at), created_at) as "разница в минутах между временем предыдущего сообщения"
from messages;
    