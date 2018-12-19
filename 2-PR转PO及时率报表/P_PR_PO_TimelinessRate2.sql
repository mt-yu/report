USE [U9TEST1129]
GO
/****** Object:  StoredProcedure [dbo].[P_PR_PO_TimelinessRate2]    Script Date: 2018/12/19 17:04:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[P_PR_PO_TimelinessRate2]
(
	@Org bigint,		--��֯
	@StartDT datetime,       --��ʼʱ��
	@EndDT	datetime,		 --����ʱ��
	@DescFlexField_PrivateDescSeg23 nvarchar(20) --ִ�вɹ�Ա
)
as 
begin
	with cte1 as
	(
		select a.docno,		--�빺����
--				a.ApprovedBy,	--�����
				a.ApprovedOn,	--�������
				b.ItemInfo_ItemID,--��ƷID
				b.ItemInfo_ItemCode,--�Ϻ�
				b.ItemInfo_ItemName,--��Ʒ��
				b.ApprovedQtyPU,		--��׼����
				e.DescFlexField_PrivateDescSeg23
		from PR_PR a left join PR_PRLine b on a.ID=b.PR 
			inner join CBO_ItemMaster e on b.ItemInfo_ItemID=e.ID
		where a.Org=@Org and a.ApprovedOn between @StartDT and @EndDT
	),
	cte2 as --�ҳ�300��֯����Դ���ŵĲɹ��������ɹ�������
	(
		select c.DocNo ff,				--�ɹ�����
				c.CreatedOn,			--�ɹ������Ƶ�ʱ��
				c.CreatedBy,			--�ɹ������Ƶ���				
				d.PRNO,					--�빺����
				d.PurQtyTU,				--�ɹ�����
				d.ItemInfo_ItemID		--��ƷID
		from PM_PurchaseOrder c left join PM_POLine d on c.ID=d.PurchaseOrder 
		where c.Org=@Org and d.PRNO<>''
	)
	select *,
	(case when (t1.ApprovedQtyPU<=t2.PurQtyTU and DATEDIFF(HH,t2.CreatedOn,t1.ApprovedOn)<24) then '��ʱ' else '����' end)MARK
	from cte1 t1 left join cte2 t2 on t1.DocNo=t2.PRNO and t1.ItemInfo_ItemID=t2.ItemInfo_ItemID
	where t1.ApprovedOn between @StartDT and @EndDT 
		and t1.DescFlexField_PrivateDescSeg23=@DescFlexField_PrivateDescSeg23
end