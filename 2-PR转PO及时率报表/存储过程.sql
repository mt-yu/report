SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		lj
-- Create date: 2018/12/10
-- Description:	PRתPO��ʱ�ʱ���
-- =============================================
alter PROCEDURE P_PR_PO_TimelinessRate 
(
	@Org BIGINT = '1001708020135665',--��֯
	--@Code varchar(50),			--�Ϻ�
	@StartDT datetime,				--��ʼʱ��
	@EndDT datetime 					--����ʱ��
)
AS
BEGIN
	--SET @Org = '1001708020135665'
	--SET @EndDT  = DATEADD(day,1,@EndDT)	--�������� ��һ��
	IF object_id(N'tempdb.dbo.#temp_Result',N'U') is null
		BEGIN
		CREATE TABLE #temp_Result(			--������Ž���ı�
			
			PO_DocNo  nvarchar(50),				--�ɹ�����
			POLine_SrcDocInfo_SrcDocNo nvarchar(50), --�ɹ������е���Դ���У�����Ӧ���빺���У�
			POLine_SrcDocInfo_SrcDocLineNo INT, --��Դ�����к�
			POLine_ID BIGINT,				--�ɹ�����ID
			PO_Createdon datetime,			--PO �Ƶ�ʱ��
			POLine_PurQtyTU Decimal,		--�ɹ����еĲɹ�����
			POLine_ItemInfo_ItemCode nvarchar(50),		--�ɹ������Ϻ�

			PR_DocNo  NVARCHAR(50),			--�빺����
			PRLine_ID BIGINT,				--�빺����ID
			PRLine_DocLineNo INT,			--�빺���к�
			PR_Approvedon datetime,			--PR ���ʱ��
			PRLine_ApprovedQtyPU Decimal,	--�빺���еĺ�׼���������ɹ����� ����������
			--PRLine_ItemInfo_ItemCode BIGINT		--�빺�����Ϻ�

			--Timeliness	NVARCHAR(4)	default ''			--�Ƿ�ʱ	
		)
		END
	ELSE
		BEGIN
		TRUNCATE TABLE #temp_Result			--ɾ�������У� �ٶȿ�Щ
		END
	;

	WITH TEST AS -- �ҳ�ʱ�䷶Χ�ڵ������빺����
	(
		select A.DocNo �ɹ�����,B.SrcDocInfo_SrcDocNo ��Դ����,B.SrcDocInfo_SrcDocLineNo ��Դ�к�, B.PurchaseOrder �ɹ�����ID, A.CreatedOn �ɹ��Ƶ�ʱ��, B.PurQtyTU �ɹ�����, B.ItemInfo_ItemCode �ɹ��Ϻ� from PM_PurchaseOrder A LEFT JOIN PM_POLine B ON A.ID = B.PurchaseOrder WHERE  A.Org = @Org AND B.SrcDocInfo_SrcDocNo <> '' AND B.CreatedOn BETWEEN @StartDT AND @EndDT 

	),
	TSET_T AS	--�ҳ�ʱ�䷶Χ�ڵ������빺��ת�����Ĳɹ�����
	(
		select A.DocNo �빺����, B.PR �빺����ID, B.DocLineNo �빺�����к�, A.Approvedon �빺���ʱ�� , B.ApprovedQtyPU �빺���� from PR_PR A LEFT JOIN PR_PRLine B ON A.ID = B.PR WHERE  A.Org = @Org AND B.CreatedOn BETWEEN @StartDT AND @EndDT 
	)
	INSERT INTO #temp_Result SELECT a.*,b.* FROM TEST A LEFT JOIN TSET_T B ON B.�빺���� = A.��Դ���� WHERE B.�빺�����к� = A.��Դ�к� AND B.�빺���� <= A.�ɹ�����
	
	alter table #temp_Result add 
		Timeliness nvarchar(4)		-- ������Ľ����ʱ�� �¼��뼰ʱ����ʱ�ֶ�
	--	ExecutivePurchaserNo BIGINT		-- ���������ʱ���м���ִ�вɹ�Ա���

	-- �жϼ�ʱ����ʱ �����޸ı����ֶ�
	update #temp_Result  set Timeliness='��ʱ' where Datediff(hh,#temp_Result.PR_Approvedon,#temp_Result.PO_Createdon ) < 24 
	update #temp_Result  set Timeliness='����ʱ' where Datediff(hh,#temp_Result.PR_Approvedon,#temp_Result.PO_Createdon ) >= 24 
	

	select A.POLine_ItemInfo_ItemCode, A.PO_DocNo,A.PR_DocNo,A.Timeliness, B.DescFlexField_PrivateDescSeg23 ִ�вɹ���� into #temp_t from  #temp_Result A left join CBO_ItemMaster B ON A.POLine_ItemInfo_ItemCode = B.Code where  B.Org = @Org order by A.Timeliness,A.PO_DocNo
	--INSERT INTO #temp_Result ExecutivePurchaserNo values (select DescFlexField_PrivateDescSeg23 from  #temp_Result A left join CBO_ItemMaster B ON A.POLine_ItemInfo_ItemCode = B.Code where  B.Org = '1001708020135665')

	--SELECT A.PO_DocNo �ɹ�����,COUNT (*) �ɹ����м���  FROM #temp_Result A group by A.PO_DocNo order by A.PO_DocNo
	
	--SELECT  A.POLine_ItemInfo_ItemCode, A.PO_DocNo,A.PR_DocNo,A.Timeliness FROM #temp_Result A order by A.Timeliness,A.PO_DocNo 
	select * into #temp_tt from #temp_t where #temp_t.ִ�вɹ���� <> '' order by Timeliness
	
	--select * from #temp_tt
	--Select Timeliness, COUNT(*) ���� from #temp_tt group by Timeliness

	select A.ִ�вɹ���� ,A.Timeliness , COUNT(*)���� into #temp_ttt from #temp_tt A group by A.ִ�вɹ����, A.Timeliness ORDER BY A.ִ�вɹ����
	
	select A.ִ�вɹ���� ,SUM(a.����) ��ʱ�� into #temp_jishi from #temp_ttt A where A.Timeliness = '��ʱ'group by A.ִ�вɹ���� 
	select A.ִ�вɹ���� ,SUM(a.����) ���� into #temp_sum from #temp_ttt A group by A.ִ�вɹ���� 
	--select * from #temp_jishi
	--select * from #temp_sum

	select A.ִ�вɹ����,B.��ʱ��,A.����,ROUND(CAST(B.��ʱ�� AS FLOAT)/A.����, 2) ��ʱ�� INTO #temp_jishilv from #temp_sum A left join #temp_jishi B ON A.ִ�вɹ���� = B.ִ�вɹ����
	select * from  #temp_jishilv
END
GO
EXEC P_PR_PO_TimelinessRate '1001708020135665', '2018-11-25', '2018-12-10'

--select *z from CBO_ItemMaster where Code = '202010444' and Org = '1001708020135665'

select * from CBO_Operators where org = 1001708020135665

select * from CBO_Department where org = 1001708020135665

SELECT * FROM Base_WorkCalendar