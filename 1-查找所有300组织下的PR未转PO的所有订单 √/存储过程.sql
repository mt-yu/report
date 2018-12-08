
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE p_lj_PR_PO
--@Org BIGINT,--组织编码
--@Code varchar(50),--料号编码
--@StartDate datetime,--起始时间
--@EndDate datetime--截至时间

as
BEGIN

if OBJECT_ID('tempdb..#temp') is not null
drop table #temp
-- ① 找出 所有 300 组织下 采购单中来源单据类型为 请购单 的集合
---- ①.a 找出所有采购单行下的 ***来源单据类型的ID*** 并统计 数目     SrcDocInfo_SrcDocTransType_EntityID(来源单据ID)
		SELECT SrcDocInfo_SrcDocTransType_EntityID as 来源单据类型ID, COUNT(*) as 次数 into #temp 
			from PM_PurchaseOrder A LEFT JOIN PM_POLine B ON A.ID = B.PurchaseOrder 
			where A.org = '1001708020135665' AND B.CurrentOrg = '1001708020135665' 
			GROUP BY SrcDocInfo_SrcDocTransType_EntityID 
			ORDER BY '次数' --DESC 
		SELECT * FROM #temp 
		-- 得到300组织下采购单的总数目
		SELECT SUM(#temp.次数) as 采购单行数 from #temp 

---- ①.b  找出所有***来源类别***为"请购单" 的			SrcDocType (来源类别 1 请购单  0 手工)
		select SrcDocInfo_SrcDocTransType_EntityID,count(*) as 次数  from PM_POLine where SrcDocType = '1' and CurrentOrg = '1001708020135665'  group by SrcDocInfo_SrcDocTransType_EntityID
---- ①.c  查找所有的采购单行
		select A.org from PM_PurchaseOrder A LEFT JOIN PM_POLine B ON A.ID = B.PurchaseOrder where A.org = '1001708020135665'
---- ①.d  得出 所有的采购单行 就是 由 手工单 和 请购单 组成  共28936条

-- ②从请购单表中找出所有的请购单行
---- ②.a 找出所有300组织下的请购订单行
		Select b.PR from PR_PR A left join PR_PRLine B ON A.ID = B.PR where CurrentOrg = '1001708020135665'
---- ②.b 




select org from PM_PurchaseOrder 

-- 找出所有来源类别 为 请购单的			SrcDocType (来源类别 1 请购单  2 手工)




if OBJECT_ID('tempdb..#temp1') is not null
drop table #temp1
select PRNO,SrcDocInfo_SrcDocTransType_EntityID  into #temp1 from PM_POLine where   CurrentOrg = '1001708020135665'

SELECT * FROM #temp 
select SrcDocInfo_SrcDocTransType_EntityID ,Count(*) as 次数 from #temp1 group by SrcDocInfo_SrcDocTransType_EntityID order by '次数'


END
GO

exec p_lj_PR_PO