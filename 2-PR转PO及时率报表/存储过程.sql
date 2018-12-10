SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		lj
-- Create date: 2018/12/10
-- Description:	PRתPO��ʱ�ʱ���
-- =============================================
CREATE PROCEDURE P_PR_PO_TimelinessRate 
(
	@Org BIGINT = '1001708020135665',		--��֯
	--@Code varchar(50),						--�Ϻ�
	@StartDT datetime = '2017-09-04',						--��ʼʱ��
	@EndDT datetime	 = '2018-07-31'					--����ʱ��
)
AS
BEGIN

	SET @EndDT  = DATEADD(day,1,@EndDT)	--�������� ��һ��
	IF object_id(N'tempdb.dbo.#temp_Result',N'U') is null
		BEGIN
		CREATE TABLE #temp_Result(			--������Ž���ı�
			
			PO_DocNo  nvarchar(50),				--�ɹ�����
			POLine_SrcDocInfo_SrcDocNo nvarchar(50), --�ɹ������е���Դ���У�����Ӧ���빺���У�
			POLine_SrcDocInfo_SrcDocLineNo INT, --��Դ�����к�
			POLine_ID BIGINT,				--�ɹ�����ID
			PO_Createdon datetime,			--PO �Ƶ�ʱ��
			POLine_PurQtyTU Decimal,		--�ɹ����еĲɹ�����
				
			
			PR_DocNo  NVARCHAR(50),			--�빺����
			PRLine_ID BIGINT,				--�빺����ID
			PRLine_DocLineNo INT,			--�빺���к�
			PR_Approvedon datetime,			--PR ���ʱ��
			PRLine_ApprovedQtyPU Decimal,	--�빺���еĺ�׼���������ɹ����� ����������

			--TimelinessRate	NVARCHAR(4)	default ''			--�Ƿ�ʱ	
		)
		END
	ELSE
		BEGIN
		TRUNCATE TABLE #temp_Result			--ɾ�������У� �ٶȿ�Щ
		END
	

	if OBJECT_ID('tempdb..#temp') is not null
		drop table #temp
	BEGIN
			CREATE TABLE #temp(
			ID BIGINT,
			CREATEON DATETIME
		)
	END;

	WITH TEST AS -- �ҳ�ʱ�䷶Χ�ڵ������빺����
	(
		select A.DocNo �ɹ�����,B.SrcDocInfo_SrcDocNo ��Դ����,B.SrcDocInfo_SrcDocLineNo ��Դ�к�, B.PurchaseOrder �ɹ�����ID, A.CreatedOn �ɹ��Ƶ�ʱ��, B.PurQtyTU �ɹ����� from PM_PurchaseOrder A LEFT JOIN PM_POLine B ON A.ID = B.PurchaseOrder WHERE  A.Org = @Org AND B.SrcDocInfo_SrcDocNo <> '' AND B.CreatedOn BETWEEN @StartDT AND @EndDT 

	),
	TSET_T AS	--�ҳ�ʱ�䷶Χ�ڵ������빺��ת�����Ĳɹ�����
	(
		select A.DocNo �빺����, B.PR �빺����ID, B.DocLineNo �빺�����к�, A.Approvedon �빺���ʱ�� , B.ApprovedQtyPU �빺���� from PR_PR A LEFT JOIN PR_PRLine B ON A.ID = B.PR WHERE  A.Org = '1001708020135665' AND B.CreatedOn BETWEEN @StartDT AND @EndDT 
	)
	INSERT INTO #temp_Result SELECT a.*,b.* FROM TEST A LEFT JOIN TSET_T B ON B.�빺���� = A.��Դ���� WHERE B.�빺�����к� = A.��Դ�к� AND B.�빺���� <= A.�ɹ�����
	alter table #temp_Result add TimelinessRate nvarchar(4) default ''
	-- �жϼ�ʱ����ʱ �����޸ı����ֶ�
	update #temp_Result  set TimelinessRate='��ʱ' where Datediff(hh,#temp_Result.PR_Approvedon,#temp_Result.PO_Createdon ) < 24 
	update #temp_Result  set TimelinessRate='����ʱ' where Datediff(hh,#temp_Result.PR_Approvedon,#temp_Result.PO_Createdon ) >= 24 

	--SELECT A.PO_DocNo �ɹ�����,COUNT (*) �ɹ����м���  FROM #temp_Result A group by A.PO_DocNo order by A.PO_DocNo
	SELECT  A.PO_DocNo,A.PR_DocNo,A.TimelinessRate FROM #temp_Result A order by A.TimelinessRate,A.PO_DocNo 
	
	Select TimelinessRate, COUNT(*) ���� from #temp_Result group by TimelinessRate
	
END
GO

EXEC P_PR_PO_TimelinessRate '1001708020135665', '2017-11-21','2018-12-10'	

