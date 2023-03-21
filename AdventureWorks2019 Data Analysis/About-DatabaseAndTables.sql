-- USE AdventureWorks2019;


-- all system objects in the databse
select * from sys.objects;

-- all scheams in the database
select * from sys.schemas;

-- All tables in database
select * from sys.tables;


-- about the adventure works database objects and tables 
-- count of each object type in the adventure works database
select 
		type_desc, 
		count(type_desc) total_count 
from	sys.objects 
		group by type_desc 
		order by 2 desc;


/*
we have total 71 user_tables.
71 primary_key_constraint
20 Views
10 stored procedures and triggers
*/

-- count of schemas, tables, and columns 
select count(DISTINCT s.name) as SchemaName,
	   count(Distinct t.name) as TableName,
	   count(c.name) as ColumnName
from sys.tables t
	   JOIN sys.columns c on c.object_id = t.object_id     
	   INNER JOIN sys.schemas s on s.schema_id = t.schema_id

/*
486 rows or columns in the database 
71 tables 
6 Schemas 
*/

-- same query as above with INFORMATION_SCHEMA
select 
		count(distinct TABLE_SCHEMA) as Table_Schema, 
		count(distinct TABLE_NAME) as table_name,
		count(COLUMN_NAME) as coulmn_name
from    INFORMATION_SCHEMA.COLUMNS
		where 
			TABLE_NAME not in(select TABLE_NAME from INFORMATION_SCHEMA.VIEWS)
/*
Same as above query
486 rows or columns in the database 
71 tables 
6 Schemas 
*/


select s.name as SchemaName,
	   t.name as TableName,
	   c.name as ColumnName
from   sys.tables t
	   JOIN sys.columns c on c.object_id = t.object_id     
	   INNER JOIN sys.schemas s on s.schema_id = t.schema_id
/*
All column name inside each table name under each Schma
*/




-- Check constraints 
select 
		t.name as TableName,
		c.name as ColumnName,
		cc.name as CheckConstraintName,
		cc.definition as CheckConstraintsDefinition
	from AdventureWorks2019.sys.check_constraints cc 
		inner join AdventureWorks2019.sys.tables t on t.object_id = cc.parent_object_id
		left join AdventureWorks2019.sys.columns c on c.object_id = cc.parent_object_id
		and c.column_id = cc.parent_column_id


/*
89 rows - constraints
left join and inner join give different number of constraint. 
because some constraint are on tables only. or multiple constraint applies on columns. 

TableName			ColumnName		CheckConstraintname							Check Constraint header
SalesOrderHeader	Freight			CK_SalesOrderHeader_Freight					([Freight]>=(0.00))
EmployeePayHistory	PayFrequency	CK_EmployeePayHistory_PayFrequency			([PayFrequency]=(2) OR [PayFrequency]=(1))
EmployeePayHistory	Rate			CK_EmployeePayHistory_Rate					([Rate]>=(6.50) AND [Rate]<=(200.00))

...
*/


-- Analyzing default constraints 
select 
		type_desc, 
		count(type_desc) total_count 
	from sys.objects 
	where 
		type_desc = 'DEFAULT_CONSTRAINT'
		group by type_desc 
		order by 2 desc;

-- 152 constraints

-- tables and columns are these constraints on. And what are the default values?
select	
			s.name as schemaName,
			t.name as tableName,
			c.name as columnName, 
			dc.name as defaultConstraintName,
			dc.definition as defaultConstraintDefinition
	from sys.default_constraints dc
			INNER JOIN sys.tables t on
			dc.parent_object_id = t.object_id
			inner join sys.schemas s on s.schema_id = dc.schema_id
			inner join sys.columns c on c.column_id = dc.parent_column_id and c.object_id = dc.parent_object_id
-- defaultConstraintDefinition tells about the default values




-- find every column in the database that includes "rate" in the column name.
-- find every table in the database that includes "history" in the column name.
select 
			t.name as TableName, 
			c.name as ColumnName
from 		sys.tables t 
			inner join sys.columns c on t.object_id = c.object_id
where 1=1 and
			-- t.name like '%history%';
			c.name like '%rate%';




-- count of each data type in the AdventureWorks Database and finding most used data type.
	select 
			data_type, 
			count(*) AS dataTypeCount
	from 
			INFORMATION_SCHEMA.COLUMNS
	group by 
			DATA_TYPE
	order by count(*) desc;


-- Using a case statement create a data type grouping and summarizes each data type as one of the Groups
select 
		case when CHARACTER_MAXIMUM_LENGTH is not null then 'Character'
			when NUMERIC_PRECISION is not null then ' Neumeric'
			when DATETIME_PRECISION is not null then 'Date'
			else null
			end as 'DataTypeGroup',
			count(*) as DataTypeCount

	from INFORMATION_SCHEMA.COLUMNS
	GROUP BY
		case when CHARACTER_MAXIMUM_LENGTH is not null then 'Character'
				when NUMERIC_PRECISION is not null then ' Neumeric'
				when DATETIME_PRECISION is not null then 'Date'
				else null
				end
		order by count(*) desc;


-- data types in null group above
select 
			distinct data_type
	from 
			INFORMATION_SCHEMA.columns 
	where 
			CHARACTER_MAXIMUM_LENGTH is null 
			and NUMERIC_PRECISION is null 
			and DATETIME_PRECISION is null 


-- check for column name and definition of any table in database 
select 
		t.name as TableName,
		c.name as ColumnName,
		ep.value as Definition
	from 
		sys.extended_properties ep 
		inner join sys.tables t 
			on t.object_id = ep.major_id 
		inner join sys.columns c 
			on c.object_id = ep.major_id 
			and c.column_id = ep.minor_id 
	where class = 1
		and t.name = 'Person'