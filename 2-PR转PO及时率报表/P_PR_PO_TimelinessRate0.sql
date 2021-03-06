USE [U9TEST1129]
GO
/****** Object:  StoredProcedure [dbo].[P_PR_PO_TimelinessRate0]    Script Date: 2018/12/17 16:17:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[P_PR_PO_TimelinessRate0]
(
	@Org bigint,			 --组织
	@StartDT datetime,       --起始时间
	@EndDT	datetime,		 --结束时间
	@DescFlexField_PrivateDescSeg23 nvarchar(20), --执行采购员
	@CountPr int output,	 --请购行数
	@CountPrPo int output,	 --请购转采购行数
	@Ratio float output
--	@Code nvarchar(20),      --料号	
--	@Betimes nvarchar(10)='' --是否及时		
)
as 
begin
--	--创建临时表
	if OBJECT_ID(N'tempdb.dbo.#temp_Result', N'U')is  null
	begin
		create table #temp_Result
		(
			PR_DocNo nvarchar(50),				--PR单号
			PO_DocNo  nvarchar(50),				--PO单号
--			PPRNO nvarchar(50),					--PO来源单号（即PR单号）
			PApprovedOn datetime,				--PR审核时间
			PCreatedOn datetime,				--PO制单时间
			PRLine_ApprovedQtyPU decimal,		--PR核准数量
			POLine_PurQtyTU Decimal,			--采购单行的采购数量
			PItemInfo_ItemCode nvarchar(20),	--行料号
			PItemInfo_ItemName nvarchar(50),	--行料品品名
			PDescFlexField_PrivateDescSeg23 nvarchar(20)	--执行采购员
		)
	end
	else
	begin
		drop table #temp_Result
	end;
with 
cte1 as --找出300组织时间区间范围内的所有的请购单及请购单行：57906行
(
	select a.docno,		--请购单号
--		b.PR,			--请购ID
--		a.PRDocType,	--请购类型
		a.ApprovedBy,	--审核人
		a.ApprovedOn,	--审核日期
		b.ID,			--行ID
		b.DocLineNo,	--行号
		b.ItemInfo_ItemID,--料品ID
		b.ItemInfo_ItemCode,--料号
		b.ItemInfo_ItemName,--料品名
		b.ApprovedQtyPU		--核准数量
	from PR_PR a left join PR_PRLine b on a.ID=b.PR 
	where a.Org=@Org and a.ApprovedOn between @StartDT and @EndDT
),
cte2 as --找出300组织时间区间范围内的所有有来源单号的采购订单及采购订单行：39663行
(
	select
--		d.PurchaseOrder,	--采购ID
		c.CreatedOn,			--采购订单制单时间
		c.CreatedBy,			--采购订单制单人
		c.DocNo,				--采购单号
		c.Supplier_ShortName,	--供应商
		d.ID,					--行ID
		d.DocLineNo,			--行号
		d.PRNO,					--请购单号
		d.PurQtyTU,				--采购数量
	--	d.SrcDocInfo_SrcDocNo,	--来源单号
		d.ItemInfo_ItemID,		--料品ID
		d.ItemInfo_ItemCode,	--料号
		d.ItemInfo_ItemName		--料品名
	from PM_PurchaseOrder c left join PM_POLine d on c.ID=d.PurchaseOrder
	where c.Org=@Org and d.PRNO<>''
),
cte3 as
(
	select e.ID,e.Code,e.Name,e.DescFlexField_PrivateDescSeg23 
	from CBO_ItemMaster e
	where e.Org=@Org 
)
--查询时间区间内采购单采购数量>=请购单核准数量,且满足PR审核时间与PO制单时间小于24小时
insert into #temp_Result
select	t1.DocNo,
		t2.DocNo AS DO,
--		t2.PRNO,
		t1.ApprovedOn,
		t2.CreatedOn,
		t1.ApprovedQtyPU,
		t2.PurQtyTU,
--		t1.ItemInfo_ItemID,
		t1.ItemInfo_ItemCode,
		t1.ItemInfo_ItemName,
		t3.DescFlexField_PrivateDescSeg23
from cte1 t1 left join cte2 t2 on t1.DocNo=t2.PRNO and t1.ItemInfo_ItemID=t2.ItemInfo_ItemID
	inner join cte3 t3 on t1.ItemInfo_ItemID=t3.ID
where t2.PurQtyTU>=t1.ApprovedQtyPU and t1.ApprovedOn between @StartDT and @EndDT 
	and t3.DescFlexField_PrivateDescSeg23=@DescFlexField_PrivateDescSeg23
	and DATEDIFF(HH,t1.ApprovedOn,t2.CreatedOn)<24;
select *,ROW_NUMBER()over(order by PR_DocNo)from #temp_Result ;
set @CountPr=(select COUNT(*) from PR_PR a left join PR_PRLine b on a.ID=b.PR where a.Org=@Org and a.ApprovedOn between @StartDT and @EndDT) ;
set @CountPrPo=(select count(*)from #temp_Result);
if @CountPr<>0
begin
	select @Ratio=@CountPrPo*100.0/@CountPr ;	--及时率=请购转采购的总数/总的请购数
end
end
