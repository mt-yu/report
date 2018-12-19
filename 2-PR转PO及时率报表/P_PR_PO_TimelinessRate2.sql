USE [U9TEST1129]
GO
/****** Object:  StoredProcedure [dbo].[P_PR_PO_TimelinessRate2]    Script Date: 2018/12/19 17:04:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[P_PR_PO_TimelinessRate2]
(
	@Org bigint,		--组织
	@StartDT datetime,       --起始时间
	@EndDT	datetime,		 --结束时间
	@DescFlexField_PrivateDescSeg23 nvarchar(20) --执行采购员
)
as 
begin
	with cte1 as
	(
		select a.docno,		--请购单号
--				a.ApprovedBy,	--审核人
				a.ApprovedOn,	--审核日期
				b.ItemInfo_ItemID,--料品ID
				b.ItemInfo_ItemCode,--料号
				b.ItemInfo_ItemName,--料品名
				b.ApprovedQtyPU,		--核准数量
				e.DescFlexField_PrivateDescSeg23
		from PR_PR a left join PR_PRLine b on a.ID=b.PR 
			inner join CBO_ItemMaster e on b.ItemInfo_ItemID=e.ID
		where a.Org=@Org and a.ApprovedOn between @StartDT and @EndDT
	),
	cte2 as --找出300组织有来源单号的采购订单及采购订单行
	(
		select c.DocNo ff,				--采购单号
				c.CreatedOn,			--采购订单制单时间
				c.CreatedBy,			--采购订单制单人				
				d.PRNO,					--请购单号
				d.PurQtyTU,				--采购数量
				d.ItemInfo_ItemID		--料品ID
		from PM_PurchaseOrder c left join PM_POLine d on c.ID=d.PurchaseOrder 
		where c.Org=@Org and d.PRNO<>''
	)
	select *,
	(case when (t1.ApprovedQtyPU<=t2.PurQtyTU and DATEDIFF(HH,t2.CreatedOn,t1.ApprovedOn)<24) then '及时' else '逾期' end)MARK
	from cte1 t1 left join cte2 t2 on t1.DocNo=t2.PRNO and t1.ItemInfo_ItemID=t2.ItemInfo_ItemID
	where t1.ApprovedOn between @StartDT and @EndDT 
		and t1.DescFlexField_PrivateDescSeg23=@DescFlexField_PrivateDescSeg23
end