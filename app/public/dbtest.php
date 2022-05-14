<?php

$pdo = new PDO(
	'mysql:dbname=db_name;host=mysql',
	'admin',
	'admin',
	[PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
);

$query = $pdo->query('SHOW VARIABLES like "version"');

$row = $query->fetch();

var_dump($row);
