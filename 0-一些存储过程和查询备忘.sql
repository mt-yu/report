--有关的表名

select * from CBO_PurchaseInfo	--料品采购相关信息 
select * from PM_PMMatchedDetail --采购匹配信息明细
select *  from Base_Organization   --组织机构
select * from PM_PurchaseContract	--采购合同

select *  from PM_PurchaseOrder where DocNo = 'PO30181121023'   --采购订单
select PRID,PRLINEID,PRNO  from PM_POLine where ID = '1001811210338995'  --采购订单行  --SrcDocInfo（SrcDocNo 来源单据号  SrcDocLineNo  源单据行号）来源单据

-- 找到 对应的请购 订单 和 请购订单行
select * from PR_PR	where DocNo = 'PR30181121005'	--请购订单
select * from PR_PRLine where PR = '1001811210317676'   --请购单行

select * from PR_PRDocType --请购单单据类型
select * from PM_PODocType --采购订单单据类型
-----------------------------------------------------------------------
--查找所有请购和采购单对应的
select a.id a,b.id b,b.PurchaseOrder from 
PM_PurchaseOrder a left join PM_POLine b on a.id =b.PurchaseOrder 
where ISNULL(SrcDocInfo_SrcDocNo, '')!='' and a.Org=(select id from Base_Organization where code = '300')



-----------------------------------------------------------------------
--参考 BOM 软件成本 的时间区段
exec sp_helptext SP_AuctusGetBomSoftAmount

exec sp_databases; --查看数据库
exec sp_tables;        --查看表
exec sp_columns 'PM_PurchaseOrder';--查看列

exec sp_helpIndex PM_PurchaseOrder;--查看索引
exec sp_helpConstraint PM_PurchaseOrder;--约束
exec sp_stored_procedures;	--查看所有存储过程
exec sp_helptext 'P_PM_FIClose' --查看存储过程创建、定义语句
exec sp_helpdb;--数据库帮助，查询数据库信息
exec sp_helpdb master;
exec SP_DEPENDS 'PM_PurchaseOrder' --显示有关数据库对象依赖关系的信息 (即有哪些函数或存储过程，视图依赖与这个表)

-----------------------------------------------------------------------
--保存存储过程 查找到的结果集到临时表

--获取某一个表的所有字段
if OBJECT_ID(N'tempdb..#p_columns',N'U') is not null
drop table #p_columns
create table #p_columns	--创建一个保存sp_columns 查找到的结果集
(
            TABLE_QUALIFIER		nvarchar(50),     
            TABLE_OWNER			nvarchar(50),
            TABLE_NAME			nvarchar(50),		   
            COLUMN_NAME			nvarchar(50),     --字段名  
            DATA_TYPE			int,               
            TYPE_NAME			nvarchar(50),     --类型名   
            "PRECISION"			int,     
            "LENGTH"			int,			  --长度
            SCALE				int,
            RADIX				int,  
            NULLABLE			bit,			  --是否可以为空
            REMARKS				bit,         
            COLUMN_DEF			nvarchar(50),   
            SQL_DATA_TYPE		int,       
            SQL_DATETIME_SUB	int,          
            CHAR_OCTET_LENGTH   int,       
            ORDINAL_POSITION    int,				--序号
            IS_NULLABLE         nvarchar(4),        --是否可以为空
            SS_DATA_TYPE		int,
)
insert into #p_columns exec sp_columns 'PR_PR'	--保存存储过程查找到的结果集到临时表
select COLUMN_NAME,TYPE_NAME,"LENGTH",NULLABLE from #p_columns --查找临时表中的要知道的列
go


------------------------------------------------------------------------------------------

if OBJECT_ID('tempdb..#temp') is not null
drop table #temp;

with 
t1 as
(
	select  b.PR,
			a.DocNo,
			a.PRDocType,
			b.ID,
			b.ItemInfo_ItemID,
			b.DocLineNo,
			b.ItemInfo_ItemCode,
			b.ItemInfo_ItemName,
			b.DeliveryDate
		from PR_PR a  left join PR_PRLine b
		on a.ID=b.PR 
		where Org=(select ID from Base_Organization where Code='300')  
),
t2 as
(
	select a.ID,
		    a.DocNo,
			a.CreatedOn,
			a.Status,
			b.DocLineNo,
			b.ItemInfo_ItemCode,
			b.ItemInfo_ItemName,
			b.ItemInfo_ItemID, 
			b.SrcDocInfo_SrcDocNo,
			b.PRID,	
			b.PRLineID,
			b.PRNO
		from PM_PurchaseOrder a left join PM_POLine b
		on a.ID=b.PurchaseOrder
		where Org=(select ID from Base_Organization where Code='300') 
)
select PR into #temp from t1 a left join t2 b on a.DocNo=b.PRNO
where ISNULL(PRNO,'')=''

select * from #temp


