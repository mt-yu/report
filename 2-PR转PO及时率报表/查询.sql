--查到所有的表、外键等信息
select * from sysobjects where  type = 'U'
-- syscolumns 列具体信息

-- sysforeignkeys  外键信息
select * from sysforeignkeys 

select * from sysobjects where name = 'PR_PRLine'

--查询数据库表的所有外键信息

SELECT 主键表名称=object_name(b.rkeyid)

    ,主键列ID=b.rkey

    ,主键列名=(SELECT name FROM syscolumns WHERE colid=b.rkey AND id=b.rkeyid)

    ,外键表ID=b.fkeyid

    ,外键表名称=object_name(b.fkeyid)

    ,外键列ID=b.fkey

    ,外键列名=(SELECT name FROM syscolumns WHERE colid=b.fkey AND id=b.fkeyid)

    ,级联更新=ObjectProperty(a.id,'CnstIsUpdateCascade')

    ,级联删除=ObjectProperty(a.id,'CnstIsDeleteCascade')

FROM sysobjects a

    join sysforeignkeys b on a.id=b.constid

    join sysobjects c on a.parent_obj=c.id

WHERE a.xtype='F' AND c.xtype='U'



-----------------------------------------------------------------------------------------------------
-- 找出所有的PR
select A.ID AS '请购单ID' ,B.PR AS '请购单行ID'  from PR_PR AS A LEFT JOIN PR_PRLine AS B ON A.ID = B.PR where A.Org = '1001708020135665' 

PR30181207001

select SourceType ,count(*) as 计数 from PR_PR  where Org = '1001708020135665' group by SourceType order by '计数'

select DOCNO from PR_PR WHERE ID = '1001808081286234'


SELECT PR FROM PR_PRLine WHERE  CurrentOrg = '1001708020135665'

select PR ,count(*) as 计数 from PR_PRLine  where CurrentOrg = '1001708020135665' group by PR order by '计数'
select ApprovedQtyPU      from PR_PRLine  WHERE PR = '1001812070405908'

select * from CBO_ItemMaster WHERE ID = '1001708090328390'



select ID from Base_Currency

select ID from PM_POLine WHERE CurrentOrg = '1001708020135665'
SELECT * FROM PM_POLine where PurchaseOrder = '1001810290546470'
select PurchaseOrder ,count(*) as 计数 from PM_POLine   where CurrentOrg = '1001708020135665' group by PurchaseOrder order by '计数'
------------------------------------------------------------------------------------------------------------------------------------


-- 找出所有的PR  表一
	-- 统计 以PR 分组的 PR行 计数
	select A.DocNo,count(*) 计数 INTO #TEMP1 from PR_PR A left join PR_PRLine B ON A.ID = B.PR WHERE A.ORG = '1001708020135665'  group by A.DocNo order by '计数'
	-- 所有PR 行
	select A.DocNo from PR_PR A left join PR_PRLine B ON A.ID = B.PR WHERE A.ORG = '1001708020135665'

-- 找出PO - POLINE 下 所有有来源单号 不为空的 数据集 （即PR - PO 的 数据集）
	-- 找出所有的 PR 转 PO 的 PO 行
	select b.SrcDocInfo_SrcDocNo from PM_PurchaseOrder A left join PM_POLine B on A.ID = B.PurchaseOrder WHERE A.ORG = '1001708020135665'  AND B.SrcDocInfo_SrcDocNo <> '' 
	-- 统计 以 PR DOCNO 分组 的 POLINE 计数
	select b.SrcDocInfo_SrcDocNo, count(*) 计数  INTO #TEMP2 from PM_PurchaseOrder A left join PM_POLine B on A.ID = B.PurchaseOrder WHERE A.ORG = '1001708020135665'  AND B.SrcDocInfo_SrcDocNo <> '' group by b.SrcDocInfo_SrcDocNo order by '计数'
	select * from #TEMP2
-- 找出 PR 中 没有 转 PO 的 PR 单号
	select A.DocNo, A.计数 from #TEMP1 A left join #TEMP2 B on A.DocNo = B.SrcDocInfo_SrcDocNo WHERE B.SrcDocInfo_SrcDocNo IS NULL


-- 请购单有 340 行 ， 但是 采购订单有323 行  （列出PR 对应 多个 PO 的 举例）
	-- 找出 请购的 340 行		
	SELECT * FROM PR_PR WHERE ORG = '1001708020135665' AND DocNo = 'PR30181008002'
	SELECT * FROM PR_PRLine WHERE CurrentOrg = '1001708020135665' AND PR = '1001810085997829'

	-- 找出 采购的 323 行 以及其对应的 采购单 
	select * from PM_POLine where CurrentOrg =  '1001708020135665' and SrcDocInfo_SrcDocNo = 'PR30181008002'
	select PurchaseOrder, COUNT(*) '计数' from PM_PurchaseOrder A left join PM_POLine B ON A.ID = B.PurchaseOrder WHERE A.ORG = '1001708020135665' AND B.SrcDocInfo_SrcDocNo = 'PR30181008002' GROUP BY B.PurchaseOrder ORDER BY '计数'

	-- 说明 一个 PR 可能 对应 多个 PO ， 并且 请购单行 与 采购单行的数量也对应不上
	-- 例子：行号为1510 的 需求 数量与核准数量对不上 可能是分多次采购的 抓住这个点找   其追溯查询的 采购订单号为 ：PO30181009044
	-- 可以用来源单 和 来单行 去精确匹配